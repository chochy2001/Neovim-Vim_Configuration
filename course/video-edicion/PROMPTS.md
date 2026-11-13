# Prompts para el agente de edición (DaVinci Resolve vía MCP)

Copia cada bloque tal cual en el agente que tiene conectado el servidor MCP `davinci-resolve`. Ejecútalos en orden: a, luego b (parte 1 a 5), c, d, e y f. Cada prompt es autocontenido, pero asume que el paso anterior terminó bien.

Rutas (ajústalas solo si cambias la carpeta del proyecto):

- Proyecto: `~/Movies/Capdesis-Curso-Vim`
- Originales (solo lectura): `~/Movies/Capdesis-Curso-Vim/01-crudo/` (`parte 1.mp4` a `parte 5.mp4`)
- Análisis: `~/Movies/Capdesis-Curso-Vim/03-analisis/` (`edicion/parte-N.json`, `zoom-plan.md`, `transcripts/`)
- Salida: `~/Movies/Capdesis-Curso-Vim/05-exportados/`

---

## (a) Comprobación inicial

```
Eres el agente de edición de un curso de Vim en DaVinci Resolve. Trabajas solo a través del servidor MCP "davinci-resolve".

Reglas que no se negocian:
- Nunca modifiques, muevas, renombres ni recodifiques los archivos de ~/Movies/Capdesis-Curso-Vim/01-crudo/. Solo importarlos al Media Pool de Resolve por ruta.
- No crees proxies, transcodificaciones ni derivados de los originales.
- No subas nada a internet ni uses git ni gh.
- No borres ningún archivo fuera de 05-exportados/ sin preguntar.

Haz esto y repórtame el resultado de cada punto:
1. Confirma que el MCP responde: consulta la versión de Resolve y la edición (Studio o free) con la herramienta de control del servidor. Si no hay conexión, dime exactamente qué error devuelve y para. No sigas sin conexión.
2. Comprueba que Resolve está en Studio (scripting externo solo funciona en Studio). Si no lo está, para.
3. Crea o abre el proyecto llamado "Curso Vim 2026". Si ya existe, úsalo y no lo dupliques.
4. Crea una línea de tiempo llamada "Curso Vim 2026 - Principal" con resolución 1920x1080 y 60 fps. Si ya existe una con ese nombre, dímelo antes de tocarla.
5. Importa los cinco archivos de 01-crudo/ al Media Pool, en una carpeta "Originales". Comprueba que cada clip tiene 1920x1080, 60 fps, H.264 y audio AAC 48 kHz estéreo, y que las duraciones son 1175.7, 657.3, 840.0, 961.8 y 956.4 s (tolerancia de 0.1 s).
6. Confirma que los cinco archivos siguen intactos: tamaño y fecha de modificación de cada uno igual a los de antes de empezar. Si alguno cambió, para y avísame.

Entrega: una tabla con cada punto, OK o FALLO, y el valor medido. No sigas al paso siguiente hasta que todo esté OK.
```

---

## (b) Cortes por parte

Repite este bloque una vez por parte (N = 1, 2, 3, 4, 5). Antes de aplicar nada, lee `03-analisis/edicion/parte-N.json`.

```
Trabaja solo con la parte N = <N> del curso Vim. Lee ~/Movies/Capdesis-Curso-Vim/03-analisis/edicion/parte-<N>.json (campo "items"). Cada item tiene: id, type, confidence (high, medium o low), in y out en segundos de origen, in_tc y out_tc en HH:MM:SS:FF a 60 fps, reason, before, after y words_inside_cut.

Reglas:
- Solo aplica los items con confidence "high" y type "dead_air", "false_start_wrong_take" o "stumble_error_retake". Antes de aplicar cada uno, comprueba que su rango no contiene ninguna palabra (la lista words_inside_cut debe estar vacía, salvo en los items de tipo false_start o stumble, que se cortan a propósito).
- No apliques "medium" ni "low". Para los "medium", muéstrame una lista con id, in_tc, out_tc, dur, reason, before y after, y espera mi OK por id antes de aplicar cada uno.
- Corta usando las marcas de tiempo de la línea de tiempo "Curso Vim 2026 - Principal". Ajusta cada corte en el clip de origen (no en el reproductor). Deja los 0.25 s de relleno que ya vienen en in/out.
- Cada corte debe ser un "ripple delete" (cerrar el hueco), para que el audio y el vídeo sigan sincronizados. Confirma que el audio se corta en el mismo punto.
- No cortes dentro de una palabra. Si un corte cae a menos de 0.1 s de una palabra, para y avísame.
- Después de aplicar, exporta la lista de cortes aplicados a 03-analisis/edicion/aplicados-parte-<N>.json con id, in_tc, out_tc y resultado. Usa esa lista para la verificación final (paso f).

Entrega: (1) lista de items aplicados con su resultado, (2) lista de items "medium" pendientes de mi OK, (3) duración de la parte antes y después de los cortes aplicados, comparada con la estimación de edicion/parte-<N>.json (est_after_high_s).
```

