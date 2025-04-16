# 🧠 Mi Configuración de Neovim en Lua (Analizada)

Esta es una configuración personalizada de Neovim basada en Lua, organizada modularmente y gestionada con `packer.nvim`.

**Fecha de Análisis:** 15 de abril de 2025

## ✨ Características Principales

* **Gestor de Plugins:** `packer.nvim` con auto-instalación y recarga automática.
* **Interfaz de Usuario:**
    * Pantalla de inicio con `dashboard-nvim`.
    * Barra de estado potente con `lualine.nvim`.
    * Ayuda contextual de atajos con `which-key.nvim`.
    * Explorador de archivos moderno con `neo-tree.nvim`.
    * Búsqueda fuzzy avanzada con `telescope.nvim`.
    * Notificaciones mejoradas con `nvim-notify`.
    * Líneas de indentación visuales con `indent-blankline.nvim`.
    * Terminal integrada con `toggleterm.nvim`.
    * Navegación de diagnósticos con `trouble.nvim`.
* **Edición y Movimiento:**
    * Marcadores rápidos de archivos con `harpoon`.
    * Gestión del historial de deshacer con `undotree`.
    * Manipulación de "alrededores" (comillas, paréntesis) con `vim-surround`.
    * Cierre automático de pares con `nvim-autopairs`.
    * Comentarios rápidos con `Comment.nvim`.
    * Movimiento rápido con `vim-easymotion`.
* **Formateo y Linting:**
    * Formateo unificado al guardar con `conform.nvim`.
* **Desarrollo:**
    * Soporte LSP robusto con `nvim-lspconfig`, `mason.nvim` y `mason-lspconfig.nvim`.
    * Autocompletado avanzado con `nvim-cmp` y `LuaSnip`.
    * Integración Git con `vim-fugitive`, `gitsigns.nvim`, `NeogitOrg/neogit` y `diffview.nvim`.
    * Soporte para `Treesitter` para resaltado de sintaxis mejorado.
    * Herramientas específicas para Flutter con `flutter-tools.nvim`.
    * Navegación de código basada en etiquetas con `preservim/tagbar`.
* **Otros:**
    * Vista previa de Markdown con `markdown-preview.nvim`.
    * Integración con `fzf`.

## 🚀 Instalación

1.  **Clona el repositorio:**
    ```bash
    git clone <URL_DE_TU_REPOSITORIO> ~/.config/nvim
    ```
2.  **Inicia Neovim:**
    ```bash
    nvim
    ```
    Packer se instalará automáticamente (si es necesario) y luego instalará todos los plugins definidos en `lua/plugins.lua`. Puede que necesites reiniciar Neovim después de la instalación inicial (`:q` y `nvim` de nuevo).

## ⌨️ Atajos de Teclado Principales

**Nota:** `<leader>` está mapeado a la tecla `Espacio`.

### Generales (Core & Settings - `lua/keymaps/core.lua`)

| Atajo         | Modo   | Acción                                       | Plugin/Origen        | Descripción                               |
| :------------ | :----- | :------------------------------------------- | :------------------- | :---------------------------------------- |
| `jj`          | Insert | `<Esc>`                                      | `core.lua`           | Salir del modo Insertar.                  |
| `<leader><CR>` | Normal | `:luafile ~/.config/nvim/init.lua<CR>`       | `core.lua`           | Recargar la configuración completa.       |
| `<leader>ot`  | Normal | `:TagbarToggle<CR>`                          | `core.lua` / Tagbar  | Abrir/Cerrar la barra de etiquetas Tagbar. |

### Navegación y Buffers (`lua/keymaps/buffers.lua`)

| Atajo       | Modo   | Acción    | Plugin/Origen | Descripción         |
| :---------- | :----- | :-------- | :------------ | :------------------ |
| `<leader>bn` | Normal | `:bn<CR>` | `buffers.lua` | Buffer siguiente.   |
| `<leader>bp` | Normal | `:bp<CR>` | `buffers.lua` | Buffer anterior.    |

### Explorador de Archivos (Neo-tree - `lua/keymaps/neotree.lua`)

