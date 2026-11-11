# Guía Udemy: Neovim desde cero (CAPDESIS)

Cómo grabar el curso. El cuaderno del alumno es [COURSE.md](COURSE.md). Atajos: [WORKFLOW.md](WORKFLOW.md). Práctica: [trainer/](trainer/). Repo: https://github.com/chochy2001/Neovim-Vim_Configuration (MIT).

## Antes de pulsar grabar

1. Terminal con fuente **JetBrainsMono NFM**. Registra `git rev-parse HEAD` y conserva el lockfile.
2. `nvim --headless "+lua print('boot-ok')" +qa` imprime `boot-ok`.
3. `cd trainer && flutter test` imprime All tests passed.
4. IdeaVim (solo secciones 12 y 13): `:source ~/.ideavimrc` (copia del `.ideavimrc` del repo).
5. Presentación principal: abrir `course/slides/index.html` en el navegador. Teclas: Right/Left avanzan y retroceden; Espacio o PageDown también avanzan; `o` vista general de módulos; `f` pantalla completa; `n` notas del profesor; `?` ayuda de teclado. Enlace directo a un módulo: `#mNN-K` donde NN es el número con ceros y K el indice del slide en ese módulo comenzando por 0, por ejemplo `#m01-0`. Para exportar PDF: Ctrl+P o Cmd+P desde el navegador con márgenes mínimos y fondo habilitado.
6. Teaser de bienvenida: `course/udemy/slides-intro.html` sigue siendo útil como introducción de 2 a 3 minutos para la sección 00. Teclas: N o n o flechas o Espacio para avanzar; P o p o flecha izquierda para retroceder. Tiene 10 slides. No hace falta actualizarlo salvo que cambie el mensaje de bienvenida; a partir de la sección 01 usa el deck principal.
7. Consulta `:Telescope keymaps` y WORKFLOW.md. Usa `nvim --clean` para los módulos 01 al 07: sin atajos de esta config.

**Título Udemy sugerido:** Neovim desde cero, de `hjkl` a IDE (config CAPDESIS)
**Subtítulo:** Gramática de Vim primero; después Telescope, Git, LSP y agentes de IA. Repo MIT incluido.

**No digas en cámara** que IntelliJ quedó validado por un script, ni que CAPDESIS Practice es Neovim, ni que los builds van firmados. Neovim arranca: `nvim --headless "+lua print('boot-ok')" +qa`. La app de práctica: `cd trainer && flutter test`.