---

## (c) Zooms

```
Aplica los zooms de ~/Movies/Capdesis-Curso-Vim/03-analisis/zoom-plan.md en la línea de tiempo "Curso Vim 2026 - Principal". Cada entrada tiene ID, parte, inicio y fin en segundos de origen, escala, rectángulo en píxeles de origen [x, y, ancho, alto] y motivo. Los datos del plan vienen también en 03-analisis/frames/zoom-plan.json.

Reglas:
- Usa la escala indicada (1.5x para el editor, 2x para la barra inferior derecha). Encuadra con Dynamic Zoom o con Transform (Zoom X/Y y Pan/Tilt), con el punto de origen en el centro del rectángulo. Comprueba que la imagen de salida no se sale del fotograma y que no aparece la webcam ni la caja negra del overlay de teclas.
- Easing: entrada 0.5 s y salida 0.5 s, curva ease-in-out. Duración = la indicada en "duration_s".
- Aplica los zooms después de los cortes (paso b), usando los tiempos de la línea de tiempo ya editada. Si un corte mueve el tiempo de un zoom, recalcula la posición con los mismos tiempos de origen (clip y tiempo de origen) y dímelo.
- Antes de cerrar cada zoom, saca un fotograma de prueba del lugar donde empieza y del punto medio, y compáralo con el rectángulo previsto. Guarda los dos fotogramas en 03-analisis/frames/zooms-verificacion/ con el nombre <ID>-inicio.jpg y <ID>-medio.jpg.
- Si algún zoom no encuadra bien, no lo fuerces: márcalo como pendiente con su ID y el motivo.

Entrega: tabla con ID, aplicado (sí o no), escala, rectángulo final, fotogramas de verificación, y pendientes.
```

---

## (d) Audio

```
Normaliza y limpia el audio de la línea de tiempo "Curso Vim 2026 - Principal" con estos criterios:

1. Loudness: normalización a -16 LUFS integrados (objetivo de YouTube para la versión principal), true peak máximo -1.5 dBTP. Usa Fairlight (medición EBU R128) y mide antes y después. Si tienes que elegir otro objetivo, usa -14 LUFS solo para los clips de promoción y dímelo.
2. Reducción de ruido: ligera (la que ofrece Fairlight, con reducción de ruido de fondo moderada). No la subas por encima de lo que suene natural. Mide el ruido de fondo antes (P10 de ~-80 a -90 dBFS según el archivo, ver 03-analisis/silencios/noise-floor-measurements.jsonl) y dime qué pusiste.
3. Sin música, sin efectos, sin sonido de ambiente, salvo que yo lo pida explícitamente.
4. No cambies el tono ni la velocidad.
5. Revisa que no haya clipping (picos por encima de -1 dBFS).

Entrega: LUFS integrados y true peak antes y después, reducción de ruido aplicada (valor), y cualquier clip en el que no fue posible cumplir el objetivo.
```

---

## (e) Exportación

```
Exporta la línea de tiempo "Curso Vim 2026 - Principal" a ~/Movies/Capdesis-Curso-Vim/05-exportados/.

Ajustes:
- Formato: MP4. Códec: H.264 (predeterminado). Si H.265 es necesario, avísame antes; H.264 es el objetivo por compatibilidad.
- Resolución: 1920x1080. Frame rate: 60 fps. Sin cambios de encuadre.
- Audio: AAC 48 kHz estéreo, la misma normalización del paso (d).
- Calidad: alta (bitrate de vídeo de 15 a 20 Mb/s en H.264 para 1080p60).

Un archivo por parte, con el nombre NN-titulo.mp4 (NN = número de parte con dos dígitos, sin espacios ni acentos):
- 01-introduccion-y-movimiento.mp4 (parte 1)
- 02-o-p-y-busqueda.mp4 (parte 2)
- 03-f-t-r-s-x.mp4 (parte 3)
- 04-objetos-de-texto.mp4 (parte 4)
- 05-ventanas-y-lineas.mp4 (parte 5)

Antes de exportar, pregúntame si los títulos están bien. No sobrescribas un archivo que ya exista en 05-exportados/: añade "-v2" y dímelo.

Después de exportar, por cada archivo: duración con ffprobe (no con Resolve), resolución, fps y códecs. Guarda el resultado en 05-exportados/verificacion-ffprobe.txt.

Entrega: lista de archivos, tamaño, duración (ffprobe) y ajustes usados.
```

