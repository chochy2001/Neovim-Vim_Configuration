# Edición de video de los cursos

Cómo se editan los videos de los cursos de Capdesis Academy con DaVinci Resolve Studio
(MCP y scripting) y ffmpeg. Probado con el curso de Vim (5 partes, noviembre de 2026).

Empieza por aquí, en este orden:

1. `REQUISITOS-EDICION.md`: lo que pide el operador. Vale para todos los cursos.
2. `COMO-EDITAR-CURSOS.md`: la guía. Su sección 2 es la receta paso a paso.
3. `BUENAS-PRACTICAS-RESOLVE.md`: Media, Cut, Edit, Fusion, Color, Fairlight y Deliver, con fuentes.
4. `PLAN-CURSO-VIM.md`: cómo encajan los videos de Vim en el curso y la web.

`herramientas/` tiene los scripts. Copia de trabajo: `~/Movies/Capdesis-Curso-Vim/03-analisis/herramientas/`.
Si cambias un script allí, cópialo aquí también.

`datos/` tiene las revisiones hechas a mano que los scripts leen desde `03-analisis/edicion/` del proyecto:
`correcciones-tarjetas.json` (qué tarjetas llevan CORRECCIÓN, E44) y `comandos-revisados.json` (texto real de un comando
que el OCR del crudo leyó mal, E46). Para otro curso se empiezan vacíos.

Reconstrucción completa: sección 2.13 de la guía (`reconstruir_todo.sh clips-vN capas-ver`). Lecciones: E1-E58 y sección 17.

Los videos no van en este repositorio: viven en `~/Movies/Capdesis-Curso-Vim/editado/`.