Una habilidad por video. Udemy sugiere introducciones de **2 a 4 minutos** y lecciones de **3 a 6 minutos**; divide demos complejas. Fuente: [Outline your course](https://teach.udemy.com/course-creation/outline-your-course/).

---

## Las diapositivas del curso

### Presentación principal (deck.json)

Archivo: `course/slides/index.html`. Publicada en: https://chochy2001.github.io/Neovim-Vim_Configuration/slides/

| Tecla | Acción |
|---|---|
| Right, Espacio, PageDown | Siguiente slide |
| Left, PageUp | Slide anterior |
| `o` | Vista general de módulos |
| `f` | Pantalla completa |
| `n` | Mostrar / ocultar notas del profesor |
| `?` | Ayuda de teclado |
| Home / End | Primer / último slide del deck |

Los slides de tipo `config` muestran atajos reales de la config; los de tipo `demo` tienen un ejemplo paso a paso; los de tipo `practice` llevan a la página de práctica del navegador. Los slides de tipo `notes` tienen notas del profesor visibles con `n`.

Para retomar una grabación en el punto exacto usa el enlace `#mNN-K`. Ejemplo: `#m03-2` abre el tercer slide del módulo 03.

### Teaser de bienvenida (slides-intro.html)

Archivo: `course/udemy/slides-intro.html`. Diez slides sobre qué es el curso, qué no es y la ruta. Sirve solo para la intro de la sección 00. No tiene notas de profesor ni vista general. Teclas: N/P o flechas o Espacio.

---

## Flujo de una clase

Cada módulo sigue siempre el mismo camino, de menos a más:

1. **Presentar** (deck principal): el profesor abre el módulo en `course/slides/index.html` y presenta conceptos y comandos. Para los módulos 01 al 07 las demos se hacen con `nvim --clean` para no confundir atajos nativos con los de esta config. A partir del módulo 08 se usa la config instalada.
2. **Practicar** (página de práctica del navegador): el profesor muestra en vivo `https://chochy2001.github.io/Neovim-Vim_Configuration/#lesson-N`. Los módulos 01 al 04 tienen ejercicios interactivos (lecciones 1 a 4). Las lecciones 5 a 8 son hoja de atajos de referencia sin ejercicios activos.
3. **Configurar** (esta config, solo módulos 08 al 13): el profesor demuestra los atajos con la config instalada. Solo se usan teclas que existen en `practice/exercises.json` campo `shortcuts`.

Este orden es obligatorio por módulo. No adelantes atajos de plugins en los módulos de Vim nativo.

---

## Por qué este curso (contexto para el video 00.1)

### Historia (hechos)

- **vi** (Bill Joy, ~1976), editor modal en Unix.
- **Vim** ("Vi IMproved", Bram Moolenaar, 1991). Manual: `:help usr_02`.
- **Neovim** (2014): continuación de Vim, Lua, API. Vision oficial: [neovim.io/charter](https://neovim.io/charter/). No se proponen "convertir Vim en un IDE" como meta del proyecto; sí plugins de terceros. Este curso usa Neovim **como** entorno de trabajo con plugins. Distinguelo en voz alta.

### Competencia (se honesto)

| Herramienta | Cuando tiene sentido |
|---|---|
| VS Code + extension Vim | Ya vives en VS Code; quieres hjkl sin cambiar de casa |
| JetBrains + IdeaVim | Android Studio / IntelliJ diario; nuestro `.ideavimrc` comparte prefijos |
| LazyVim, NvChad, kickstart.nvim | Distribuciones y, en el caso de kickstart, punto de partida; este repo es **una config propia**, no una distro |
| Helix / Kakoune | Gramática distinta; no es Vim |
| IDEs sin Vim | Ratón, GUI de debug, wizards. Siguen siendo válidos |

**Por qué terminal + Neovim aquí:** el mismo teclado en Windows, macOS, Linux y SSH a un servidor. Gramática `d2w` / `ci"` no depende del ratón. LSP (Mason / flutter-tools) cubre el hueco "IDE" cuando el binario existe. No es magia: sin `gopls` no hay Go.

Referencia principal: tutor y manual oficial de Neovim. La secuencia es propia; no implica evaluar a otros autores. Fuentes: [docs/SOURCES.md](docs/SOURCES.md).

### Qué tiene el alumno el día 1

1. Este GitHub (open source, MIT).
2. `COURSE.md` + `COURSE.pdf`.
3. **CAPDESIS Practice** (`trainer/`): mecanografia en 20 lenguajes, katas de un **subconjunto** de Vim, importar carpeta o archivos sueltos. Solo RAM. `flutter test` en el repo.

---

## Secciones Udemy

Cada sección corresponde a un módulo del deck (m00 a m13) y a un capítulo de COURSE.md (0 a 13). Los módulos 01 al 07 se demuestran con `nvim --clean`. Los módulos 08 al 13 demuestran los atajos de esta config; solo se usan teclas verificadas en `practice/exercises.json` (campo `shortcuts`).

**Deep links al deck:** `#mNN-0` abre el slide de título del módulo NN.

---

### Sección 00: Bienvenida (m00)

COURSE.md: Objetivos y ruta + Capítulo 0 (Manos en el teclado).
Slides: `m00-title` `m00-que-es` `m00-por-que` `m00-como` `m00-estudio` `m00-summary`. Deep link: `#m00-0`
Teaser de intro (solo este módulo): `course/udemy/slides-intro.html`.

| # | Video | Qué grabas | Slides |
|---|---|---|---|
| 00.1 | Bienvenida | Quién eres, qué podrán hacer al final, qué no es el curso. Usa el teaser de intro y luego m00-title + m00-por-que | `m00-title` `m00-por-que` |
| 00.2 | Vi, Vim, Neovim | Historia corta y charter de Neovim | `m00-que-es` |
| 00.3 | Ruta del curso | El flujo presentar / practicar / configurar; los 14 módulos | `m00-como` `m00-estudio` `m00-summary` |
| 00.4 | El repo MIT | Abre GitHub en pantalla, LICENSE, estructura. No clonar dentro de `~/.config/nvim` | Demo en terminal |
| 00.5 | CAPDESIS Practice | `cd trainer && flutter run`. Elegir archivos vs carpeta. Aclarar: no es Neovim | Demo de la app |

Práctica en vivo: mostrar https://chochy2001.github.io/Neovim-Vim_Configuration/ y explicar que los ejercicios empiezan en la leccion 1.
Config de esta sección: ninguna.

**Checklist antes de grabar:**
- [ ] `course/udemy/slides-intro.html` abierto en el navegador.
- [ ] GitHub del repo abierto en otra pestaña.
- [ ] `cd trainer && flutter test` ha pasado.

---

### Sección 01: Modos y sobrevivir (m01)

COURSE.md: Capítulo 1.
Slides: `m01-title` `m01-modal` `m01-modos-tabla` `m01-entrar` `m01-demo-insert` `m01-guardar` `m01-help` `m01-practice` `m01-summary`. Deep link: `#m01-0`
Práctica: lesson-1 (`#lesson-1`, 8 ejercicios interactivos: `i a I A o O`, `A<BS>`, apertura de línea).

| # | Video | Qué grabas | Slides | Demo `nvim --clean` |
|---|---|---|---|---|
| 01.1 | El editor modal | La diferencia con un bloc de notas; los cuatro modos | `m01-modal` `m01-modos-tabla` | `i` `Esc` en un archivo de prueba |
| 01.2 | Entrar en Insertar | `i a I A o O jj` y donde mueve el cursor cada uno | `m01-entrar` `m01-demo-insert` | Demo del ejercicio kata-insert: `I//<Esc>` |
| 01.3 | Guardar, salir y ayuda | `:w :q :wq ZZ :q! :e! :help` | `m01-guardar` `m01-help` | `:help :w`, `Ctrl-]`, `:Tutor` |
| 01.4 | Práctica en vivo | Recorre 2 ejercicios de lesson-1 en el navegador | `m01-practice` | Página de práctica |

**Checklist:**
- [ ] `nvim --clean archivo.txt` arranca sin error.
- [ ] Página de práctica abierta en `#lesson-1`.

---

### Sección 02: Moverse sin flechas (m02)

COURSE.md: Capítulo 2.
Slides: `m02-title` `m02-hjkl` `m02-palabras` `m02-líneas` `m02-buscar-línea` `m02-conteos` `m02-demo-hjkl` `m02-demo-find` `m02-practice` `m02-summary`. Deep link: `#m02-0`
Práctica: lesson-2 (`#lesson-2`, 12 ejercicios interactivos: `h j k l`, `w`, `}`, `gg G`, `f t ; ,`, `%`, conteos).

| # | Video | Qué grabas | Slides | Demo `nvim --clean` |
|---|---|---|---|---|
| 02.1 | hjkl: el diamante | Por qué no flechas; `h j k l` y conteos (`5j`, `3l`) | `m02-hjkl` `m02-conteos` | `5j`, `3l` en texto largo |
| 02.2 | Palabras y extremos de línea | `w b e W B E`, `0 ^ $` | `m02-palabras` | Recorrer una funcion de codigo |
| 02.3 | Archivo y parrafos | `gg G Ngg { } %` | `m02-líneas` | `G`, `gg`, `20G`, `%` en codigo con llaves |
| 02.4 | Buscar en la línea | `fx tx Fx Tx ; ,` | `m02-buscar-línea` `m02-demo-find` | `2fX` del demo |
| 02.5 | Práctica en vivo | Recorre 2 ejercicios de lesson-2 | `m02-practice` | Página de práctica |

**Checklist:**
- [ ] Archivo de texto largo (más de 50 líneas) listo para la demo.
- [ ] Página de práctica en `#lesson-2`.

---

### Sección 03: La gramática (m03)

COURSE.md: Capítulo 3.
Slides: `m03-title` `m03-gramática` `m03-operadores` `m03-atajos` `m03-demo-dw` `m03-demo-cw` `m03-punto` `m03-practice` `m03-summary`. Deep link: `#m03-0`
Práctica: lesson-3 (`#lesson-3`, 19 ejercicios interactivos: `d c y`, `dd cc yy`, `x r J p P`, `.`, `u Ctrl-r`, `>>`, conteos con operadores).

| # | Video | Qué grabas | Slides | Demo `nvim --clean` |
|---|---|---|---|---|
| 03.1 | Operador + movimiento | La formula base: `d c y` más movimiento | `m03-gramática` `m03-operadores` | `dw`, `c3w`, `yy` + `p` |
| 03.2 | Combinaciones rápidas | `dd cc yy D C x r J p P` | `m03-atajos` | Demo de `dw` y luego `cw` del deck |
| 03.3 | El punto | `.` repite el último cambio; cómo diseñar cambios repetibles | `m03-punto` | `cw` + texto + `Esc` + `.` en otra palabra |
| 03.4 | Deshacer y rehacer | `u Ctrl-r` | (dentro de m03-atajos) | Tres cambios, deshacer dos, rehacer uno |
| 03.5 | Práctica en vivo | Recorre 2 ejercicios de lesson-3 | `m03-practice` | Página de práctica |

**Checklist:**
- [ ] Archivo con codigo (Lua, Go o Python) listo para los demos.
- [ ] Página de práctica en `#lesson-3`.

---

### Sección 04: Objetos de texto (m04)

COURSE.md: Capítulo 4.
Slides: `m04-title` `m04-que-son` `m04-tabla` `m04-demo-ciw` `m04-demo-ciquote` `m04-visual` `m04-practice` `m04-summary`. Deep link: `#m04-0`
Práctica: lesson-4 (`#lesson-4`, 7 ejercicios interactivos: `ciw`, `ci"`, `diw`, `yiw`, `>>`, combinaciones).

| # | Video | Qué grabas | Slides | Demo `nvim --clean` |
|---|---|---|---|---|
| 04.1 | Qué es un objeto | Diferencia movimiento vs objeto; `i` interior y `a` alrededor | `m04-que-son` `m04-tabla` | `ciw`, `ci"`, `ci{` en codigo con cadenas |
| 04.2 | Las tres recetas | `ciw ci" ci{` y sus variantes con `d` y `y` | `m04-demo-ciw` `m04-demo-ciquote` | Demo del ejercicio ciw y ci" del deck |
| 04.3 | Modo Visual e indentacion | `v V Ctrl-v`; `>` y `<` mantienen la seleccion en esta config | `m04-visual` | Seleccion de bloque y sangria multiple |
| 04.4 | Práctica en vivo | Recorre 2 ejercicios de lesson-4 | `m04-practice` | Página de práctica |

**Checklist:**
- [ ] Archivo con cadenas de texto, parentesis y llaves listo.
- [ ] Página de práctica en `#lesson-4`.

---

### Sección 05: Buscar y sustituir (m05)

COURSE.md: Capítulo 5.
Slides: `m05-title` `m05-buscar` `m05-buscar-tabla` `m05-sustituir` `m05-sustituir-tabla` `m05-practice` `m05-summary`. Deep link: `#m05-0`
Práctica: lesson-5 (`#lesson-5`; hoja de atajos de referencia, sin ejercicios activos).

| # | Video | Qué grabas | Slides | Demo `nvim --clean` |
|---|---|---|---|---|
| 05.1 | Buscar con / y ? | `/patron`, `?patron`, `n`, `N`, `*`, `#` | `m05-buscar` `m05-buscar-tabla` | Buscar una funcion; navegar con `n`/`N`; `*` sobre una palabra |
| 05.2 | Sustituir con :s | `:s`, `:%s`, banderas `g c i` | `m05-sustituir` `m05-sustituir-tabla` | `:%s/gato/perro/gc` del ejercicio de COURSE.md |
| 05.3 | Referencia en la página | Muestra lesson-5 (hoja de atajos) | `m05-practice` | Página de práctica |

Nota: en esta config `n`/`N` centran la pantalla en el resultado y `<leader><leader>` limpia el resaltado. Muestra eso en el video 05.3 cuando ya usas la config instalada, o posponlo a la sección 09. Con `nvim --clean` usa `:nohl`.

**Checklist:**
- [ ] Archivo con texto repetido para el demo de sustitucion.

---

### Sección 06: Registros y macros (m06)

COURSE.md: Capítulo 6.
Slides: `m06-title` `m06-registros` `m06-usar-reg` `m06-macros` `m06-macro-keys` `m06-demo-reg` `m06-practice` `m06-summary`. Deep link: `#m06-0`
Práctica: lesson-6 (`#lesson-6`; hoja de atajos de referencia, sin ejercicios activos).

| # | Video | Qué grabas | Slides | Demo `nvim --clean` |
|---|---|---|---|---|
| 06.1 | Registros | `"ayy`, `"ap`, `"+y`, `"+p`, `:reg`, `"_dd` | `m06-registros` `m06-usar-reg` `m06-demo-reg` | Demo `"ayy` y luego `"ap` del deck |
| 06.2 | Macros | `qa ... q`, `@a`, `@@`, `5@a` | `m06-macros` `m06-macro-keys` | Lista de texto: grabar macro para añadir `- ` y aplicarla 5 veces |
| 06.3 | Referencia en la página | Muestra lesson-6 (hoja de atajos) | `m06-practice` | Página de práctica |

**Checklist:**
- [ ] Archivo con lista de items para el demo de macro.

---

### Sección 07: Buffers, ventanas, pestañas y terminales (m07)

COURSE.md: Capítulo 7.
Slides: `m07-title` `m07-conceptos` `m07-buffers` `m07-ventanas` `m07-terminales` `m07-config` `m07-summary`. Deep link: `#m07-0`
Práctica: lesson-7 (`#lesson-7`; hoja de atajos de referencia, sin ejercicios activos). Muestra la página de forma manual al final; el deck m07 no tiene diapositiva de tipo `practice` que enlace a lesson-7 (ver inconsistencias al final de este archivo).

| # | Video | Qué grabas | Slides | Demo |
|---|---|---|---|---|
| 07.1 | Buffer, ventana y pestaña | Distinción conceptual; `:e :ls :b :bd :bn :bp` | `m07-conceptos` `m07-buffers` | `nvim --clean`: abrir dos archivos, `:ls`, `:b2` |
| 07.2 | Dividir ventanas | `Ctrl-w v`, `Ctrl-w s`, `Ctrl-w h/j/k/l`, `Ctrl-w c` | `m07-ventanas` | `nvim --clean`: dos ventanas con el mismo buffer |
| 07.3 | Terminales con esta config | `<leader>tv` `<leader>th` `<leader>ta` `<leader>tl` y `jj` para salir | `m07-terminales` `m07-config` | Config instalada (estos atajos requieren la config) |
| 07.4 | Bufferline, ventanas y saltos | `<S-l>` `<S-h>` `<leader>bn` `<leader>bp` `<leader>bd`; `Ctrl-o` `Ctrl-i` | (dentro de m07-config) | Config instalada |
| 07.5 | Referencia en la página | Muestra lesson-7 (hoja de atajos) | Ninguno | Página de práctica |

Atajos de esta config verificados en exercises.json (shortcuts):

| Atajo | Descripcion | Grupo en exercises.json |
|---|---|---|
| `<leader>tv` | Terminal a la derecha (`2<leader>tv` = terminal 2) | Terminal |
| `<leader>th` | Terminal abajo | Terminal |
| `<leader>ta` | Mostrar / ocultar todos los terminales | Terminal |
| `<leader>tl` | Elegir un terminal de la lista | Terminal |
| `jj` (modo terminal) | Salir del modo terminal | Terminal / Core Editing |
| `<S-l>` | Buffer siguiente (rápido) | Buffer & Tab Management |
| `<S-h>` | Buffer anterior (rápido) | Buffer & Tab Management |
| `<leader>bn` | Buffer siguiente | Buffer & Tab Management |
| `<leader>bp` | Buffer anterior | Buffer & Tab Management |
| `<leader>bd` | Cerrar buffer | Buffer & Tab Management |
| `<leader>sv` | Partir ventana vertical | Window & Split Management |
| `<leader>sh` | Partir ventana horizontal | Window & Split Management |
| `<leader>sc` | Cerrar split actual | Window & Split Management |
| `<leader>so` | Cerrar todos los demas splits | Window & Split Management |
| `<leader>wh/wj/wk/wl` | Mover foco al split izquierda/abajo/arriba/derecha | Window & Split Management |

**Checklist:**
- [ ] Dos o tres archivos del repo listos para abrir en la demo.
- [ ] Config instalada para los videos 07.3 y 07.4.

---

### Sección 08: Instalar esta config (m08)

COURSE.md: Capítulo 8.
Slides: `m08-title` `m08-requisitos` `m08-windows` `m08-macos` `m08-arranque` `m08-fuentes` `m08-practice` `m08-summary`. Deep link: `#m08-0`
Práctica: lesson-8 (`#lesson-8`; hoja de atajos de referencia, sin ejercicios activos).

| # | Video | Qué grabas | Slides | Demo |
|---|---|---|---|---|
| 08.1 | Requisitos | Neovim 0.12, Node 22+, ripgrep, Nerd Font, tree-sitter CLI | `m08-requisitos` | Terminal: `nvim --version`, `node --version`, `rg --version` |
| 08.2 | Instalar en Windows | `winget`, Junction, fuente en el terminal | `m08-windows` | Grabacion en Windows o screencast |
| 08.3 | Instalar en macOS / Linux | `git clone`, symlink, primer arranque con lazy.nvim | `m08-macos` `m08-arranque` | La instalacion en vivo desde cero |
| 08.4 | Nerd Font e iconos | Por qué son necesarias; cómo configurarlas en el terminal | `m08-fuentes` | Antes y después de la fuente |
| 08.5 | Verificar y la hoja de atajos | `nvim --headless "+lua print('boot-ok')" +qa`; mostrar lesson-8 | `m08-practice` | Página de práctica |

**Checklist:**
- [ ] `nvim --headless "+lua print('boot-ok')" +qa` imprime `boot-ok` sin errores.
- [ ] `python scripts/verify.py` pasa sin error.
- [ ] JetBrainsMono NFM activa en el terminal grabado.

---

### Sección 09: Neovim como IDE (m09)

COURSE.md: Capítulo 9.
Slides: `m09-title` `m09-telescope` `m09-arbol` `m09-lsp` `m09-git` `m09-config` `m09-summary`. Deep link: `#m09-0`
Práctica: ninguna leccion de ejercicios; los módulos 09 a 13 ya requieren la config instalada.

Atajos a demo (todos verificados en exercises.json shortcuts):

| Atajo | Descripcion | Grupo en exercises.json |
|---|---|---|
| `<leader>ff` | Buscar archivos | Find & Search |
| `<leader>fg` | Buscar texto en archivos (live grep) | Find & Search |
| `<leader>fo` | Archivos recientes | Find & Search |
| `<leader>fk` | Ver todos los atajos | Find & Search |
| `<leader>pv` | Arbol de archivos (Neo-tree) | Neo-tree |
| `<leader>fr` | Mostrar archivo actual en el arbol | Neo-tree |
| `<leader>-` | Abrir directorio padre (oil.nvim) | Oil.nvim |
| `gd` | Ir a la definicion (LSP) | Navigation |
| `K` | Documentacion en hover | Navigation |
| `<leader>rn` | Renombrar simbolo | Actions |
| `<leader>ca` | Code action | Actions |
| `<leader>fm` | Formatear el archivo | Actions |
| `<leader>gs` | Git status | Core Git |
| `<leader>gn` | Siguiente hunk | Hunk Navigation |
| `<leader>gsa` | Preparar (stage) hunk | Hunk Navigation |
| `<leader>gsp` | Vista previa del hunk | Hunk Navigation |
| `<leader>gsr` | Descartar hunk | Hunk Navigation |
| `<leader>gc` | Git commit | Core Git |
| `<leader>gp` | Git push | Core Git |
| `<leader>gdo` | Abrir diffview | Diff |
| `<leader>tm` | Markdown renderizado / crudo | Terminal |

| # | Video | Qué grabas | Slides |
|---|---|---|---|
| 09.1 | Telescope | `<leader>ff` `fg` `fo` `fk`; fuente de verdad: `:Telescope keymaps` | `m09-telescope` |
| 09.2 | Arbol y navegacion de archivos | `<leader>pv` `fr` `<leader>-` (oil.nvim) | `m09-arbol` |
| 09.3 | LSP: definicion, hover, renombrar y format | `gd` `K` `<leader>rn` `ca` `fm`; `Ctrl-o` para volver | `m09-lsp` `m09-config` |
| 09.4 | Git integrado | `<leader>gs` `gn` `gsa` `gsp` `gsr` `gc` `gdo` | `m09-git` `m09-config` |
| 09.5 | Markdown y flujo IDE | `<leader>tm`; flujo tipico: `ff` abrir, `ciw` editar, `gd` definicion, `fm` formatear | `m09-summary` |

**Checklist:**
- [ ] Repo con al menos un servidor LSP instalado (`:Mason` y `:checkhealth vim.lsp`).
- [ ] `git status` muestra cambios reales para la demo de hunks.

---

### Sección 10: IA con Neovim (m10)

COURSE.md: Capítulo 10.
Slides: `m10-title` `m10-agentes` `m10-flujo` `m10-herdr` `m10-reload` `m10-config` `m10-summary`. Deep link: `#m10-0`

Atajos a demo (verificados en exercises.json shortcuts):

| Atajo | Descripcion | Grupo en exercises.json |
|---|---|---|
| `<leader>aa` | Abrir opencode | AI Assistants |
| `<leader>ac` | Abrir Claude | AI Assistants |
| `<leader>as` (Visual) | Enviar seleccion al agente (selector + instruccion) | AI Assistants |
| `<leader>cc` | Abrir / cerrar CopilotChat | Copilot AI Chat |
| `<leader>fp` | Abrir proyecto reciente | Find & Search |
| `<leader>ff` | Buscar archivo en el proyecto | Find & Search |
| `<leader>pv` | Arbol de archivos | Neo-tree |
| `gd` | Ir a la definicion (leer codigo) | Navigation |
| `K` | Documentacion en hover | Navigation |
| `gR` | Referencias en Trouble | Navigation |
| `<leader>gsp` | Vista previa del hunk (revisar cambio del agente) | Hunk Navigation |
| `<leader>gdo` | Diffview completo | Diff |
| `<leader>gsr` | Descartar hunk (revertir cambio del agente) | Hunk Navigation |

| # | Video | Qué grabas | Slides |
|---|---|---|---|
| 10.1 | Los agentes disponibles | `<leader>aa` a `<leader>ai`; cada uno usa tus suscripciones, sin API keys | `m10-agentes` `m10-config` |
| 10.2 | El flujo completo del día | Abrir proyecto con `<leader>fp`, leer con `gd` y `K`, seleccion Visual + `<leader>as`, el agente trabaja a la derecha | `m10-flujo` |
| 10.3 | Recarga automatica y revision | El archivo cambia en disco; `:e!` toma la version del agente; revisar con `<leader>gsp` y `gdo`; descartar con `gsr` | `m10-herdr` `m10-reload` |

**Checklist:**
- [ ] Al menos un agente de IA instalado y autenticado (opencode o Claude).
- [ ] Archivo de codigo con al menos una funcion para la demo de seleccion.

---

### Sección 11: Plugins de este repositorio (m11)

COURSE.md: Capítulo 11.
Slides: `m11-title` `m11-comments` `m11-nav` `m11-trouble` `m11-undo` `m11-config` `m11-summary`. Deep link: `#m11-0`

Atajos a demo (verificados en exercises.json shortcuts):

| Atajo | Descripcion | Grupo en exercises.json |
|---|---|---|
| `gcc` | Comentar / descomentar línea | Core Editing |
| `gc` (Visual) | Comentar seleccion | Core Editing |
| `s` | Flash: saltar a cualquier caracter de la pantalla | Core Editing |
| `af / if` (Visual/Operator) | Alrededor de / dentro de funcion (treesitter) | Treesitter Text Objects |
| `<leader>ma` | Añadir archivo a Harpoon | Harpoon |
| `<leader>mh` | Mostrar lista de Harpoon | Harpoon |
| `<leader>1` a `<leader>9` | Saltar al archivo marcado | Harpoon |
| `<leader>xx` | Abrir / cerrar Trouble | Diagnostics & Trouble |
| `<leader>xn` | Siguiente error / diagnostico | Diagnostics & Trouble |
| `<leader>xp` | Error / diagnostico anterior | Diagnostics & Trouble |
| `<leader>xw` | Diagnosticos del workspace | Diagnostics & Trouble |
| `<leader>u` (Normal) | Arbol de historial de deshacer | Undo History |
| `<leader>sr` | Buscar y reemplazar en archivos (grug-far) | Find & Search |
| `<leader>fk` | Ver todos los atajos registrados en Telescope | Find & Search |

| # | Video | Qué grabas | Slides |
|---|---|---|---|
| 11.1 | Comentarios y envolturas | `gcc`, `gc` en visual, `ysiw"`, `ds"`, `cs"'` (surround) | `m11-comments` |
| 11.2 | Flash y Harpoon | `s` para saltar a dos teclas; `<leader>ma` y `<leader>1` a `9` para archivos frecuentes | `m11-nav` |
| 11.3 | Trouble y diagnosticos | `<leader>xx` `xn` `xp` `xw` `gR` | `m11-trouble` |
| 11.4 | Undotree y busqueda masiva | `<leader>u`; `<leader>sr` para grug-far; `<leader>fk` como indice de todos los atajos | `m11-undo` |

**Checklist:**
- [ ] Repo con errores de LSP activos para la demo de Trouble.
- [ ] Varios archivos abiertos para la demo de Harpoon.

---

### Sección 12: IdeaVim (m12)

COURSE.md: Capítulo 12.
Slides: `m12-title` `m12-que-es` `m12-instalar` `m12-modos` `m12-atajos` `m12-config` `m12-summary`. Deep link: `#m12-0`

Atajos compartidos entre Neovim e IdeaVim (verificados en exercises.json shortcuts):

| Atajo | Descripcion |
|---|---|
| `<leader>ff` | Buscar archivos |
| `<leader>fg` | Buscar texto |
| `gd` | Ir a la definicion |
| `K` | Documentacion en hover |
| `<leader>rn` | Renombrar simbolo |
| `<leader>ca` | Code action |
| `<leader>gs` | Git status |
| `gcc` | Comentar línea |
| `<leader>xx` | Trouble (diagnosticos) |

Atajos que **no** estan en IdeaVim: `<leader>a*` (terminales de IA), `<leader>c*` (CopilotChat), `<leader>tv/th/ta` (terminales integrados).

| # | Video | Qué grabas | Slides |
|---|---|---|---|
| 12.1 | Qué es IdeaVim e instalacion | Plugin del marketplace; `Tools -> Vim`; copiar `.ideavimrc`; recargar con `:source ~/.ideavimrc` | `m12-que-es` `m12-instalar` |
| 12.2 | Los mismos atajos en el IDE | Demo de `<leader>ff` `gd` `K` `gcc` en Android Studio; `:actionlist` para explorar | `m12-modos` `m12-atajos` `m12-config` |

**Checklist:**
- [ ] Android Studio o IntelliJ con IdeaVim instalado y `.ideavimrc` cargado.
- [ ] `:source ~/.ideavimrc` ha pasado sin error.

---

### Sección 13: Cuando algo falla (m13)

COURSE.md: Capítulo 13.
Slides: `m13-title` `m13-checkhealth` `m13-lazy` `m13-iconos` `m13-tabla` `m13-config` `m13-summary`. Deep link: `#m13-0`

Atajos a demo (verificados en exercises.json shortcuts):

| Atajo | Descripcion | Grupo en exercises.json |
|---|---|---|
| `<leader>xx` | Abrir Trouble | Diagnostics & Trouble |
| `<leader>xd` | Diagnosticos del documento | Diagnostics & Trouble |
| `<leader>xw` | Diagnosticos del workspace | Diagnostics & Trouble |
| `<leader>xn` | Siguiente error | Diagnostics & Trouble |
| `<leader>xp` | Error anterior | Diagnostics & Trouble |
| `<leader>fk` | Ver todos los atajos | Find & Search |
| `gR` | Referencias del simbolo en Trouble | Navigation |

| # | Video | Qué grabas | Slides |
|---|---|---|---|
| 13.1 | :checkhealth, :Lazy y :Mason | El primer diagnostico; plugins en rojo; servidores LSP faltantes | `m13-title` `m13-checkhealth` `m13-lazy` |
| 13.2 | Problemas comunes | Iconos como recuadros; atajo sin respuesta; E37; Dart mudo | `m13-iconos` `m13-tabla` `m13-config` |

**Checklist:**
- [ ] Un caso de error reproducible para la demo (un servidor LSP desinstalado, por ejemplo).

---

## Cómo entrar a la app de práctica (para el video 00.5)

```bash
cd trainer
flutter pub get
flutter test          # tiene que decir All tests passed
flutter run -d windows   # o macos / linux
```

- Pestana **Mecanografia**: chips de lenguaje, o **Elegir archivos** / carpeta. X en el chip quita un archivo. **Soltar archivos** vacia la RAM.
- Pestana **Vim**: lista de katas, **Comprobar** compara el buffer.
- **Acerca de**: lista de comandos implementados. No prometas macros ni visual.

---

## Control del material

Antes de grabar: `python scripts/verify.py`, `python scripts/vim_reference.py --check` y las pruebas del entrenador. Completa [docs/VALIDATION.md](docs/VALIDATION.md), prueba el SO que grabas y revisa el PDF contra su fuente. Declarar CI no equivale a haberla ejecutado.

---

## Guion corto (video 00.1 y 09.5: Vim o IDE)

No atacar IDEs. Di: el IDE gana en wizards y a veces en debug grafico. Neovim gana cuando escribes mucho, cuando entras por SSH, cuando quieres la misma gramática en Flutter, Go y el `init.lua`. Esta config anade LSP; si Mason no instaló el servidor, no hay autocompletado. Eso es el curso siendo honesto.

---

## Inconsistencias encontradas (no corregidas en este archivo; revisar en sus archivos fuente)

Hallazgos entre COURSE.md, deck.json y exercises.json a 2026-11-10:

1. **deck.json m07 no tiene diapositiva de tipo `practice`.** Los módulos 01 al 06 y 08 tienen un slide de tipo `practice` que enlaza a su leccion. El módulo m07 (Buffers, ventanas, pestañas y terminales) no lo tiene. exercises.json si contiene lesson-7, pero la navegacion del deck no lleva al alumno a ella. Recomendacion: agregar una diapositiva `practice` a m07 en deck.json apuntando a `lesson-7`.

2. **Las lecciones 5, 6, 7 y 8 de exercises.json tienen 0 ejercicios activos.** Solo existen como hojas de referencia en la página de práctica. Es coherente con la enseñanza (esos temas requieren un Neovim real), pero el alumno puede esperar ejercicios interactivos después de las lecciones 1 a 4. Documentarlo en la intro de cada video de práctica de esas secciones.

3. **deck.json m10 no incluye `<leader>fp` ni los atajos de revision (`<leader>gsp` `<leader>gdo` `<leader>gsr`) en su slide de config.** COURSE.md capítulo 10 describe el flujo completo del día empezando con `<leader>fp` y revisando con esos tres atajos, pero el deck m10-config no los lista. El alumno que solo vea el deck perdera esa parte del flujo. Recomendacion: agregar esos atajos a la diapositiva `m10-config` en deck.json.

4. **slides-intro.html acepta más teclas de las que documentaba el UDEMY.md anterior.** El archivo acepta N, n, ArrowRight, Espacio y PageDown para avanzar; P, p, ArrowLeft y PageUp para retroceder. El checklist previo solo mencionaba N/P. Corregido en este archivo.
