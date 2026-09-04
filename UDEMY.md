# Guía Udemy — Neovim desde cero (CAPDESIS)

Cómo grabar el curso. El cuaderno del alumno es [COURSE.md](COURSE.md). Atajos de esta config: [WORKFLOW.md](WORKFLOW.md). App de práctica: [trainer/](trainer/). Repo: https://github.com/chochy2001/Neovim-Vim_Configuration (MIT).

**No digas en cámara** que IntelliJ quedó validado por un script, ni que CAPDESIS Practice es Neovim, ni que los builds van firmados. Neovim arranca: `nvim --headless "+lua print('boot-ok')" +qa`. La app de práctica: `cd trainer && flutter test`.

Duración por vídeo: 8–15 min (Udemy recomienda no alargarse). Demo en terminal real, no slides leyendo código.

---

## Por qué este curso (contexto para el vídeo 1)

### Historia (hechos)

- **vi** (Bill Joy, ~1976), editor modal en Unix.
- **Vim** (“Vi IMproved”, Bram Moolenaar, 1991). Manual: `:help usr_02`.
- **Neovim** (2014): continuación de Vim, Lua, API. Visión oficial: [neovim.io/charter](https://neovim.io/charter/) — *no* se proponen “convertir Vim en un IDE” como meta del proyecto; *sí* plugins de terceros. Este curso usa Neovim **como** entorno de trabajo con plugins. Distínguelo en voz alta.

### Competencia (sé honesto)

| Herramienta | Cuándo tiene sentido |
|-------------|----------------------|
| VS Code + extensión Vim | Ya vives en VS Code; quieres hjkl sin cambiar de casa |
| JetBrains + IdeaVim | Android Studio / IntelliJ diario; nuestro `.ideavimrc` comparte *prefijos* |
| LazyVim, NvChad, kickstart | Distros listas; este repo es **una config propia**, no una distro |
| Helix / Kakoune | Gramática distinta; no es Vim |
| IDEs sin Vim | Ratón, GUI de debug, wizards. Siguen siendo válidos |

**Por qué terminal + Neovim aquí:** el mismo teclado en Windows, macOS, Linux y SSH a un servidor. Gramática `d2w` / `ci"` no depende del ratón. LSP (Mason / flutter-tools) cubre el hueco “IDE” **cuando el binario existe**. No es magia: sin `gopls` no hay Go.

Cursos / materiales ajenos (para no copiar, para no repetir sus agujeros): `vimtutor`, *Learn Vim the Smart Way*, vim-galore, ThePrimeagen “0 to LSP”, Typecraft. Ellos o saltan lo básico o no usan *este* repo.

### Qué tiene el alumno el día 1

1. Este GitHub (open source, MIT).
2. `COURSE.md` + `COURSE.pdf`.
3. **CAPDESIS Practice** (`trainer/`): mecanografía en 20 lenguajes, katas de un **subconjunto** de Vim, importar carpeta o **archivos sueltos**. Solo RAM. `flutter test` en el repo.

---

## Carpetas Udemy (secciones)

Cada carpeta = una sección en el dashboard de Udemy. Cada ítem = un vídeo.

### Carpeta 1 — Introducción

| # | Vídeo | Qué grabas | Slides (títulos) |
|---|--------|------------|------------------|
| 1.1 | Bienvenida | Quién eres, qué van a poder hacer al final (editar un repo real con Neovim) | Título del curso · Lo que no es (no es un bootcamp de Flutter) |
| 1.2 | Vi, Vim, Neovim | Historia corta + charter de Neovim | 1976 vi · 1991 Vim · 2014 Neovim · fuente neovim.io/charter |
| 1.3 | ¿Vale la pena vs un IDE? | Tabla competencia, sin pelearse con VS Code | SSH · gramática · LSP como extra |
| 1.4 | El repo open source | Abre GitHub en pantalla, LICENSE, estructura | clone ≠ copiar dentro de ~/.config/nvim |
| 1.5 | Cómo está el curso | Orden: manos → Vim puro → esta config → plugins | No plugins el día 1 |

### Carpeta 2 — Manos y entorno

| # | Vídeo | Qué grabas |
|---|--------|------------|
| 2.1 | Escribir sin mirar | keybr / monkeytype 5 min en pantalla |
| 2.2 | Instalar Neovim 0.12 Windows | winget, Nerd Font JetBrainsMono NFM, terminal |
| 2.3 | Instalar macOS | brew, fuente, symlink |
| 2.4 | Instalar Linux | paquete distro o release GitHub |
| 2.5 | Clonar y enlazar **esta** config | Junction Windows / ln -s Unix. `nvim` primera vez, `:Lazy` |
| 2.6 | CAPDESIS Practice | `cd trainer && flutter run`. Elegir archivos vs carpeta. Decir: no es Neovim |

### Carpeta 3 — Vim puro (sin plugins)

| # | Vídeo | Demo obligatoria |
|---|--------|------------------|
| 3.1 | `nvim +Tutor` | Completar una lección en vivo |
| 3.2 | Modos | `i` `Esc` `jj` `:w` `:q` `:q!` |
| 3.3 | `hjkl` 0 $ gg G w b | Sin flechas |
| 3.4 | Gramática d/c/y + conteo | `dw` `c3w` `yy` `p` `.` `u` |
| 3.5 | Objetos | `ciw` `ci"` `ci{` |
| 3.6 | Visual y buscar | `v` `V` `/` `n` `:%s` |
| 3.7 | Buffers y ventanas | `:e` `:ls` `Ctrl-w v` |
| 3.8 | Registros y una macro | `"ayy` `qa` … `@a` |

### Carpeta 4 — Esta config como IDE

| # | Vídeo | Teclas (existen en el Lua) |
|---|--------|----------------------------|
| 4.1 | Leader Espacio y which-key | Espacio, espera, menú |
| 4.2 | Dashboard | `nvim` vacío: `f` `g` `r` `e` `a` `m` `l` `q` |
| 4.3 | Telescope | `<leader>ff` `fg` `fk` |
| 4.4 | neo-tree y oil | `pv` `-` |
| 4.5 | Git | `gs` `gsa` `gc` `gp` |
| 4.6 | LSP | `gd` `K` `fm` `:Mason` — archivo **real** |
| 4.7 | Flutter | `fla` `flr` si hay SDK |
| 4.8 | Diagnósticos | `xx` `xn` |
| 4.9 | Terminal y tests | `tt` `ten` |
| 4.10 | Qué es solo Neovim | `<leader>aa` opencode · `<leader>cc` CopilotChat (no están en IdeaVim) |

### Carpeta 5 — IdeaVim y cierre

| # | Vídeo | Qué grabas |
|---|--------|------------|
| 5.1 | IdeaVim en Android Studio | Plugins → IdeaVim → Tools \| Vim → `~/.ideavimrc` |
| 5.2 | Cuando se rompe | tabla de COURSE.md §13 |
| 5.3 | Cierre | Dónde está el repo, PRACTICE, `:help` |

---

## Cómo entrar a la app de práctica (para el 2.6)

```bash
cd trainer
flutter pub get
flutter test          # tiene que decir All tests passed
flutter run -d windows   # o macos / linux
```

- Pestaña **Mecanografía**: chips de lenguaje, o **Elegir archivos** / carpeta. X en el chip quita un archivo. **Soltar archivos** vacía la RAM.
- Pestaña **Vim**: lista de katas, **Comprobar** compara el buffer.
- **Acerca de**: lista de comandos implementados. No prometas macros ni visual.

---

## Lista de diapositivas (para PowerPoint / Keynote)

No hay fotos de stock en el repo (se ven falsas y no son tu pantalla). En cada slide de “demo”: captura **tu** terminal. Fuentes: Inter o Segoe para títulos, JetBrains Mono para código. Fondo `#0d1117`, acento `#58a6ff`.

**Sección 1 — 10 slides** (archivo `course/udemy/slides-intro.html`, teclas `N`/`P`)

1. Neovim desde cero — CAPDESIS  
2. Al terminar  
3. Esto no es  
4. vi → Vim → Neovim  
5. Charter (neovim.io/charter)  
6. ¿Y el IDE?  
7. El repo MIT  
8. Orden del curso  
9. CAPDESIS Practice ≠ Neovim  
10. Siguiente: instalar

**Sección 2** — una slide por SO (Windows / macOS / Linux) con el bloque de comandos de COURSE.md copiado tal cual.

**Sección 3** — una slide por vídeo: comando grande (`dw`, `ciw`) y una frase (“operador + movimiento”).

**Sección 4** — una slide por prefijo (`f*` `g*` `fl*`) y “fuente de verdad: `:Telescope keymaps`”.

Plantilla HTML oscura (sin red): [course/udemy/slides-intro.html](course/udemy/slides-intro.html) — ábrela en el navegador, `N` / `P` o flechas.

---

## Guion corto (1.3 — ¿Vim o IDE?)

No atacar IDEs. Di: el IDE gana en wizards y a veces en debug gráfico. Neovim gana cuando escribes mucho, cuando entras por SSH, cuando quieres la misma gramática en Flutter, Go y el `init.lua`. Esta config **añade** LSP; si Mason no instaló el servidor, no hay autocompletado. Eso es el curso siendo honesto.