---

## (f) Verificación

```
Verifica cada archivo exportado en 05-exportados/ contra su EDL y contra la transcripción del original. No des nada por bueno sin medirlo.

Para cada parte N = 1 a 5:

1. Duración: compara la duración del archivo exportado (ffprobe) con la estimación de 03-analisis/edicion/parte-N.json (est_after_high_s, o est_after_high_medium_s si aplicaste medium con mi OK). La diferencia debe ser menor de 0.1 s por corte aplicado. Si no, avísame.

2. Transcripción del export: con el Python del proyecto, transcribe el export con mlx-whisper:
   ~/Movies/Capdesis-Curso-Vim/.venv/bin/python -I <script> <ruta>
   El modelo es mlx-community/whisper-large-v3-turbo, idioma es. Guarda el resultado en 03-analisis/verificacion/export-parte-N.json y .txt.
   Usa el script de transcripción que ya existe en el proyecto; no inventes uno nuevo sin decírmelo.

3. Diff de transcripciones: compara 03-analisis/transcripts/parte-N.txt con la transcripción del export, palabra por palabra (normalizando acentos y mayúsculas). Clasifica cada diferencia:
   a) Palabra eliminada que debía quedarse (contenido enseñado perdido): ERROR. Lista cada una con su tiempo en el original y en el export.
   b) Palabra eliminada que estaba en un corte previsto (esperado): OK.
   c) Palabra cortada a medias (la transcripción del export empieza o termina una palabra incompleta junto a un corte): ERROR.
   d) Palabra repetida o restaurada que no debía estar (una toma errónea que sigue en el export): ERROR.

4. Muletillas y tropiezos restantes: lista todo lo que siga en el export y que parezca tropiezo: "eh", "mmm", "este" usado como muletilla, "o sea" repetido, frases que se repiten de inmediato, palabras truncadas, silencios de más de 2.5 s sin pantalla estática. Para cada uno: tiempo en el export, texto alrededor (6 palabras antes y después) y tu recomendación.

5. Compara el número de palabras de contenido original con el export (excluyendo los cortes aplicados) y dame el porcentaje conservado.

Nota: Whisper confunde "Esc" con "Skip", IdeaVim con "BIM" y JetBrains con "JETURINGS". No cuentes esas diferencias como errores de edición; cuéntalas aparte.

Entrega: por parte, una tabla con duración esperada, duración real, diferencia, errores tipo a, c y d, cortes esperados, y la lista de tropiezos restantes. Al final, un veredicto por parte: APROBADO, APROBADO CON AVISOS o NO APROBADO, con el motivo. No marques APROBADO si hay un error tipo a, c o d.
```

---

## Extra: clips de promoción para YouTube

```
A partir de los exportados de 05-exportados/ (no del original), crea clips cortos de promoción para YouTube. Usa las marcas de 03-analisis/mapa-del-curso.md (sección "Clips de promoción"), pero verifica cada marca mirando el vídeo: son aproximadas.

Reglas:
- Duración de 30 a 60 s por clip. Empieza en una frase completa y termina en una frase completa, nunca dentro de una palabra.
- Formato vertical 1080x1920 (9:16) para Shorts, con el editor centrado (usa el zoom 1.5x del plan si hace falta). Y un formato horizontal 1920x1080 de respaldo.
- Subtítulos: quema el texto de la transcripción del tramo, en español, legible, sin tapar el código.
- Sin música salvo que yo lo pida. Audio normalizado a -14 LUFS para promoción.
- Nombre: promo-NN-titulo-vertical.mp4 y promo-NN-titulo-horizontal.mp4 en 05-exportados/promo/.
- No publiques nada ni subas a YouTube. Solo genera los archivos.

Entrega: lista de clips, marca de inicio y fin de origen, duración, formato, y los títulos y descripciones sugeridos (en español, sin usar guiones largos).
```

---

## Notas para el operador

- Si el agente pide algo fuera de estos pasos, pregúntale primero por qué.
- Si el MCP no conecta, no sigas: revisa `04-davinci/LEEME.md`, sección "Conectar el MCP".
- Los archivos de `03-analisis/edicion/` son propuestas. Los "high" sustituyen a un corte manual solo tras comprobar la verificación (paso f).