| Atajo        | Modo   | Acción                                | Plugin/Origen       | Descripción                                  |
| :----------- | :----- | :------------------------------------ | :------------------ | :------------------------------------------- |
| `<leader>pv` | Normal | `:Neotree toggle<CR>`                 | `neotree.lua`       | Abrir/Cerrar el explorador Neo-tree.         |
| `<leader>nbr` | Normal | `:Neotree buffers reveal float<CR>`   | `neotree.lua`       | Mostrar buffers abiertos en Neo-tree flotante. |
| `<leader>ng`  | Normal | `:Neotree git_status<CR>`             | `neotree.lua`       | Mostrar estado de Git en Neo-tree.           |
| `H` (en Neo-tree) | Normal | `toggle_hidden`                  | `plugins.lua` (conf) | Mostrar/Ocultar archivos ocultos en Neo-tree. |

**⚠️ Conflicto Potencial:** `lua/keymaps/explorer.lua` también define `<leader>pv` para `:Ex`. Se recomienda eliminar esa línea para usar Neo-tree consistentemente.

### Búsqueda (Telescope - `lua/keymaps/telescope.lua`)

| Atajo         | Modo   | Acción                        | Plugin/Origen     | Descripción                                    |
| :------------ | :----- | :---------------------------- | :---------------- | :--------------------------------------------- |
| `<C-p>`       | Normal | `:Telescope git_files<CR>`    | `telescope.lua`   | Buscar archivos en el repositorio Git.           |
| `<leader>pf`  | Normal | `:Telescope find_files<CR>`   | `telescope.lua`   | Buscar todos los archivos (fuzzy).             |
| `<leader>pg`  | Normal | `:Telescope live_grep<CR>`    | `telescope.lua`   | Buscar texto en archivos del proyecto (grep). |
| `<leader>fb`  | Normal | `:Telescope file_browser<CR>` | `telescope.lua`   | Abrir un explorador de archivos con Telescope. |
| `<C-e>`       | Normal | `toggle_telescope(harpoon:list())` | `telescope.lua` | Mostrar la lista de archivos de Harpoon en Telescope. |

### Terminal (Toggleterm - `lua/keymaps/terminal.lua`)

| Atajo       | Modo     | Acción                                   | Plugin/Origen   | Descripción                                    |
| :---------- | :------- | :--------------------------------------- | :-------------- | :--------------------------------------------- |
| `<leader>t` | Normal   | `<cmd>ToggleTerm<CR>`                    | `terminal.lua`  | Abrir/Cerrar terminal flotante por defecto.    |
| `<leader>th` | Normal   | `<cmd>ToggleTerm direction=horizontal<CR>` | `terminal.lua`  | Abrir/Cerrar terminal horizontal (split).      |
| `<leader>tv` | Normal   | `<cmd>ToggleTerm direction=vertical<CR>`   | `terminal.lua`  | Abrir/Cerrar terminal vertical (split).        |
| `<leader>tt` | Normal   | `<cmd>ToggleTerm direction=tab<CR>`       | `terminal.lua`  | Abrir terminal en una nueva pestaña.            |
| `<Esc>`     | Terminal | `<C-\><C-n>`                             | `terminal.lua`  | Salir del modo terminal (volver a Normal).    |

### Git (`lua/keymaps/git.lua`)

| Atajo        | Modo   | Acción                          | Plugin/Origen | Descripción                               |
| :----------- | :----- | :------------------------------ | :------------ | :---------------------------------------- |
| `<leader>gl` | Normal | `:Git log<CR>`                  | `git.lua`     | Ver historial de commits (Fugitive).      |
| `<leader>gc` | Normal | `:Git commit<CR>`               | `git.lua`     | Crear un commit (Fugitive).             |
| `<leader>ga` | Normal | `:Git add %<CR>`                | `git.lua`     | Añadir el archivo actual al stage (Fugitive). |
| `<leader>gs` | Normal | `:Git status<CR>`               | `git.lua`     | Ver estado de Git (Fugitive).             |
| `<leader>gps` | Normal | `:Git push<CR>`                 | `git.lua`     | Ejecutar `git push`.                       |
| `<leader>gpl` | Normal | `:Git pull<CR>`                 | `git.lua`     | Ejecutar `git pull`.                       |
| `<leader>gg` | Normal | `:Neogit<CR>`                   | `git.lua`     | Abrir la interfaz de Neogit.              |
| `<leader>gC` | Normal | `telescope.builtin.git_commits` | `git.lua`     | Buscar commits con Telescope.             |
| `<leader>gb` | Normal | `telescope.builtin.git_branches`| `git.lua`     | Buscar ramas con Telescope.               |
| `<leader>gS` | Normal | `telescope.builtin.git_status`  | `git.lua`     | Ver estado de Git con Telescope.          |

