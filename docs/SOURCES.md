# Fuentes y decisiones

Revisión: septiembre de 2026. Las fuentes explican decisiones; los resultados de
ejecución se registran por separado en [VALIDATION.md](VALIDATION.md).

| Tema | Fuente primaria | Aplicación en el repositorio |
|---|---|---|
| Neovim | [Release 0.12.5](https://github.com/neovim/neovim/releases/tag/v0.12.5) | Referencia de pruebas; APIs LSP 0.12 |
| Edición y operadores | [Manual de cambios](https://neovim.io/doc/user/change/), [movimientos](https://neovim.io/doc/user/motion/) | cw/ce, rangos, conteos y curso; contrastados también ejecutando Neovim |
| Aprendizaje | [usr_02](https://neovim.io/doc/user/usr_02/), [usr_04](https://neovim.io/doc/user/usr_04/) | Edición antes de personalización; la secuencia concreta es una elección del curso |
| Visión de Neovim | [Charter](https://neovim.io/charter/) | Separar los objetivos del proyecto del uso como IDE mediante plugins |
| Plugins reproducibles | [Lockfile de lazy](https://lazy.folke.io/usage/lockfile) | Conservar revisiones en Git y usar Lazy restore |
| Tree-sitter | [README upstream](https://github.com/nvim-treesitter/nvim-treesitter) | Carga al inicio, CLI fuera de npm, compilador y TSUpdate |
| Mason | [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) | Configurar PATH primero; desactivar habilitación automática indiscriminada |
| Dart | [flutter-tools](https://github.com/nvim-flutter/flutter-tools.nvim) | Un solo dueño de dartls y reinicio delegado |
| Formato | [none-ls](https://github.com/nvimtools/none-ls.nvim) | Fuente disponible y cliente adjunto son condiciones distintas |
| Archivos ignorados | [CLI de Prettier](https://prettier.io/docs/cli) | Respetar .gitignore/.prettierignore también con stdin |
| Historia introductoria | [vim-history](https://github.com/vim/vim-history), [Neovim 2014](https://neovim.io/news/2014/06/) | Fechas y referencias verificables en las diapositivas |
| Conflictos Git | [git-conflict](https://github.com/akinsho/git-conflict.nvim) | Compatibilidad localizada de 2.1; no reemplazar APIs globales |
| IdeaVim | [Executing IDE actions](https://github.com/JetBrains/ideavim#executing-ide-actions) | nmap con Action; validación de acciones dentro del IDE |
| Selector de archivos | [file_picker 12](https://pub.dev/packages/file_picker) | Migración a API estática y lista vacía al cancelar |
| SDK de Flutter | [Archivo oficial](https://docs.flutter.dev/install/archive) | Flutter estable 3.47.2 / Dart 3.13.2; se respetan las versiones de dependencias fijadas por el SDK |
| Duración y evaluación | [Udemy: outline your course](https://teach.udemy.com/course-creation/outline-your-course/) | Introducción 2-4 min; lecciones 3-6 min y actividades prácticas |

## Decisiones que no son garantías

- Mantener nvim-cmp/LuaSnip evita una migración sin necesidad funcional. No se
  afirma que otras alternativas sean inferiores ni que siempre requieran compilar Rust.
- Los avisos por dependencias ausentes se distinguen de fallos de configuración.
  No se ocultan errores de autenticación ni se declara éxito solo por un código 0.
- El entrenador implementa un subconjunto, con movimientos/objetos sencillos y
  fixtures de Neovim. No implementa todo Vim, macros, modo visual, LSP ni plugins.
- Una comparación de mapas finales no detecta sobrescrituras pasadas. La prueba
  del repo compara propietarios de declaraciones de mapas; no certifica cada
  combinación que un plugin pueda crear en todos sus estados.
