# Plan del curso de Vim (Capdesis Academy)

Corte: 2026-11-11. Curso en la web: https://academy.capdesis.com/cursos/vim-mejora-velocidad-codificar

Este plan une los 5 videos editados (2021, IdeaVim) con el curso actual (m00 a m13), dice qué texto lleva cada lección y qué falta grabar.

## 1. Videos editados

Están en `editado/`. Cada uno lleva:

- Cortes de silencios y de las 2 tomas erróneas.
- Zoom suave en clics, menús y ediciones (1.25x).
- Zoom fuerte donde el plan lo pide (1.5x en el editor, 2x en la barra inferior de la parte 2).
- Ruta local y marcadores del navegador tapados.
- Color corregido.
- Logo de Capdesis arriba a la derecha.
- Audio a -16 LUFS.

El detalle y la verificación están en `editado/REPORTE-EDICION.md`.

| Archivo | Enseña |
|---|---|
| 01-modos-y-movimientos | Modos, h j k l, w b e, yy p dd u, V, i, dw, d2w, :wq :q! |
| 02-insertar-pegar-y-buscar | o O, p P, u, A I, / n N, * |
| 03-buscar-caracteres-y-borrar | f F t T ; , x X r s, dt) df, D, cw, ci( |
| 04-objetos-de-texto | gg G :N, ci( di( ci{ ci" yi(, dip diw, Ctrl-d Ctrl-u |
| 05-ventanas-y-lineas | Ctrl-w :sp, ^ $, u Ctrl-r, ~, L, . |

## 2. Dónde va cada video

| Módulo | Video | Cómo |
|---|---|---|
| m01 Modos | 01 | Lección "Modos y salir de Vim" |
| m02 Moverse | 01 + 03 | "h j k l y palabras"; "f t ;" |
| m03 Gramática | 01 + 03 | "Borrar, copiar y pegar"; "x r s D" |
| m04 Objetos | 04 | Lección completa |
| m05 Buscar | 02 | Solo / n N *: avisar que :s va aparte |
| m07 Ventanas | 05 | Ctrl-w y :sp |
| m12 IdeaVim | 01 a 05 | Nota: todo es IdeaVim en Android Studio |

Aviso fijo en cada lección con estos videos:

> Grabado en 2021 con IdeaVim en Android Studio. Las teclas son las mismas en Neovim 0.12. La instalación del plugin cambió: sigue el módulo m08.

No usar del audio original: "dos horas de curso" y "3 millones de descargas". Ya no son ciertas.

## 3. Texto de cada lección

Cada lección de video lleva lo mismo:

1. **Título** corto con las teclas (ej. "ci( y los objetos de texto").
2. **Qué vas a aprender**: 3 viñetas.
3. **Capítulos**: salen de la transcripción final (`03-analisis/verificacion/export-parte-N.json`).
4. **Subtítulos**: el mismo JSON pasado a VTT.
5. **Práctica**: el ejercicio de la web del mismo módulo. Solo cuenta si el resultado coincide **y** se usaron las teclas enseñadas.
6. **Resumen**: tabla tecla → qué hace.

## 4. Clips para YouTube

Se sacan de `editado/` con `03-analisis/herramientas/clips_promo.py`, en `editado/promo/`.

- Audio: -14 LUFS y pico ≤ -1.5 dBTP (lo pide el prompt original para YouTube; los cursos van a -16).
- Cada clip cierra con 3 s de "Curso completo gratis en academy.capdesis.com".
- Qué se publica lo decide el operador.
- Rangos y textos: `03-analisis/edicion/clips-promo.json`. Medición: `editado/promo/clips-medicion.json`.

## 5. Pasos en la web

1. Empaquetar cada video en HLS: `scripts/package-hls-video.sh`.
2. Subir a R2 y adjuntar a su lección (tabla de la sección 2).
3. Generar subtítulos VTT y capítulos desde las transcripciones.
4. Probar en producción: reproducir, reanudar, miniaturas, móvil.
5. PostHog (con consentimiento): abandono por video.

## 6. Qué falta grabar (Neovim 0.12.6)

| Módulo | Contenido |
|---|---|
| m00 | Bienvenida nueva |
| m05 | ? # :s :%s |
| m06 | Registros y macros |
| m07 | Buffers y terminal |
| m08 | Instalar la configuración |
| m09 | Telescope, LSP, Git |
| m10 | IA con Neovim |
| m11 | gcc gc s y plugins |
| m13 | :checkhealth :Lazy :Mason |

Cómo grabar para que la edición salga mejor:

- Fuente del editor grande (18 pt o más).
- Overlay de teclas lejos de la webcam.
- Sin rutas personales en la barra de título.
- Decir en voz alta "corta" en las tomas malas.
- Una idea por toma.

## 7. Cómo se edita

Guía para agentes: `04-davinci/COMO-EDITAR-CURSOS.md`. La receta paso a paso está en su sección 2.
Scripts: `03-analisis/herramientas/`.

## 8. Pendientes del operador

- Activar Cloudflare Stream y sus claves.
- Clave de PostHog y retención en el aviso de privacidad.
- Cuenta real para probar el flujo con sesión.
- Elegir qué clips van a YouTube.