**Nota:** `which-key` está configurado para mostrar ayuda para los atajos que empiezan con `<leader>g` y `<leader>gp`.

### LSP (Language Server Protocol - `lua/mappings.lua` y `lua/keymaps/lspzero.lua`)

**⚠️ Advertencia:** Existen definiciones duplicadas/redundantes entre `mappings.lua` y `lspzero.lua`. Se recomienda consolidar estos atajos en la configuración `on_attach` de `lsp.lua`. Los atajos listados aquí reflejan las definiciones encontradas, pero su comportamiento final dependerá del orden de carga y la lógica `LspAttach`.

| Atajo         | Modo         | Acción                             | Origen (Potencial)      | Descripción                             |
| :------------ | :----------- | :--------------------------------- | :---------------------- | :-------------------------------------- |
| `K`           | Normal       | `vim.lsp.buf.hover()`              | `lspzero.lua` (LspAttach) | Mostrar documentación al pasar el cursor. |
| `gd`          | Normal       | `vim.lsp.buf.definition()`         | `lspzero.lua` (LspAttach) | Ir a la definición.                     |
| `gD`          | Normal       | `vim.lsp.buf.declaration()`        | `lspzero.lua` (LspAttach) | Ir a la declaración.                    |
| `gi`          | Normal       | `vim.lsp.buf.implementation()`     | `lspzero.lua` (LspAttach) | Ir a la implementación.                 |
| `go`          | Normal       | `vim.lsp.buf.type_definition()`    | `lspzero.lua` (LspAttach) | Ir a la definición de tipo.             |
| `gr`          | Normal       | `vim.lsp.buf.references()`         | `lspzero.lua` (LspAttach) | Mostrar referencias del símbolo.         |
| `gs`          | Normal       | `vim.lsp.buf.signature_help()`     | `lspzero.lua` (LspAttach) | Mostrar ayuda de firma (parámetros).    |
| `<C-k>`       | Insert       | `vim.lsp.buf.signature_help()`     | `mappings.lua`, `lspzero.lua` | Mostrar ayuda de firma al escribir.     |
| `<leader>rn`  | Normal       | `vim.lsp.buf.rename()`             | `mappings.lua`, `lspzero.lua` | Renombrar símbolo en todo el proyecto.  |
| `<F2>`        | Normal       | `vim.lsp.buf.rename()`             | `lspzero.lua` (LspAttach) | Renombrar símbolo (alternativa).        |
| `<leader>ca`  | Normal       | `vim.lsp.buf.code_action()`        | `mappings.lua`, `lspzero.lua` | Mostrar/aplicar acciones de código (fixes). |
| `<F4>`        | Normal       | `vim.lsp.buf.code_action()`        | `lspzero.lua` (LspAttach) | Mostrar/aplicar acciones de código (alt). |
| `<F3>`        | Normal, Visual | `vim.lsp.buf.format({async = true})` | `lspzero.lua` (LspAttach) | Formatear el buffer/selección con LSP.   |
| `<leader>b`   | Normal       | `<C-o>`                            | `mappings.lua`          | Ir atrás en la lista de saltos.        |
| `<leader>f`   | Normal       | `<C-i>`                            | `mappings.lua`          | Ir adelante en la lista de saltos.       |

### Gestión de Plugins (Packer - `lua/keymaps/plugins.lua`)

| Atajo       | Modo   | Acción             | Plugin/Origen | Descripción                          |
| :---------- | :----- | :----------------- | :------------ | :----------------------------------- |
| `<leader>pi` | Normal | `:PackerInstall<CR>` | `plugins.lua` | Instalar nuevos plugins.             |
| `<leader>pc` | Normal | `:PackerClean<CR>`   | `plugins.lua` | Limpiar plugins no utilizados.      |
| `<leader>ps` | Normal | `:PackerSync<CR>`    | `plugins.lua` | Sincronizar (instalar/actualizar/limpiar). |

### Dashboard (`lua/keymaps/startify.lua` - Plugin: `dashboard-nvim`)

Estos atajos solo funcionan cuando el Dashboard está visible al iniciar Neovim:

