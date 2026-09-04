# Curso Neovim — de cero a IDE

Material para enseñar esta configuración ([chochy2001/Neovim-Vim_Configuration](https://github.com/chochy2001/Neovim-Vim_Configuration)).

**Leader = Espacio.** En las tablas, `<leader>` significa: pulsa Espacio y luego el resto. Espera ~300 ms o sigue tecleando. `Espacio Espacio` borra el resaltado de búsqueda; **no** abre el buscador de archivos.

Lista viva de atajos (fuente de verdad en una sesión real): `:Telescope keymaps`

---

## Qué está validado (sin falsos positivos)

Comprobado en esta máquina (septiembre 2026):

| Qué | Resultado |
|-----|-----------|
| Neovim | `0.12.5`, arranque headless `boot-ok` |
| Keymaps Neovim | 0 duplicados duros `(modo, tecla)` |
| Dart en un archivo real | clientes `dartls,null-ls` |
| git-conflict | `setup()` ok (shim de `vim.validate`) |
| Repo | `main` en GitHub |
| `~/.ideavimrc` | copia del archivo del repo |

**No comprobado aquí (no lo des por hecho en clase):**

- IntelliJ / Android Studio: hay que instalar **IdeaVim**, **Tools \| Vim**, `:source ~/.ideavimrc`.
- Vim clásico: el comando `vim` puede no existir. Este curso usa **Neovim**.
- Cada LSP solo arranca si el binario está (Mason / Flutter SDK / `uv`).

Si un atajo no hace nada: espera 300 ms (prefijo) o ejecuta `:Telescope keymaps`.

---

# Módulo 0 — Teclear sin mirar el teclado

Antes de Vim: manos en la fila home (`A S D F` / `J K L Ñ`). 15–20 minutos al día.

Sitios (abiertos en el navegador, no forman parte de este repo):

| Sitio | Para qué |
|-------|----------|
| [keybr.com](https://www.keybr.com) | Adaptativo, letras una a una |
| [monkeytype.com](https://monkeytype.com) | Velocidad, varias lenguas |
| [typingclub.com](https://www.typingclub.com) | Lecciones guiadas (también en español) |
| [openvim.com](https://www.openvim.com) | Tutorial interactivo de Vim en el navegador |
| [vim-adventures.com](https://vim-adventures.com) | Juego (parte de pago) |

Meta mínima: escribir este párrafo sin mirar las teclas. Luego `h j k l` en Neovim será natural.

No hace falta saber programar para este módulo.

---

# Módulo 1 — Instalar Neovim y esta config

## 1.1 Requisitos

| Herramienta | Windows | macOS | Linux |
|-------------|---------|-------|-------|
| Neovim **0.12+** | `winget install Neovim.Neovim` | `brew install neovim` | paquete distro o [releases](https://github.com/neovim/neovim/releases) |
| Git | `winget install Git.Git` | viene / `brew` | paquete |
| Node.js 22+ | `winget install OpenJS.NodeJS` | `brew install node` | paquete |
| Compilador C | Build Tools de Visual Studio | `xcode-select --install` | `gcc` |
| Fuente **JetBrainsMono NFM** | `winget install DEVCOM.JetBrainsMonoNerdFont` | `brew install --cask font-jetbrains-mono-nerd-font` | [nerdfonts.com](https://www.nerdfonts.com) |
| ripgrep + fd (recomendado) | `winget install BurntSushi.ripgrep.MSVC sharkdp.fd` | `brew install ripgrep fd` | `apt install ripgrep fd-find` |
| tree-sitter CLI | `npm install -g tree-sitter-cli` | igual | igual |

Sin Nerd Font, Telescope y neo-tree muestran **cuadrados vacíos**. En Windows Terminal / VS Code / Cursor pon la fuente **JetBrainsMono NFM** y **reabre** el terminal.

## 1.2 Clonar (no clones dentro de `~/.config/nvim`)

Unix:

```bash
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git ~/Neovim-Vim_Configuration
mkdir -p ~/.config
ln -sfn ~/Neovim-Vim_Configuration/.config/nvim ~/.config/nvim
nvim
```

Windows (PowerShell):

```powershell
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git $HOME\Neovim-Vim_Configuration
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\Neovim-Vim_Configuration\.config\nvim"
Copy-Item "$HOME\Neovim-Vim_Configuration\.ideavimrc" "$HOME\.ideavimrc"
nvim
```

La primera vez lazy.nvim instala plugins. Mason instala LSP/formatters en segundo plano. Espera a que acabe (`:Lazy`).

## 1.3 Comprobar

```bash
nvim --headless "+lua print('boot-ok')" +qa
```

Debe imprimir `boot-ok` y **no** `Error detected` / `E####`.

En Neovim: `:checkhealth` y `:Lazy`.

---

# Módulo 2 — Vim puro (sin plugins)

Abre un archivo de texto: `nvim notas.txt`. Modo **Normal** al entrar (no escribes todavía).

## 2.1 Modos

| Modo | Cómo entrar | Cómo salir | Qué haces |
|------|-------------|------------|-----------|
| Normal | (inicio) / `Esc` / `jj` | — | Moverte y mandar órdenes |
| Insert | `i` `a` `o` `O` `I` `A` | `Esc` o `jj` | Escribir texto |
| Visual | `v` (carácter) `V` (línea) | `Esc` | Seleccionar |
| Línea de comandos | `:` | `Enter` o `Esc` | Guardar, salir, buscar |

## 2.2 Moverse (Normal)

| Tecla | Efecto |
|-------|--------|
| `h` `j` `k` `l` | Izquierda, abajo, arriba, derecha |
| `w` `b` `e` | Palabra siguiente / anterior / fin |
| `0` `$` | Inicio / fin de línea |
| `gg` `G` | Primera / última línea |
| `{` `}` | Párrafo anterior / siguiente |
| `Ctrl-d` `Ctrl-u` | Media página |
| `f` + letra | Saltar a esa letra en la línea |
| `%` | Paréntesis/llave pareja |

## 2.3 Cambiar texto

| Tecla | Efecto |
|-------|--------|
| `i` | Insertar **antes** del cursor |
| `a` | Insertar **después** |
| `o` / `O` | Línea nueva debajo / encima |
| `x` | Borrar carácter |
| `dd` | Borrar línea |
| `dw` | Borrar palabra |
| `yy` `p` `P` | Copiar línea; pegar después / antes |
| `u` | Deshacer (Vim nativo) |
| `Ctrl-r` | Rehacer |
| `.` | Repetir último cambio |

## 2.4 Guardar y salir (`:` en Normal)

| Comando | Efecto |
|---------|--------|
| `:w` | Guardar |
| `:q` | Salir (falla si hay cambios) |
| `:wq` o `ZZ` | Guardar y salir |
| `:q!` | Salir **sin** guardar |
| `:e nombre` | Abrir otro archivo |
| `:help tema` | Ayuda |

## 2.5 Buscar

| Tecla | Efecto |
|-------|--------|
| `/texto` Enter | Buscar adelante |
| `?texto` Enter | Buscar atrás |
| `n` / `N` | Siguiente / anterior (**esta config centra** la pantalla) |
| `*` / `#` | Palabra bajo el cursor |

En **esta** config: `<leader><leader>` (Espacio dos veces) quita el resaltado.

Práctica: crea `hola.txt`, escribe tres líneas con `i`, `Esc`, `dd`, `p`, `:w`, `:q`.

---

# Módulo 3 — Esta config como IDE

## 3.1 Dashboard (solo `nvim` sin archivo)

| Tecla | Acción |
|-------|--------|
| `f` | Buscar archivo |
| `g` | Buscar texto |
| `r` | Archivos recientes |
| `e` | Explorador |
| `a` | Terminal AI (opencode) |
| `m` | Mason |
| `l` | Lazy |
| `q` | Salir |

Si abres `nvim archivo`, el dashboard **no** aparece.

## 3.2 Prefijos (memoriza estos)

| Prefijo | Familia |
|---------|---------|
| `<leader>f` | Buscar |
| `<leader>g` | Git |
| `<leader>b` | Buffers (Espacio `b` solo = atrás, espera 300 ms) |
| `<leader>w` | Ventanas |
| `<leader>x` | Errores |
| `<leader>m` | Marcas Harpoon |
| `<leader>t` | Terminal |
| `<leader>r` | Ejecutar |
| `<leader>d` | Depurar |
| `<leader>fl` | Flutter |
| `<leader>a` | AI CLI (solo Neovim) |
| `<leader>c` | Copilot Chat (solo Neovim) |

which-key enseña el menú al pulsar Espacio.

## 3.3 Día a día

1. `nvim` en la carpeta del proyecto.
2. `<leader>ff` archivo, `<leader>fg` texto, `<leader>pv` árbol.
3. Editar. La statusline muestra el LSP (`dartls`, `gopls`, …) si el binario existe.
4. `<leader>fm` formatear. `gd` definición. `K` documentación. `<leader>ca` acción.
5. Git: `<leader>gs` → `<leader>gsa` hunk → `<leader>gc` → `<leader>gp`.

---

# Módulo 4 — Plugin a plugin

Cada bloque: **cuándo usarlo** y **teclas que existen en el Lua de este repo**.

### which-key

**Cuándo:** no recuerdas el atajo. Pulsa Espacio y lee el menú.

### dashboard-nvim

**Cuándo:** arranque vacío. Teclas del módulo 3.1.

### telescope.nvim

**Cuándo:** encontrar archivo o texto sin el ratón.

| Tecla | Uso |
|-------|-----|
| `<leader>ff` / `<leader>.` / `,,` | Archivo por nombre |
| `<leader>fg` | Texto en el proyecto (hace falta ripgrep) |
| `<leader>fo` | Recientes |
| `<leader>fb` | Buffers abiertos |
| `<leader>fh` | Ayuda |
| `<leader>fc` | Comandos |
| `<leader>fk` | Atajos |
| `<leader>fp` | Proyectos |
| `<leader>ps` | Símbolos LSP |

En el picker: `Enter` abre, `Ctrl-q` manda a quickfix (si el mapeo de Telescope lo permite).

### neo-tree + oil.nvim

**Cuándo:** árbol de archivos vs editar una carpeta como buffer.

| Tecla | Plugin | Uso |
|-------|--------|-----|
| `<leader>pv` | neo-tree | Mostrar/ocultar árbol |
| `<leader>pe` / `<leader>pf` | neo-tree | Enfocar árbol |
| `<leader>fr` | neo-tree | Revelar archivo actual |
| `<leader>bf` | neo-tree | Buffers |
| `<leader>-` / `<leader>oe` | oil | Editar directorio |

En oil: editas nombres como texto; guardar aplica el rename. En neo-tree: `a` añadir, `d` borrar, `r` renombrar (teclas del propio plugin).

### harpoon

**Cuándo:** 3–9 archivos que abres todo el rato.

`<leader>ma` marca, `<leader>1`…`<leader>9` salta, `<leader>mh` lista, `<leader>mp` / `<leader>mn` anterior/siguiente.

### lualine + bufferline + dropbar + nvim-notify + indent-blankline + nvim-highlight-colors

**Cuándo:** no pulsas nada. Statusline (git, LSP, diagnostics), pestañas, migas de pan, avisos, indent, colores hex.

Buffers: `<S-l>` / `<S-h>` siguiente/anterior, `<leader>bn` / `bp` / `bd` / `bl` / `bh` / `bP` / `bt` / `to`.

### Comment.nvim + vim-surround + nvim-autopairs + flash.nvim

**Cuándo:** comentar, envolver, paréntesis, saltar.

| Tecla | Uso |
|-------|-----|
| `gcc` | Comentar línea |
| `gc` (visual) | Comentar selección |
| `ysiw"` | Surround: comillas a la palabra (plugin surround) |
| `ds"` | Quitar comillas |
| `cs"'` | Cambiar `"` por `'` |
| `s` | Flash: saltar a un carácter |
| `S` | Normal: selección treesitter. **Visual `S` = surround**, no Flash |

### treesitter + textobjects + context

**Cuándo:** coloreado real y seleccionar función/clase.

`vif` interior de función, `daf` toda la función, `]f` / `[f` siguiente/anterior función. `<leader>sa` / `<leader>sA` intercambiar argumentos.

### nvim-lspconfig + mason + none-ls + nvim-cmp

**Cuándo:** el archivo es de un lenguaje con servidor instalado.

| Tecla | Uso |
|-------|-----|
| `gd` `gi` `go` | Definición / implementación / tipo |
| `K` | Documentación |
| `gR` | Referencias (Trouble) |
| `gs` | Firma |
| `<leader>rn` | Renombrar |
| `<leader>ca` | Code action |
| `<leader>fm` | Formatear (none-ls si el CLI existe) |
| `Ctrl-Space` | Completar (insert) |

`:Mason` instala servidores. Dart **no** va por Mason: lo arranca flutter-tools (hace falta Flutter SDK).

### trouble.nvim + todo-comments

`<leader>xx` panel, `xw` workspace, `xd` documento, `xn` / `xp` error siguiente/anterior, `xt` TODOs, `]t` / `[t` TODO.

### fugitive + gitsigns + diffview + neogit + git-conflict

**Cuándo:** cambios de git. En un conflicto de merge, las teclas `gc*` eligen lados.

Flujo corto: `<leader>gs` estado → `<leader>gn` hunk → `<leader>gsa` stage → `<leader>gc` commit → `<leader>gp` push. Diff grande: `<leader>gdo`. LazyGit TUI: `<leader>tg` (si `lazygit` está en PATH).

### toggleterm + overseer + code_runner + vim-test

| Tecla | Uso |
|-------|-----|
| `<leader>tt` | Terminal flotante |
| `jj` en terminal | Volver a Normal |
| `<leader>r` / `rf` / `rp` | Ejecutar código / archivo / proyecto |
| `<leader>rs` / `rc` | Parar / cerrar runner |
| `<leader>oo` / `or` | Tareas Overseer |
| `<leader>ten` / `tenf` / `tena` / `tenl` | Tests (hace falta herramienta del lenguaje) |

### nvim-dap

Punto de ruptura `<leader>db`, continuar `dc`, step `do` `di` `dO`, UI `du`, terminar `dx`. El adaptador debe existir (Mason / Flutter).

### flutter-tools

Proyecto Flutter: `<leader>fla` run, `flr` reload, `fls` restart, `flq` quit, `fld` DevTools, `flsd` dispositivo, `fle` emulador.

### copilot.vim + CopilotChat

Hace falta cuenta GitHub Copilot. Chat: `<leader>cc`. Visual + `ce` / `cr` / `cf` / `co` / `ct`.

### AI terminals (`<leader>a*`)

Cada CLI es un programa aparte (opencode, codex, claude, gemini, grok, copilot). Si no está instalado, el plugin **muestra el comando de instalación**; no falla en silencio. Visual → `<leader>as` → eliges agente.

### undotree, persistence, zen-mode, grug-far, tagbar, ufo

| Tecla | Uso |
|-------|-----|
| `<leader>u` Normal | Árbol de undo (**visual** `u` = minúsculas) |
| `<leader>qs` / `ql` / `qd` | Sesión |
| `<leader>zz` | Zen |
| `<leader>sr` | Buscar/reemplazar proyecto |
| `<leader>tb` | Tagbar (hace falta `ctags` en PATH) |
| `<leader>za` `zR` `zM` | Folds |

### themes

Colores: dracula, molokai, solarized, onedark, gruvbox, rose-pine, catppuccin. Cambiar: `:colorscheme catppuccin` (o el que esté cargado).

---

# Módulo 5 — IdeaVim (IntelliJ / Android Studio)

1. Plugins → **IdeaVim** → **Tools \| Vim**.
2. Copia `.ideavimrc` del repo a `~/.ideavimrc`.
3. `:source ~/.ideavimrc`.
4. Mismos prefijos que Neovim. **No** hay `<leader>a*` ni CopilotChat.
5. IDs raros: `:actionlist`. Flutter: plugin Flutter.

No se valida la GUI del IDE desde la línea de comandos de este repo.

---

# Módulo 6 — Si algo falla

| Síntoma | Qué hacer |
|---------|-----------|
| Cuadrados en iconos | Fuente JetBrainsMono NFM + reiniciar terminal |
| Plugin no carga | `:Lazy` → sync |
| No hay LSP | `:Mason`, `:checkhealth vim.lsp`, binario en PATH |
| Dart no conecta | Flutter SDK; no dupliques `dartls` |
| Atajo “no funciona” | Prefijo 300 ms; `:Telescope keymaps` |
| `git-conflict` error `rgb` | Config actual ya mapea alias de `vim.validate`; actualiza el repo |

Tablas completas: [WORKFLOW.md](WORKFLOW.md). Instalar: [README.md](README.md).

---

*Curso alineado con el código del repo. Si el Lua cambia, este archivo debe actualizarse; no memorices copias sueltas.*
