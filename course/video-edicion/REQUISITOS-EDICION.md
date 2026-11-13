# Requisitos de edición del operador

Fuente: mensajes del operador, 2026-11-11. Valen para TODOS los cursos de Capdesis Academy, no solo Vim. Si una regla técnica choca con esto, se pregunta al operador.

## Cortes

- Cortar los silencios: cuando no está hablando **y** no está mostrando nada en pantalla.
- Si muestra algo sin hablar (escribe, se mueve el cursor, sale un resultado), no se corta. Como mucho se acorta la pausa a 1.5 s.
- Si ese tramo mudo con acción dura más de 8 s, se acelera (2x o 3x) en vez de cortarlo: se ve todo y no se hace lento (decisión de edición aceptada en este curso; el operador puede pedir otra cosa).
- Repeticiones: si dice lo mismo varias veces porque se equivocó, se deja **solo la última versión buena**.
- Los repasos a propósito (repetir un comando para que se vea) se quedan.
- Nunca cortar dentro de una palabra. Ante la duda, no cortar y anotarlo.

## Zooms

- Zoom cada vez que se da clic, se abre un menú o pasa algo en una zona pequeña. Así se lee dónde se da clic.
- Zooms **suaves**: cambio leve, con entrada y salida suaves. Nunca bruscos.
- Pensar en el móvil: que no haga falta pellizcar para leer.
- Los crudos son 1920x1080. El zoom amplía píxeles: no pasar de 1.5x salvo petición explícita (2x en la barra inferior de la parte 2).
- Si en el futuro se graba en 2K o 4K y se entrega en 1080p, se puede hacer más zoom sin perder calidad.

## Logo de Capdesis

- Siempre visible, arriba a la derecha por defecto.
- Colores originales del logo. No recolorear nunca.
- No debe tapar contenido. Si tapa algo (por ejemplo al quitar un zoom), se mueve a otra zona libre.

## Imagen

- Corrección de color suave. El texto del código debe quedar nítido y legible.
- Exportar en 1080p (1920x1080, 60 fps).
- Que no sea solo la grabación plana: intro y cierre con la marca, transiciones suaves.

## Privacidad

- Tapar rutas locales (F:\...), marcadores del navegador, correos, tokens y proyectos de clientes.

## Audio

- -16 LUFS integrados y pico real de -1.5 dBTP como máximo.
- Reducción de ruido ligera. Sin música de fondo bajo la voz.
- Música solo en intro y cierre (pedido del operador, 2026-11-11): cortinilla propia, sin derechos de terceros.
- Clips de YouTube: -14 LUFS (prompt original del operador).
- Escuchar o transcribir el resultado: que tenga sentido y que no se haya cortado de más.

## Verificación (sin falsos positivos)

- Nada se da por bueno sin medirlo: render real, ffprobe, transcripción del export y fotogramas.
- Revisión por varios agentes.
- Reporte con lo aprobado y lo pendiente, sin maquillar.

## Visor de teclas (pedido del operador, 2026-11-12)

- La caja negra de la herramienta de Windows que muestra las teclas se ve mal: se tapa con un parche del color
  del panel de la IDE. El parche va en la capa que sigue el zoom (V2), así tapa la caja exacta en cualquier encuadre.
- Se sustituye por teclas nuevas (estilo tecla física sobre una pastilla oscura) en una capa SIN zoom (V4):
  siempre visibles y nítidas, aunque haya zoom, para ver cómo afecta cada tecla en Vim. Al operador le gustó este formato.
- Letras en minúscula si no hay Shift (Vim distingue `d` de `D`). Ctrl izquierdo + Alt derecho = AltGr.
- Lectura de teclas: OCR local + plantillas + revisión visual por agentes. Lo que no valida no se muestra.

## Animaciones Fusion (pedido del operador, 2026-11-12)

- Además de la captura de pantalla, animaciones hechas en Fusion que complementen lo que se explica:
  tarjeta con el comando en teclas, qué hace y una demo de una línea con el cursor animado.
- El contenido debe ser correcto en Vim aunque el audio se equivoque (etiqueta "CORRECCIÓN").
- Cada demo se valida ejecutándola en Neovim real. No deben tapar contenido.

## Silencios (2026-11-12)

- Ningún silencio largo debe quedar: si tras acelerar a 2x/3x sigue largo y hay acción, segunda pasada a 6x.

## Entrega (2026-11-12)

- Al terminar, abrir la carpeta `editado/` en Finder para que el operador revise y dé feedback.
- Avisar al operador cuando los videos estén listos, con lo medido y lo que queda pendiente (sin decir "listo" sin medirlo).
- Revisar que los ZIP o descargas del curso tengan todos los videos (el curso gratis de Vim son 5).
- Cada corrección o petición nueva se guarda en este archivo, en la memoria del agente y en el repo.

## Ronda 2 (2026-11-12, tras ver los videos)

- Si no habla, se corta (aunque se mueva). Ritmo dinámico.
- Tomas malas o repetidas: se quita la mala; comparar lo dicho con lo que pasa.
- Zoom a lugares que nombra y a la línea de comandos (`:w`, `:q!`, `/`); los zooms siempre dejan ver los números de línea.
- Cara ampliada (sin pixelar) cuando habla a cámara sin pulsar nada.
- Tarjeta para TODOS los comandos, siempre después de nombrarlos (sin spoilers). Marcas con su icono.
- Insignia de marca: SOLO el icono y el nombre ("Vim", "IntelliJ"). Nada de etiquetas como "MENCIONADO": se ve mal (operador, 2026-11-13).
- Intro con los comandos de la parte; resumen final con las tarjetas animadas.
- La caja de teclas vieja no debe asomar nunca.
- Crudos renombrados con su título (lo pidió el operador).

## Herramientas

- Usar el MCP de DaVinci Resolve lo más posible. Lo que la API no permite, con scripts externos de Resolve o ffmpeg, y documentarlo.
- computer use está permitido, pero en este proyecto interrumpió la sesión 3 veces sobre Resolve. Usarlo solo si no hay otra vía.

## Documentación

- Todo lo aprendido va a `04-davinci/COMO-EDITAR-CURSOS.md`, a la memoria del agente y al repositorio del curso.
- Debe leerse bien en pantallas pequeñas: secciones cortas, tablas de pocas columnas.

---

Cómo se cumple cada punto y qué sigue pendiente: `COMO-EDITAR-CURSOS.md`, secciones 16 y 18.
