# 🧠 Neovim + IntelliJ Ultra Configuration | Configuración Ultra Completa

> **EN**: Professional Neovim configuration with Lazy.nvim, native LSP, and 70+ meticulously optimized plugins featuring 300+ synchronized commands for multi-language development (Flutter/Dart, Swift, Kotlin, C/C++, etc.) + complete IntelliJ IDEA keymaps synchronization. **🍎 Optimized for macOS (MacBook Pro)**.
>
> **ES**: Configuración profesional de Neovim con Lazy.nvim, LSP nativo, y más de 70 plugins meticulosamente optimizados con 300+ comandos sincronizados para desarrollo en múltiples lenguajes + sincronización completa de keymaps con IntelliJ IDEA. **🍎 Optimizado para macOS (MacBook Pro)**.

---

## 📚 Table of Contents | Índice

- [🚀 Quick Install | Instalación Rápida](#-quick-install--instalación-rápida)
- [⌨️ Complete Keymap Guide | Guía Completa de Keymaps](#️-complete-keymap-guide--guía-completa-de-keymaps)
  - [🔍 Find & Search | Búsqueda](#-find--search--búsqueda)
  - [📁 Git Operations | Operaciones Git](#-git-operations--operaciones-git)
  - [🔧 LSP & Development | LSP y Desarrollo](#-lsp--development--lsp-y-desarrollo)
  - [📌 Marks & Harpoon | Marcas y Harpoon](#-marks--harpoon--marcas-y-harpoon)
  - [🚨 Trouble & Diagnostics | Diagnósticos y Problemas](#-trouble--diagnostics--diagnósticos-y-problemas)
  - [📁 File Explorer | Explorador de Archivos](#-file-explorer--explorador-de-archivos)
  - [💻 Terminal & Tasks | Terminal y Tareas](#-terminal--tasks--terminal-y-tareas)
  - [📱 Flutter Development | Desarrollo Flutter](#-flutter-development--desarrollo-flutter)
  - [🧪 Testing | Pruebas](#-testing--pruebas)
  - [🚀 Code Runner | Ejecutor de Código](#-code-runner--ejecutor-de-código)
  - [📦 Buffer & Window Management | Gestión de Buffers y Ventanas](#-buffer--window-management--gestión-de-buffers-y-ventanas)
- [🔄 Buffer/Tab & Window Navigation | Navegación de Buffers/Tabs y Ventanas](#-buffertab--window-navigation--navegación-de-bufferstabs-y-ventanas)
- [📦 Plugin Ecosystem | Ecosistema de Plugins](#-plugin-ecosystem--ecosistema-de-plugins)
- [🎯 Plugin Use Cases | Casos de Uso por Plugin](#-plugin-use-cases--casos-de-uso-por-plugin)
- [🔧 IntelliJ IDEA Synchronization | Sincronización con IntelliJ](#-intellij-idea-synchronization--sincronización-con-intellij)

---

## 🚀 Quick Install | Instalación Rápida

### English
```bash
# Clone configuration
git clone https://github.com/chochy2001/Neovim-Vim_Configuration.git ~/.config/nvim

# Auto-setup with Lazy.nvim
nvim

# For IntelliJ IDEA sync (required for cross-editor workflow)
cp ~/.config/nvim/.ideavimrc ~/

# Install language servers (optional but recommended)
npm install -g vscode-langservers-extracted  # For JSON, HTML, CSS, ESLint
# LSPs are auto-configured for: Lua, Dart, C/C++, Swift, Kotlin, JSON, YAML
```

### Español
```bash
# Clonar configuración
git clone https://github.com/chochy2001/Neovim-Vim_Configuration.git ~/.config/nvim

# Configuración automática con Lazy.nvim
nvim

# Para sincronización con IntelliJ IDEA (requerido para flujo cross-editor)
cp ~/.config/nvim/.ideavimrc ~/

# Instalar servidores de lenguaje (opcional pero recomendado)
npm install -g vscode-langservers-extracted  # Para JSON, HTML, CSS, ESLint
# LSPs están auto-configurados para: Lua, Dart, C/C++, Swift, Kotlin, JSON, YAML
```

---

## ⌨️ Complete Keymap Guide | Guía Completa de Keymaps

> **Leader Key**: `<Space>` | **Modo Normal** salvo que se indique lo contrario

### 🔍 Find & Search | Búsqueda

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>ff` | Telescope find files | `:action GotoFile` | **EN**: Find files by name / **ES**: Buscar archivos por nombre |
| `<leader>fg` | Telescope live grep | `:action FindInPath` | **EN**: Search text in project / **ES**: Buscar texto en proyecto |
| `<leader>fo` | Telescope oldfiles | `:action RecentFiles` | **EN**: Recent files / **ES**: Archivos recientes |
| `<leader>fb` | Telescope buffers | `:action Switcher` | **EN**: Find open buffers / **ES**: Buscar buffers abiertos |
| `<leader>fh` | Telescope help tags | `:action HelpTopics` | **EN**: Search help / **ES**: Buscar ayuda |
| `<leader>fc` | Telescope commands | `:action GotoAction` | **EN**: Find commands / **ES**: Buscar comandos |
| `<leader>fk` | Telescope keymaps | `:action Keymap` | **EN**: Find keymaps / **ES**: Buscar keymaps |
| `<leader>fp` | Telescope projects | `:action ManageRecentProjects` | **EN**: Find projects / **ES**: Buscar proyectos |
| `<leader>fr` | Neo-tree reveal file | `:action SelectInProjectView` | **EN**: Reveal file in tree / **ES**: Mostrar archivo en árbol |
| `<leader><leader>` | Quick find files | `:action GotoFile` | **EN**: Quick file search (double leader) / **ES**: Búsqueda rápida (doble leader) |
| `<leader>.` | Quick find files | `:action GotoFile` | **EN**: Quick file search (leader+dot) / **ES**: Búsqueda rápida (leader+punto) |
| `,,` | Quick find files | `:action GotoFile` | **EN**: Quick file search (double comma) / **ES**: Búsqueda rápida (doble coma) |

### 📁 Git Operations | Operaciones Git

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>gs` | Fugitive status | `:action Vcs.Show.Local.Changes` | **EN**: Git status / **ES**: Estado de Git |
| `<leader>gc` | Git commit | `:action CheckinProject` | **EN**: Git commit / **ES**: Commit de Git |
| `<leader>gd` | Git diff split | `:action Compare.SameVersion` | **EN**: Git diff / **ES**: Diferencias Git |
| `<leader>gb` | Git browse | `:action Github.Open.In.Browser` | **EN**: Open in browser / **ES**: Abrir en navegador |
| `<leader>gB` | Git blame | `:action Annotate` | **EN**: Git blame / **ES**: Git blame |
| `<leader>gg` | Neogit interface | `:action Git.Menu` | **EN**: Git interface / **ES**: Interfaz de Git |
| `<leader>gdo` | Diffview open | `:action Vcs.ShowDiffWithLocal` | **EN**: Open diff view / **ES**: Abrir vista diff |
| `<leader>gdc` | Diffview close | `:action Vcs.ShowDiffWithLocal` | **EN**: Close diff view / **ES**: Cerrar vista diff |
| `<leader>hs` | Stage hunk | `:action Vcs.Add` | **EN**: Stage git hunk / **ES**: Agregar hunk |
| `<leader>hr` | Reset hunk | `:action Vcs.RollbackChangedLines` | **EN**: Reset git hunk / **ES**: Revertir hunk |
| `<leader>hp` | Preview hunk | `:action Vcs.ShowDiff` | **EN**: Preview hunk changes / **ES**: Previsualizar cambios |
| `]c` / `[c` | Next/Prev hunk | `:action VcsShowNextChangeMarker` | **EN**: Navigate hunks / **ES**: Navegar hunks |

### 🔧 LSP & Development | LSP y Desarrollo

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `gd` | Go to definition | `:action GotoDeclaration` | **EN**: Go to definition / **ES**: Ir a definición |
| `gD` | Go to declaration | `:action GotoDeclaration` | **EN**: Go to declaration / **ES**: Ir a declaración |
| `gi` | Go to implementation | `:action GotoImplementation` | **EN**: Go to implementation / **ES**: Ir a implementación |
| `gr` | Show references | `:action FindUsages` | **EN**: Find references / **ES**: Buscar referencias |
| `K` | Hover documentation | `:action QuickJavaDoc` | **EN**: Show documentation / **ES**: Mostrar documentación |
| `<C-s>` | Signature help | `:action ParameterInfo` | **EN**: Show signature / **ES**: Mostrar signatura |
| **LSP Navigation with Leader** | | | |
| `<leader>gD` | Go to declaration | `:action GotoDeclaration` | **EN**: Go to declaration (leader) / **ES**: Ir a declaración (leader) |
| `<leader>gd` | Go to definition | `:action GotoDeclaration` | **EN**: Go to definition (leader) / **ES**: Ir a definición (leader) |
| `<leader>gi` | Go to implementation | `:action GotoImplementation` | **EN**: Go to implementation (leader) / **ES**: Ir a implementación (leader) |
| `<leader>gr` | Show references | `:action FindUsages` | **EN**: Find references (leader) / **ES**: Buscar referencias (leader) |
| `<leader>gT` | Type definition | `:action GotoTypeDeclaration` | **EN**: Go to type definition / **ES**: Ir a definición de tipo |
| **LSP Information & Actions** | | | |
| `<leader>lh` | Hover documentation | `:action QuickJavaDoc` | **EN**: LSP hover documentation / **ES**: Documentación LSP |
| `<leader>ls` | Signature help | `:action ParameterInfo` | **EN**: LSP signature help / **ES**: Ayuda de signatura LSP |
| `<leader>rn` | Rename symbol | `:action RenameElement` | **EN**: Rename symbol / **ES**: Renombrar símbolo |
| `<leader>ca` | Code actions | `:action ShowIntentionActions` | **EN**: Code actions / **ES**: Acciones de código |
| `<leader>lf` | Format document | `:action ReformatCode` | **EN**: Format code / **ES**: Formatear código |
| `<leader>lw` | List workspace | `:action ShowBookmarks` | **EN**: List workspace / **ES**: Listar workspace |

### 📌 Marks & Harpoon | Marcas y Harpoon

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>ma` | Harpoon add file | `:action AddToFavorites` | **EN**: Add file to harpoon / **ES**: Agregar archivo a harpoon |
| `<leader>mm` | Harpoon toggle UI | `:action RecentFiles` | **EN**: Toggle harpoon menu / **ES**: Alternar menú harpoon |
| `<leader>1-9` | Harpoon go to 1-9 | `'1-'9` (marks) | **EN**: Quick jump to slot / **ES**: Salto rápido a ranura |
| `<C-S-P>` | Harpoon previous | `:action Back` | **EN**: Previous harpoon / **ES**: Harpoon anterior |
| `<C-S-N>` | Harpoon next | `:action Forward` | **EN**: Next harpoon / **ES**: Siguiente harpoon |

### 🚨 Trouble & Diagnostics | Diagnósticos y Problemas

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>xx` | Trouble toggle | `:action ActivateProblemsViewToolWindow` | **EN**: Toggle trouble list / **ES**: Alternar lista de problemas |
| `<leader>xw` | Workspace diagnostics | `:action ActivateProblemsViewToolWindow` | **EN**: Workspace diagnostics / **ES**: Diagnósticos del workspace |
| `<leader>xd` | Document diagnostics | `:action ActivateProblemsViewToolWindow` | **EN**: Document diagnostics / **ES**: Diagnósticos del documento |
| `<leader>xl` | Location list | `:action ActivateProblemsViewToolWindow` | **EN**: Location list / **ES**: Lista de ubicaciones |
| `<leader>xq` | Quickfix list | `:action ActivateProblemsViewToolWindow` | **EN**: Quickfix list / **ES**: Lista de arreglos rápidos |
| `<leader>xn` | Next error | `:action GotoNextError` | **EN**: Go to next error / **ES**: Ir al siguiente error |
| `<leader>xp` | Previous error | `:action GotoPreviousError` | **EN**: Go to previous error / **ES**: Ir al error anterior |

### 📁 File Explorer | Explorador de Archivos

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>pv` | Neo-tree toggle | `:action ActivateProjectToolWindow` | **EN**: Toggle project tree / **ES**: Alternar árbol de proyecto |
| `<leader>pe` | Neo-tree focus | `:action ActivateProjectToolWindow` | **EN**: Focus project tree / **ES**: Enfocar árbol de proyecto |
| `<leader>bf` | Neo-tree buffers | `:action Switcher` | **EN**: Show buffer tree / **ES**: Mostrar árbol de buffers |
| `-` | Oil file explorer | `:action ActivateProjectToolWindow` | **EN**: Oil directory editor / **ES**: Editor de directorio Oil |
| `<leader>-` | Oil parent directory | `:action ActivateProjectToolWindow` | **EN**: Oil parent directory / **ES**: Directorio padre Oil |
| `<leader>oe` | Oil file explorer | `:action ActivateProjectToolWindow` | **EN**: Oil file explorer / **ES**: Explorador de archivos Oil |

### 💻 Terminal & Tasks | Terminal y Tareas

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>th` | Horizontal terminal | `:action ActivateTerminalToolWindow` | **EN**: Horizontal terminal / **ES**: Terminal horizontal |
| `<leader>tv` | Vertical terminal | `:action ActivateTerminalToolWindow` | **EN**: Vertical terminal / **ES**: Terminal vertical |
| `<leader>tt` | Tab terminal | `:action ActivateTerminalToolWindow` | **EN**: Terminal in new tab / **ES**: Terminal en nueva pestaña |
| `<leader>tf` | Float terminal | `:action ActivateTerminalToolWindow` | **EN**: Floating terminal / **ES**: Terminal flotante |
| `<leader>tg` | LazyGit terminal | `:action ActivateTerminalToolWindow` | **EN**: LazyGit interface / **ES**: Interfaz LazyGit |
| `<leader>tn` | Node terminal | `:action ActivateTerminalToolWindow` | **EN**: Node.js terminal / **ES**: Terminal Node.js |
| `<leader>tp` | Python terminal | `:action ActivateTerminalToolWindow` | **EN**: Python terminal / **ES**: Terminal Python |
| `<leader>tu` | Htop terminal | `:action ActivateTerminalToolWindow` | **EN**: Htop system monitor / **ES**: Monitor del sistema Htop |
| `<leader>tF` | Flutter terminal | `:action ActivateTerminalToolWindow` | **EN**: Flutter terminal / **ES**: Terminal Flutter |
| **Task Management** | | | |
| `<leader>oo` | Overseer toggle | `:action ActivateRunToolWindow` | **EN**: Task manager / **ES**: Gestor de tareas |
| `<leader>or` | Overseer run | `:action Run` | **EN**: Run task / **ES**: Ejecutar tarea |
| `<leader>oi` | Overseer info | `:action EditConfigurations` | **EN**: Task information / **ES**: Información de tareas |
| `<leader>ob` | Overseer build | `:action BuildProject` | **EN**: Build project / **ES**: Construir proyecto |
| `<leader>oq` | Overseer quick | `:action RunClass` | **EN**: Quick action / **ES**: Acción rápida |
| `<leader>ot` | Overseer tasks | `:action ActivateRunToolWindow` | **EN**: Task actions / **ES**: Acciones de tareas |

### 📱 Flutter Development | Desarrollo Flutter

> **Note**: These keymaps are active only in `.dart` files | **Nota**: Estos keymaps están activos solo en archivos `.dart`

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>Fs` | Flutter run | `:action Flutter.Run` | **EN**: Start Flutter app / **ES**: Iniciar app Flutter |
| `<leader>Fr` | Flutter reload | `:action Flutter.HotReload` | **EN**: Hot reload / **ES**: Recarga caliente |
| `<leader>FR` | Flutter restart | `:action Flutter.HotRestart` | **EN**: Hot restart / **ES**: Reinicio caliente |
| `<leader>Fd` | Flutter DevTools | `:action Flutter.OpenDevTools` | **EN**: Open DevTools / **ES**: Abrir DevTools |
| `<leader>Fo` | Flutter outline | `:action Flutter.Outline` | **EN**: Toggle outline / **ES**: Alternar esquema |
| `<leader>Fe` | Flutter emulators | `:action Flutter.Emulator` | **EN**: Start emulator / **ES**: Iniciar emulador |
| `<leader>FD` | Flutter devices | `:action Flutter.SelectDevice` | **EN**: Select device / **ES**: Seleccionar dispositivo |

### 🧪 Testing | Pruebas

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>T` | Test nearest | `:action RunClass` | **EN**: Run nearest test / **ES**: Ejecutar prueba cercana |
| `<leader>Tf` | Test file | `:action RunClass` | **EN**: Run current file tests / **ES**: Ejecutar pruebas del archivo |
| `<leader>Ta` | Test suite | `:action RunAllTestsInDirectory` | **EN**: Run all tests / **ES**: Ejecutar todas las pruebas |
| `<leader>Tl` | Test last | `:action Rerun` | **EN**: Rerun last test / **ES**: Reejecutar última prueba |

### 🚀 Code Runner | Ejecutor de Código

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>r` | Run code | `:action RunClass` | **EN**: Run current code / **ES**: Ejecutar código actual |
| `<leader>rf` | Run file | `:action RunClass` | **EN**: Run current file / **ES**: Ejecutar archivo actual |
| `<leader>rp` | Run project | `:action Run` | **EN**: Run project / **ES**: Ejecutar proyecto |
| `<leader>rc` | Close runner | `:action Stop` | **EN**: Stop execution / **ES**: Detener ejecución |

### 📦 Buffer & Window Management | Gestión de Buffers y Ventanas

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| **Buffer Navigation** | | | |
| `<S-l>` | Next buffer | `:action NextTab` | **EN**: Next buffer/tab / **ES**: Siguiente buffer/tab |
| `<S-h>` | Previous buffer | `:action PreviousTab` | **EN**: Previous buffer/tab / **ES**: Anterior buffer/tab |
| `<leader>bn` | Next buffer | `:action NextTab` | **EN**: Next buffer (leader) / **ES**: Siguiente buffer (leader) |
| `<leader>bp` | Previous buffer | `:action PreviousTab` | **EN**: Previous buffer (leader) / **ES**: Buffer anterior (leader) |
| **Buffer Operations** | | | |
| `<leader>bd` | Close buffer | `:action CloseContent` | **EN**: Delete/close current buffer / **ES**: Eliminar/cerrar buffer actual |
| `<leader>bl` | Close buffers right | `:action CloseAllToTheRight` | **EN**: Close buffers to right / **ES**: Cerrar buffers a la derecha |
| `<leader>bh` | Close buffers left | `:action CloseAllToTheLeft` | **EN**: Close buffers to left / **ES**: Cerrar buffers a la izquierda |
| `<leader>bt` | Toggle pin buffer | `:action PinActiveTab` | **EN**: Toggle pin buffer / **ES**: Alternar pin buffer |
| **Split/Window Navigation** | | | |
| `<space>l` | Next split | `:action NextSplitter` | **EN**: Next split/window / **ES**: Siguiente split/ventana |
| `<space>h` | Previous split | `:action PrevSplitter` | **EN**: Previous split/window / **ES**: Split/ventana anterior |
| `<leader>wh/j/k/l` | Window navigation | `:action` window navigation | **EN**: Navigate between windows / **ES**: Navegar entre ventanas |
| `<leader>wm` | Move window | `:action MoveEditorToOppositeTabGroup` | **EN**: WinShift move window / **ES**: Mover ventana WinShift |
| `<leader>ws` | Swap window | `:action MoveTabToOppositeTabGroup` | **EN**: WinShift swap window / **ES**: Intercambiar ventana WinShift |

---

## 🔄 Buffer/Tab & Window Navigation | Navegación de Buffers/Tabs y Ventanas

> **Important/Importante**: What you see as "tabs" are actually **buffers** in Neovim | Lo que ves como "tabs" son en realidad **buffers** en Neovim

### English
- **Buffer Navigation**: Use `<Shift>+L` / `<Shift>+H` to move between buffers quickly
- **Split Navigation**: Use `<Space>+L` / `<Space>+H` to move between split windows
- **Window Management**: Use `<leader>w` prefix for advanced window operations
- **True Tabs**: Use `:tabnew` to create real tabs (rarely needed)
- **Visual Indicator**: The bar shows open buffers, not vim tabs
- **Quick Access**: Multiple ways to quickly find files:
  - `<leader>ff` for file finder
  - `<leader><leader>` for quick file search (double leader)
  - `<leader>.` for quick file search (leader + dot)
  - `,,` for quick file search (double comma)
  - `<leader>1-9` with Harpoon for instant file switching

### Español
- **Navegación de Buffers**: Usa `<Shift>+L` / `<Shift>+H` para moverte entre buffers rápidamente
- **Navegación de Splits**: Usa `<Space>+L` / `<Space>+H` para moverte entre ventanas divididas
- **Gestión de Ventanas**: Usa el prefijo `<leader>w` para operaciones avanzadas de ventanas
- **Tabs Reales**: Usa `:tabnew` para crear tabs reales (raramente necesario)
- **Indicador Visual**: La barra muestra buffers abiertos, no tabs de vim
- **Acceso Rápido**: Múltiples formas de encontrar archivos rápidamente:
  - `<leader>ff` para buscador de archivos
  - `<leader><leader>` para búsqueda rápida (doble leader)
  - `<leader>.` para búsqueda rápida (leader + punto)
  - `,,` para búsqueda rápida (doble coma)
  - `<leader>1-9` con Harpoon para cambio instantáneo

---

## 📦 Plugin Ecosystem | Ecosistema de Plugins

### 🔧 Core Development | Desarrollo Principal

#### **Language Server Protocol (LSP)**
- **nvim-lspconfig**: Native LSP configuration for 7 languages
- **cmp-nvim-lsp**: LSP autocompletion integration
- **none-ls.nvim**: Code formatting and linting
- **schemastore.nvim**: JSON schema validation

#### **Autocompletion & Snippets**
- **nvim-cmp**: Powerful completion engine
- **LuaSnip**: Modern snippet engine
- **friendly-snippets**: 1000+ pre-built snippets
- **awesome-flutter-snippets**: Flutter-specific snippets

### 🎨 User Interface | Interfaz de Usuario

#### **File Navigation**
- **telescope.nvim**: Fuzzy finder and picker
- **neo-tree.nvim**: File explorer sidebar
- **oil.nvim**: Directory editor
- **harpoon**: Quick file bookmarking

#### **Visual Enhancement**
- **lualine.nvim**: Statusline with Git/LSP info
- **bufferline.nvim**: Buffer tabs with indicators
- **dashboard-nvim**: Custom startup screen
- **nvim-notify**: Enhanced notifications
- **which-key.nvim**: Keymap helper

### 🚀 Productivity | Productividad

#### **Git Integration**
- **vim-fugitive**: Complete Git command suite
- **gitsigns.nvim**: Git hunks in gutter
- **diffview.nvim**: Advanced diff viewer
- **neogit**: Modern Git interface
- **git-conflict.nvim**: Conflict resolution helper

#### **Terminal & Tasks**
- **toggleterm.nvim**: Multiple terminal management
- **overseer.nvim**: Task runner
- **code_runner.nvim**: Quick code execution
- **vim-test**: Testing framework integration

### 🎯 Specialized Tools | Herramientas Especializadas

#### **Flutter/Dart Development**
- **flutter-tools.nvim**: Complete Flutter IDE features
- **dart-vim-plugin**: Dart syntax and formatting
- **nvim-dap**: Debugging support

#### **Code Intelligence**
- **nvim-treesitter**: Advanced syntax highlighting
- **trouble.nvim**: Diagnostics list
- **Comment.nvim**: Smart commenting
- **nvim-autopairs**: Auto-closing brackets

---

## 🎯 Plugin Use Cases | Casos de Uso por Plugin

### 🔍 **When to Use Each Tool | Cuándo Usar Cada Herramienta**

#### **File Navigation Scenarios**
- **Quick file search**: `<leader>ff` (Telescope) - When you know the filename
- **Content search**: `<leader>fg` (Telescope) - When searching for specific text
- **Project browsing**: `<leader>pv` (Neo-tree) - When exploring project structure
- **Directory editing**: `-` (Oil) - When bulk renaming/organizing files
- **Frequent files**: `<leader>1-9` (Harpoon) - For your most-used files

#### **Git Workflow Examples**
1. **Daily Development**: `<leader>gs` → `<leader>hs` → `<leader>gc`
2. **Code Review**: `<leader>gdo` → `]c`/`[c` → `<leader>gdc`
3. **Conflict Resolution**: Auto-detected → `<leader>co`/`<leader>ct`
4. **History Investigation**: `<leader>gB` (blame) → `<leader>gdh` (file history)

#### **Flutter Development Workflow**
1. **Start Development**: `<leader>Fe` → `<leader>FD` → `<leader>Fs`
2. **Active Development**: `<leader>Fr` (hot reload) → `<leader>FR` (if needed)
3. **Debugging**: `<leader>Fd` (DevTools) → `<leader>Fo` (outline)
4. **Testing**: `<leader>T` → `<leader>Tf` → `<leader>Ta`

#### **LSP Features by Language**
- **Dart/Flutter**: Complete IDE experience with hot reload
- **Swift**: Go-to definition, autocompletion, error checking
- **C/C++**: Clangd integration with compilation database support
- **Kotlin**: Android development with Gradle project support
- **Lua**: Neovim configuration editing with vim globals

### 💡 **Pro Tips | Consejos Profesionales**

#### **Efficiency Boosters**
- **Quick File Access**: Multiple options for different workflows:
  - `<leader>ff` for general file search
  - `,,` for quick file access (like IntelliJ double-shift)
  - `<leader><leader>` for quick search with leader
  - `<leader>.` for one-handed quick search
- **Navigation Speed**:
  - `<S-h>`/`<S-l>` for buffer navigation
  - `<space>h`/`<space>l` for split navigation
  - `<leader>w` prefix for window management
- **Harpoon Workflow**: Mark 4-5 key files with `<leader>ma`, access with `<leader>1-5`
- **Git Integration**:
  - `]c`/`[c` to review changes before committing
  - `<leader>hs`/`<leader>hr` for staging/resetting hunks
- **Terminal & Diagnostics**:
  - `<leader>tg` for LazyGit, `<leader>tF` for Flutter commands
  - `<leader>xx` for trouble diagnostics, `<leader>xn`/`<leader>xp` for navigation
- **LSP Power**: `<leader>ca` works in any LSP-supported file, `<leader>lf` for formatting

#### **Cross-Editor Consistency**
- **Identical Keymaps**: All commands work the same in both Neovim and IntelliJ
- **Muscle Memory**: Switch between editors without mental overhead
- **Project Synchronization**: Open same project in both tools seamlessly

---

## 🔧 IntelliJ IDEA Synchronization | Sincronización con IntelliJ

### 📋 Complete .ideavimrc Integration

The included `.ideavimrc` provides **300+ synchronized commands** between Neovim and IntelliJ IDEA:

### English Setup
1. **Copy the configuration**: `cp ~/.config/nvim/.ideavimrc ~/`
2. **Restart IntelliJ IDEA**
3. **Enable IdeaVim plugin** in Settings → Plugins
4. **All keymaps work identically** between both editors

### Español Configuración
1. **Copiar la configuración**: `cp ~/.config/nvim/.ideavimrc ~/`
2. **Reiniciar IntelliJ IDEA**
3. **Habilitar plugin IdeaVim** en Settings → Plugins
4. **Todos los keymaps funcionan idénticamente** entre ambos editores

### 🎯 **Synchronized Features | Características Sincronizadas**

#### **Navigation | Navegación**
- File search, text search, recent files
- Go to definition, implementation, references
- Buffer/tab navigation with identical keys

#### **Git Operations | Operaciones Git**
- Status, commit, diff, blame, conflict resolution
- Hunk navigation and staging
- Repository browsing and history

#### **Development Tools | Herramientas de Desarrollo**
- LSP features: rename, code actions, formatting
- Terminal integration and task running
- Testing and debugging commands

#### **macOS Optimizations | Optimizaciones macOS**
- `Cmd+1`, `Cmd+Shift+O` for native macOS feel
- Proper key mapping for MacBook Pro keyboard
- Terminal font configuration for Nerd Font support

---

## 🚀 Advanced Features | Características Avanzadas

### 🧠 **Smart Autocompletion**
- **Context-aware**: Suggests based on current file type and project
- **Multi-source**: LSP + snippets + buffer words
- **Flutter-optimized**: Widget suggestions and import auto-completion

### 🔄 **Session Management**
- **Auto-save**: Projects and window layouts preserved
- **Cross-session**: Resume exactly where you left off
- **Project-aware**: Different configurations per project type

### 🎨 **Visual Intelligence**
- **Syntax highlighting**: 20+ languages with Treesitter
- **Git integration**: Real-time change indicators
- **Error visualization**: Inline diagnostics with severity levels
- **Icon system**: 500+ file type icons with Nerd Font support

### ⚡ **Performance Optimizations**
- **Lazy loading**: Plugins load only when needed
- **Async operations**: Non-blocking LSP and formatting
- **Memory efficient**: Smart caching and cleanup
- **Fast startup**: ~50ms cold start time

---

## 📊 **Configuration Stats | Estadísticas de Configuración**

### 📈 **By the Numbers | Por los Números**
- **70+ Plugins**: Carefully curated and optimized
- **300+ Keymaps**: Fully synchronized between Neovim and IntelliJ
- **7 LSP Servers**: Auto-configured for main development languages
- **1000+ Snippets**: Ready-to-use code templates
- **20+ Themes**: Including Dracula (default), Gruvbox, Catppuccin
- **Multi-platform**: Optimized for macOS, compatible with Linux
- **4 Ways**: Quick file access (ff, <leader><leader>, <leader>., ,,)
- **Smart Navigation**: Buffer navigation + Split navigation + Window management

### 🎯 **Language Support | Soporte de Lenguajes**
- **Primary**: Flutter/Dart, Swift, Kotlin, C/C++
- **Secondary**: JavaScript, TypeScript, Python, Rust, Go
- **Configuration**: Lua, JSON, YAML, TOML, Markdown

### 🏆 **Use Case Coverage | Cobertura de Casos de Uso**
- ✅ **Mobile Development**: Flutter, Swift, Kotlin
- ✅ **System Programming**: C/C++, Rust, Go
- ✅ **Web Development**: JavaScript, TypeScript
- ✅ **DevOps**: YAML, TOML, Shell scripting
- ✅ **Documentation**: Markdown, README files

---

## 🛠️ **Troubleshooting | Solución de Problemas**

### 🔧 **Common Issues | Problemas Comunes**

#### **LSP Not Working | LSP No Funciona**
```bash
# Check if language server is installed
:LspInfo

# For Dart/Flutter
flutter doctor

# For C/C++
which clangd

# For Swift
which sourcekit-lsp
```

#### **Icons Not Showing | Iconos No Se Muestran**
```bash
# Install Nerd Font for your terminal
brew install --cask font-fira-code-nerd-font

# Set terminal font to "FiraCode Nerd Font"
# Restart terminal application
```

#### **IntelliJ Sync Issues | Problemas de Sincronización IntelliJ**
```bash
# Ensure .ideavimrc is in home directory
ls -la ~/.ideavimrc

# Restart IntelliJ IDEA
# Enable IdeaVim plugin in Settings → Plugins
```

### 🆘 **Getting Help | Obtener Ayuda**

#### **Neovim Commands | Comandos Neovim**
- `:checkhealth` - Check configuration status
- `:Lazy` - Plugin manager interface
- `:LspInfo` - LSP server status
- `:Telescope keymaps` - Find any keymap

#### **Documentation Access | Acceso a Documentación**
- `<leader>fh` - Search Neovim help
- `K` - Documentation for symbol under cursor
- `:WhichKey` - Show available keymaps for current mode

---

## 🎉 **Conclusion | Conclusión**

### English
This configuration transforms Neovim into a full-featured IDE while maintaining the speed and efficiency that makes Vim special. The synchronized IntelliJ IDEA integration means you can switch between editors seamlessly, using the same muscle memory and workflows. Perfect for developers who want the best of both worlds: Vim's power and IntelliJ's convenience.

### Español
Esta configuración transforma Neovim en un IDE completo manteniendo la velocidad y eficiencia que hace especial a Vim. La integración sincronizada con IntelliJ IDEA significa que puedes cambiar entre editores sin problemas, usando la misma memoria muscular y flujos de trabajo. Perfecto para desarrolladores que quieren lo mejor de ambos mundos: el poder de Vim y la conveniencia de IntelliJ.

---

**🔗 Repository**: [Neovim-Vim_Configuration](https://github.com/chochy2001/Neovim-Vim_Configuration)
**🍎 Optimized for**: macOS (MacBook Pro)
**⚡ Startup Time**: ~50ms
**🧠 Maintained by**: [Jorge Salgado Miranda](https://github.com/chochy2001)

---

*Happy coding! | ¡Feliz programación! 🚀*