| Atajo | Modo   | Acción                                | Descripción                                |
| :---- | :----- | :------------------------------------ | :----------------------------------------- |
| `1`   | Normal | `:Telescope find_files<CR>`           | Buscar Archivo (Telescope)                 |
| `2`   | Normal | `:Telescope live_grep<CR>`            | Buscar Palabra (Telescope)                 |
| `3`   | Normal | `:Telescope oldfiles<CR>`             | Archivos Recientes (Telescope)             |
| `4`   | Normal | `:Neotree toggle<CR>`                 | Explorador de Archivos (Neo-tree)          |
| `5`   | Normal | `:ToggleTerm<CR>`                     | Abrir/Cerrar Terminal (Toggleterm)         |
| `6`   | Normal | `:edit ~/.config/nvim/lua/plugins.lua<CR>` | Editar Configuración de Plugins            |
| `7`   | Normal | `:PackerSync<CR>`                     | Sincronizar Plugins (Packer)               |
| `8`   | Normal | `:Mason<CR>`                          | Abrir Interfaz de Mason (Instalador LSP) |

### Harpoon (`lua/plugin/harpoon.lua`)

| Atajo       | Modo   | Acción                             | Plugin/Origen | Descripción                               |
| :---------- | :----- | :--------------------------------- | :------------ | :---------------------------------------- |
| `<leader>a` | Normal | `harpoon:list():add()`             | `harpoon.lua` | Añadir archivo actual a la lista Harpoon. |
| `<C-h>`     | Normal | `harpoon.ui:toggle_quick_menu()` | `harpoon.lua` | Mostrar menú rápido de Harpoon.           |
| `<leader>1` - `<leader>9` | Normal | `harpoon:list():select(N)`      | `harpoon.lua` | Ir al archivo N en la lista Harpoon.    |
| `<C-S-P>`   | Normal | `harpoon:list():prev()`            | `harpoon.lua` | Ir al archivo anterior en Harpoon.      |
| `<C-S-N>`   | Normal | `harpoon:list():next()`            | `harpoon.lua` | Ir al archivo siguiente en Harpoon.     |

### Undotree (`lua/plugin/undotree.lua`)

| Atajo       | Modo   | Acción                | Plugin/Origen | Descripción                           |
| :---------- | :----- | :-------------------- | :------------ | :------------------------------------ |
| `<leader>u` | Normal | `:UndotreeToggle<CR>` | `undotree.lua` | Abrir/Cerrar el visualizador Undotree. |

### Otros Comandos

* **`:Fjson`** (Comando de Usuario definido en `lua/keymaps/json.lua`): Ejecuta el script `~/.vim/scripts/formatear_json.vim`. Asegúrate de que este script existe.
* **`:FormatInfo`** (Comando de Usuario definido en `lua/plugins.lua` dentro de la config de `conform.nvim`): Muestra información sobre los formateadores disponibles para el tipo de archivo actual.

## ⚙️ Configuración General (`lua/settings.lua`)

* Números de línea relativos habilitados (`number`, `relativenumber`).
* Tabulación configurada a 4 espacios, usando espacios en lugar de tabs (`tabstop`, `shiftwidth`, `expandtab`).
* Indentación inteligente (`smartindent`).
* Colores de terminal verdaderos (`termguicolors`).
* Portapapeles del sistema integrado (`clipboard=unnamedplus`).
* Scroll offset de 8 líneas (`scrolloff`).
* Límite de columna para coloreado de sintaxis alto (`synmaxcol=2000`).
* Resaltado de línea actual (`cursorline`).
* Columna de color en la posición 80 (`colorcolumn='80'`).
* Tema de color inicial: `dracula` (se puede cambiar aquí o con la función en `lua/plugin/colors.lua`).
* Host de Python 3 especificado explícitamente.

## 🔌 LSP y Formateo

* **LSP:** Gestionado por `mason.nvim` para instalar servidores y `nvim-lspconfig` para configurarlos. Servidores asegurados incluyen: `pyright`, `html`, `cssls`, `bashls`, `jsonls`, `yamlls`, `lua_ls`, `marksman`, `clangd`, `rust_analyzer`, `texlab`. Se configuran automáticamente.
* **Completado:** `nvim-cmp` con fuentes de LSP, LuaSnip, buffer y path. Usa `<C-Space>` para completar y `<CR>` para confirmar.
* **Formateo:** `conform.nvim` está configurado para formatear al guardar (`format_on_save`) usando diferentes herramientas según el tipo de archivo (Stylua, Gofmt, Google Java Format, Ktlint, Dart Format, Swift Format, SQLFluff, shfmt, xmllint, Black, iSort, ClangFormat, Prettier).

---

¡Espero que este README te sea muy útil para recordar y entender tu configuración!
