# 🧠 Neovim + IntelliJ Ultra Configuration | Configuración Ultra Completa

> **EN**: Modern Neovim configuration with Lazy.nvim, native LSP, and 69+ optimized plugins for multi-language development (Flutter/Dart, Swift, Kotlin, C/C++, etc.) + synchronized IntelliJ keymaps. **🍎 Optimized for macOS (MacBook Pro)**.
>
> **ES**: Configuración moderna de Neovim con Lazy.nvim, LSP nativo, y más de 69 plugins optimizados para desarrollo en múltiples lenguajes + keymaps sincronizados con IntelliJ. **🍎 Optimizado para macOS (MacBook Pro)**.

---

## 📚 Table of Contents | Índice

- [🚀 Quick Install | Instalación Rápida](#-quick-install--instalación-rápida)
- [🔄 Buffer/Tab Navigation | Navegación de Buffers/Tabs](#-buffertab-navigation--navegación-de-bufferstabs)
- [⌨️ Plugin Commands | Comandos por Plugin](#️-plugin-commands--comandos-por-plugin)
- [🎯 Synchronized Keymaps | Keymaps Sincronizados](#-synchronized-keymaps--keymaps-sincronizados)
- [📦 Installed Plugins | Plugins Instalados](#-installed-plugins--plugins-instalados)

---

## 🚀 Quick Install | Instalación Rápida

### English
```bash
# Clone configuration
git clone https://github.com/chochy2001/Neovim-Vim_Configuration.git ~/.config/nvim

# Auto-setup with Lazy.nvim
nvim

# For IntelliJ IDEA sync (optional)
cp ~/.config/nvim/.ideavimrc ~/
```

### Español
```bash
# Clonar configuración
git clone https://github.com/chochy2001/Neovim-Vim_Configuration.git ~/.config/nvim

# Configuración automática con Lazy.nvim
nvim

# Para sincronización con IntelliJ IDEA (opcional)
cp ~/.config/nvim/.ideavimrc ~/
```

---

## 🔄 Buffer/Tab Navigation | Navegación de Buffers/Tabs

> **Important/Importante**: What you see as "tabs" are actually **buffers** in Neovim | Lo que ves como "tabs" son en realidad **buffers** en Neovim

### 🎯 Synchronized Navigation | Navegación Sincronizada

| Action/Acción | Neovim (bufferline) | IntelliJ (IdeaVim) | Description/Descripción |
|---------------|---------------------|---------------------|-------------------------|
| Next Buffer/Siguiente | `Shift+L` | `Shift+L` | **EN**: Go to next buffer/tab<br>**ES**: Ir al siguiente buffer/tab |
| Previous Buffer/Anterior | `Shift+H` | `Shift+H` | **EN**: Go to previous buffer/tab<br>**ES**: Ir al buffer/tab anterior |

### 📋 Complete Buffer Commands | Comandos Completos de Buffer

#### Neovim (BufferLine)
| Keymap | Command | EN Description | ES Descripción |
|--------|---------|----------------|----------------|
| `<leader>bp` | `:BufferLinePick` | Pick specific buffer | Seleccionar buffer específico |
| `<leader>bd` | `:BufferLinePickClose` | Pick buffer to close | Seleccionar buffer para cerrar |
| `<leader>bl` | `:BufferLineCloseRight` | Close buffers to right | Cerrar buffers a la derecha |
| `<leader>bh` | `:BufferLineCloseLeft` | Close buffers to left | Cerrar buffers a la izquierda |
| `<leader>bt` | `:BufferLineTogglePin` | Pin/unpin buffer | Fijar/desfijar buffer |

#### IntelliJ IDEA (IdeaVim)
| Keymap | Command | EN Description | ES Descripción |
|--------|---------|----------------|----------------|
| `<leader>tc` | `:action CloseContent` | Close current tab | Cerrar tab actual |
| `<leader>to` | `:action CloseAllEditorsButActive` | Close other tabs | Cerrar otras tabs |
| `<leader>tn` | `:action NewScratchFile` | New scratch file | Nuevo archivo temporal |

### 🔧 Native Vim Commands | Comandos Vim Nativos
| Command | EN Description | ES Descripción |
|---------|----------------|----------------|
| `:bn` / `:bnext` | Next buffer | Siguiente buffer |
| `:bp` / `:bprev` | Previous buffer | Buffer anterior |
| `:b {name}` | Go to buffer by name | Ir a buffer por nombre |
| `:bd` | Close current buffer | Cerrar buffer actual |
| `:ls` | List all buffers | Listar todos los buffers |

---

## ⌨️ Plugin Commands | Comandos por Plugin

> **Leader key = Space | Tecla líder = Espacio**

### 🔍 Telescope - Fuzzy Finder | Buscador Difuso

#### Neovim
| Keymap | Command | EN Description | ES Descripción |
|--------|---------|----------------|----------------|
| `,,` | `:Telescope find_files` | **Quick file finder (macOS)** | **Buscador rápido (macOS)** |
| `<leader>pf` | `:Telescope find_files` | Find files | Buscar archivos |
| `<leader>pg` | `:Telescope live_grep` | Search text in files | Buscar texto en archivos |
| `<leader><leader>` | `:Telescope oldfiles` | Recent files | Archivos recientes |

#### IntelliJ IDEA (Equivalent/Equivalente)
| Keymap | Action | EN Description | ES Descripción |
|--------|--------|----------------|----------------|
| `,,` | `:action GotoFile` | **Quick file finder (macOS)** | **Buscador rápido (macOS)** |
| `Shift+Shift` | Native Search Everywhere | IntelliJ native shortcut | Atajo nativo IntelliJ |
| `<leader>pf` | `:action GotoFile` | Find files | Buscar archivos |
| `<leader>pg` | `:action FindInPath` | Search text in project | Buscar texto en proyecto |
| `<leader>rf` | `:action RecentFiles` | Recent files | Archivos recientes |

---

### 📁 File Explorer | Explorador de Archivos

#### Neovim (Neo-tree + Oil)
| Keymap | Command | EN Description | ES Descripción |
|--------|---------|----------------|----------------|
| `<leader>pv` | `:Neotree filesystem toggle` | Toggle Neo-tree | Alternar Neo-tree |
| `<leader>bf` | `:Neotree buffers reveal float` | Show buffers | Mostrar buffers |
| `-` | Oil.nvim | Direct directory navigation | Navegación directa de directorios |

#### IntelliJ IDEA (Project View/Vista Proyecto)
| Keymap | Action | EN Description | ES Descripción |
|--------|--------|----------------|----------------|
| `<leader>pv` | `:action ActivateProjectToolWindow` | Open/Focus project view | Abrir/Enfocar vista proyecto |
| `<leader>e` | `:action ActivateProjectToolWindow` | Alias for project view | Alias para vista proyecto |
| `<leader>fe` | `:action SelectInProjectView` | Highlight current file in project | Resaltar archivo actual en proyecto |

---

### 🗂️ Harpoon - Quick Navigation | Navegación Rápida

#### Neovim
| Keymap | EN Description | ES Descripción |
|--------|----------------|----------------|
| `<leader>a` | Add file to Harpoon | Agregar archivo a Harpoon |
| `<leader>h` | Toggle Harpoon UI | Alternar UI de Harpoon |
| `<leader>1-9` | Go to marked file (1-9) | Ir a archivo marcado (1-9) |
| `<C-S-P>/<C-S-N>` | Previous/Next file | Archivo anterior/siguiente |

#### IntelliJ IDEA (Bookmarks/Marcadores)
| Keymap | Action | EN Description | ES Descripción |
|--------|--------|----------------|----------------|
| `<leader>1-9` | Go to mark 1-9 | Ir a marca 1-9 | Ir a marca 1-9 |
| `m1-m9` | Set mark 1-9 | Establecer marca 1-9 | Establecer marca 1-9 |

---

### 🎯 Git Integration | Integración Git

#### Neovim (Fugitive + GitSigns + Neogit)
| Keymap | Command | EN Description | ES Descripción |
|--------|---------|----------------|----------------|
| `<leader>gs` | `:Git` | Git status | Estado de Git |
| `<leader>gw` | `:Gwrite` | Git add current file | Git add archivo actual |
| `<leader>gc` | `:Git commit` | Git commit | Git commit |
| `<leader>gd` | `:Gdiffsplit` | Git diff split | Git diff dividido |
| `<leader>gB` | `:Git blame` | Git blame | Git blame |
| `<leader>gg` | `:Neogit` | Full Git interface | Interfaz Git completa |

#### GitSigns (Hunks)
| Keymap | EN Description | ES Descripción |
|--------|----------------|----------------|
| `]c` / `[c` | Next/previous hunk | Siguiente/anterior hunk |
| `<leader>hs` | Stage hunk | Preparar hunk |
| `<leader>hr` | Reset hunk | Resetear hunk |
| `<leader>hp` | Preview hunk | Vista previa hunk |

#### IntelliJ IDEA (VCS Integration/Integración VCS)
| Keymap | Action | EN Description | ES Descripción |
|--------|--------|----------------|----------------|
| `<leader>gs` | `:action ActivateVersionControlToolWindow` | Open Git/VCS window | Abrir ventana Git/VCS |
| `<leader>gc` | `:action CheckinProject` | Commit | Commit |
| `<leader>gps` | `:action Vcs.Push` | Push | Push |
| `<leader>gpl` | `:action Vcs.UpdateProject` | Pull/Update | Pull/Actualizar |
| `<leader>gd` | `:action Diff.ShowDiff` | Show diff | Mostrar diferencias |
| `<leader>gb` | `:action Vcs.Branches` | Branches popup | Popup de ramas |

---

### 🔧 LSP - Language Server Protocol

#### Neovim (Native LSP/LSP Nativo)
| Keymap | EN Description | ES Descripción |
|--------|----------------|----------------|
| `gd` | Go to definition | Ir a definición |
| `gD` | Go to declaration | Ir a declaración |
| `gi` | Go to implementation | Ir a implementación |
| `gr` | References | Referencias |
| `K` | Hover documentation | Documentación flotante |
| `<C-k>` | Signature help | Ayuda de firma |
| `<leader>rn` | Rename symbol | Renombrar símbolo |
| `<leader>ca` | Code action | Acción de código |
| `<leader>f` | Format document | Formatear documento |

#### IntelliJ IDEA (Smart Code Actions/Acciones Inteligentes)
| Keymap | Action | EN Description | ES Descripción |
|--------|--------|----------------|----------------|
| `gd` | `:action GotoDeclaration` | Go to declaration | Ir a declaración |
| `gi` | `:action GotoImplementation` | Go to implementation | Ir a implementación |
| `gr` | `:action FindUsages` | Find references | Encontrar referencias |
| `K` | `:action QuickJavaDoc` | Show documentation | Mostrar documentación |
| `<leader>rn` | `:action RenameElement` | Rename element | Renombrar elemento |
| `<leader>ca` | `:action ShowIntentionActions` | Show code actions | Mostrar acciones de código |

---

### 🦋 Flutter/Dart Development | Desarrollo Flutter/Dart

#### Neovim (flutter-tools.nvim)
| Keymap | Command | EN Description | ES Descripción |
|--------|---------|----------------|----------------|
| `<leader>Fs` | `:FlutterRun` | Start Flutter app | Iniciar app Flutter |
| `<leader>Fr` | `:FlutterReload` | Hot reload | Recarga en caliente |
| `<leader>FR` | `:FlutterRestart` | Hot restart | Reinicio en caliente |
| `<leader>Fq` | `:FlutterQuit` | Stop app | Detener app |
| `<leader>Fd` | `:FlutterDevTools` | Open DevTools | Abrir DevTools |
| `<leader>FD` | `:FlutterDevices` | Select device | Seleccionar dispositivo |
| `<leader>Fe` | `:FlutterEmulators` | Start emulator | Iniciar emulador |

#### IntelliJ IDEA (Flutter Plugin)
| Action | EN Description | ES Descripción |
|--------|----------------|----------------|
| Run/Debug buttons | Start/Debug app | Iniciar/Depurar app |
| Hot Reload (⚡) | Hot reload | Recarga en caliente |
| Hot Restart (🔄) | Hot restart | Reinicio en caliente |
| Flutter DevTools | Open DevTools | Abrir DevTools |
| Device selector | Select device | Seleccionar dispositivo |

---

### 🧪 Testing | Pruebas

#### Neovim (vim-test)
| Keymap | Command | EN Description | ES Descripción |
|--------|---------|----------------|----------------|
| `<leader>T` | `:TestNearest` | Run nearest test | Ejecutar test más cercano |
| `<leader>Tf` | `:TestFile` | Run file tests | Ejecutar tests del archivo |
| `<leader>Ta` | `:TestSuite` | Run all tests | Ejecutar todos los tests |

#### IntelliJ IDEA (Built-in Testing/Testing Integrado)
| Keymap | Action | EN Description | ES Descripción |
|--------|--------|----------------|----------------|
| `<leader>rr` | `:action Run` | Run | Ejecutar |
| `<leader>rd` | `:action Debug` | Debug | Depurar |
| Gutter icons | Run specific test | Ejecutar test específico |

---

### 🎨 Formatting & Linting | Formateo y Linting

#### Neovim (none-ls + LSP)
| Keymap | EN Description | ES Descripción |
|--------|----------------|----------------|
| `<leader>f` | Format with LSP | Formatear con LSP |
| `<leader>ff` | Format with none-ls | Formatear con none-ls |

#### IntelliJ IDEA
| Keymap | Action | EN Description | ES Descripción |
|--------|--------|----------------|----------------|
| `<leader>ff` | `:action ReformatCode` | Format code | Formatear código |

---

## 🎯 Synchronized Keymaps | Keymaps Sincronizados

### 🔄 Consistent Navigation | Navegación Consistente

| Action/Acción | Neovim | IntelliJ | EN Description | ES Descripción |
|---------------|--------|----------|----------------|----------------|
| Next Buffer/Tab | `Shift+L` | `Shift+L` | Same muscle memory | Misma memoria muscular |
| Previous Buffer/Tab | `Shift+H` | `Shift+H` | Consistent navigation | Navegación consistente |
| **Quick File Search** | `,,` | `,,` | **Fast file finder** | **Buscador rápido** |
| File Search | `<leader>pf` | `<leader>pf` | Find files everywhere | Buscar archivos en todas partes |
| Text Search | `<leader>pg` | `<leader>pg` | Search text in project | Buscar texto en proyecto |
| Project Explorer | `<leader>pv` | `<leader>pv` | Toggle file explorer | Alternar explorador |

### 🎪 Universal Commands | Comandos Universales

| Category/Categoría | Neovim Command | IntelliJ Action | Purpose/Propósito |
|-------------------|----------------|-----------------|-------------------|
| **Git** | `<leader>gs` | `<leader>gs` | Git status/Estado |
| **Format** | `<leader>ff` | `<leader>ff` | Code formatting/Formateo |
| **Rename** | `<leader>rn` | `<leader>rn` | Symbol rename/Renombrar |
| **Documentation** | `K` | `K` | Show docs/Mostrar docs |
| **Go to Definition** | `gd` | `gd` | Navigate to definition/Ir a definición |

---

## 📦 Installed Plugins | Plugins Instalados

### 🔧 Core & LSP | Núcleo y LSP
- **lazy.nvim** - Modern plugin manager | Gestor de plugins moderno
- **nvim-lspconfig** - Native LSP configuration | Configuración LSP nativa
- **nvim-cmp** - Smart autocompletion | Autocompletado inteligente
- **LuaSnip** - Advanced snippets | Snippets avanzados
- **none-ls** - Formatting and linting | Formateo y linting

### 🎯 Navigation & UI | Navegación e Interfaz
- **telescope.nvim** - Ultra-fast fuzzy finder | Buscador difuso ultra rápido
- **neo-tree.nvim** - Modern file explorer | Explorador de archivos moderno
- **oil.nvim** - Direct directory navigation | Navegación directa de directorios
- **harpoon** - Quick file navigation | Navegación rápida de archivos
- **which-key.nvim** - Keymap guide | Guía de atajos
- **bufferline.nvim** - Buffer tabs | Pestañas de buffer

### 🎨 Appearance | Apariencia
- **catppuccin** - Main theme | Tema principal
- **dracula**, **gruvbox**, **rose-pine** - Additional themes | Temas adicionales
- **lualine.nvim** - Elegant status line | Línea de estado elegante
- **nvim-web-devicons** - File icons | Iconos de archivos
- **indent-blankline.nvim** - Indentation guides | Guías de indentación
- **rainbow-delimiters.nvim** - Colored delimiters | Delimitadores coloreados

### 🔀 Git Integration | Integración Git
- **vim-fugitive** - Complete Git integration | Integración Git completa
- **gitsigns.nvim** - Git signs in editor | Signos Git en editor
- **neogit** - Magit-like Git interface | Interfaz Git tipo Magit
- **diffview.nvim** - Diff visualization | Visualización de diferencias
- **git-conflict.nvim** - Conflict resolution | Resolución de conflictos

### 🛠️ Development | Desarrollo
- **nvim-treesitter** - Advanced syntax highlighting | Resaltado de sintaxis avanzado
- **nvim-autopairs** - Auto-close brackets | Auto-cierre de paréntesis
- **Comment.nvim** - Smart comments | Comentarios inteligentes
- **vim-surround** - Delimiter manipulation | Manipulación de delimitadores
- **flutter-tools.nvim** - Integrated Flutter | Flutter integrado
- **copilot.vim** - GitHub Copilot AI | IA GitHub Copilot

### 🔧 Terminal & Testing | Terminal y Pruebas
- **toggleterm.nvim** - Integrated terminal | Terminal integrada
- **vim-test** - Testing framework | Framework de pruebas
- **vimux** - Tmux integration | Integración con tmux

### 📝 Utilities | Utilidades
- **trouble.nvim** - Problem list | Lista de problemas
- **undotree** - Change history | Historial de cambios
- **dashboard-nvim** - Start screen | Pantalla de inicio
- **persistence.nvim** - Session persistence | Persistencia de sesiones

---

## 🌈 Available Themes | Temas Disponibles

```vim
:colorscheme catppuccin    " Default/Por defecto
:colorscheme dracula
:colorscheme gruvbox
:colorscheme rose-pine
:colorscheme onedark
:colorscheme molokai
:colorscheme solarized
```

---

## 🔧 Management Commands | Comandos de Gestión

### Lazy.nvim
```vim
:Lazy                    " Main interface/Interfaz principal
:Lazy sync              " Sync plugins/Sincronizar plugins
:Lazy clean             " Clean unused/Limpiar no usados
:Lazy update            " Update plugins/Actualizar plugins
:Lazy profile           " Load profile/Perfil de carga
```

### LSP
```vim
:LspInfo               " Active LSP info/Info de LSP activos
:LspRestart           " Restart LSP/Reiniciar LSP
:checkhealth          " General diagnostics/Diagnóstico general
```

### Git
```vim
:Git                  " Interactive status/Estado interactivo
:Neogit              " Complete Git interface/Interfaz Git completa
:DiffviewOpen        " Diff view/Vista de diferencias
:Gitsigns preview_hunk " Preview changes/Vista previa de cambios
```

---

## 🎯 Supported Languages | Lenguajes Soportados

- **Flutter/Dart** - dartls + flutter-tools
- **Swift** - sourcekit-lsp
- **C/C++** - clangd
- **Kotlin** - kotlin-language-server
- **Lua** - lua_ls (for Neovim config/para configuración Neovim)
- **JSON/YAML** - Integrated schemas/Esquemas integrados
- **JavaScript/TypeScript** - Full support/Soporte completo
- **Python, Go, Rust** - LSP available/LSP disponible

---

## 📋 Dashboard Shortcuts | Atajos del Dashboard

**EN**: When opening Neovim without files | **ES**: Al abrir Neovim sin archivos:

| Key/Tecla | Action/Acción | EN | ES |
|-----------|---------------|----|----|
| `1` | New file | Nuevo archivo | Nuevo archivo |
| `2` | Search text | Buscar texto | Buscar texto |
| `3` | Recent files | Archivos recientes | Archivos recientes |
| `4` | File explorer | Explorador archivos | Explorador archivos |
| `5` | Terminal | Terminal | Terminal |
| `6` | Edit config | Editar configuración | Editar configuración |
| `7` | Sync plugins | Sincronizar plugins | Sincronizar plugins |
| `8` | Mason (LSP) | Instalador LSP | Instalador LSP |

---

## 🚀 Special Features | Características Especiales

### English
- ✅ **Intelligent Error Suppression** - Hides E5248 errors without breaking functionality
- ✅ **Lazy Loading** - Only loads plugins when needed
- ✅ **Native LSP** - No Mason, uses system LSPs
- ✅ **Integrated Flutter Development** - Hot reload and full workflow
- ✅ **Complete Git Workflow** - From staging to push
- ✅ **Ultra-Fast Navigation** - Harpoon + Telescope
- ✅ **AI Autocompletion** - GitHub Copilot integrated
- ✅ **Cross-Editor Consistency** - Synchronized Neovim ↔ IntelliJ keymaps

### Español
- ✅ **Supresión Inteligente de Errores** - Oculta errores E5248 sin romper funcionalidad
- ✅ **Carga Perezosa** - Solo carga plugins cuando se necesitan
- ✅ **LSP Nativo** - Sin Mason, usa LSPs del sistema
- ✅ **Desarrollo Flutter Integrado** - Hot reload y flujo completo
- ✅ **Flujo Git Completo** - Desde staging hasta push
- ✅ **Navegación Ultra Rápida** - Harpoon + Telescope
- ✅ **Autocompletado IA** - GitHub Copilot integrado
- ✅ **Consistencia Entre Editores** - Keymaps sincronizados Neovim ↔ IntelliJ

---

## 🍎 macOS Specific Features | Características Específicas macOS

### English
- **Optimized for MacBook Pro** - All keymaps tested on macOS keyboard layouts
- **Cmd key integration** - Uses `<D-1>` (Cmd+1) for project navigation like native IntelliJ
- **Double comma (`,,`)** - Universal file search that works perfectly on Mac keyboards
- **Terminal compatibility** - Tested with Warp terminal and native Terminal.app

### Español
- **Optimizado para MacBook Pro** - Todos los keymaps probados en layouts de teclado macOS
- **Integración tecla Cmd** - Usa `<D-1>` (Cmd+1) para navegación como IntelliJ nativo
- **Doble coma (`,,`)** - Búsqueda universal que funciona perfecto en teclados Mac
- **Compatibilidad terminal** - Probado con terminal Warp y Terminal.app nativo

---

## 💡 Pro Tips | Consejos Pro

### English
- Use `:which-key` or press `<leader>` and wait to see all available shortcuts
- **Shift+L/Shift+H** works the same in both Neovim and IntelliJ for consistent muscle memory
- **Double comma (`,,`)** is faster than Shift+Shift and works reliably on Mac keyboards
- The "tabs" you see are actually buffers - use buffer commands, not tab commands
- Enable IdeaVim plugin in IntelliJ and source the `.ideavimrc` for full synchronization

### Español
- Usa `:which-key` o presiona `<leader>` y espera para ver todos los atajos disponibles
- **Shift+L/Shift+H** funciona igual en Neovim e IntelliJ para memoria muscular consistente
- **Doble coma (`,,`)** es más rápido que Shift+Shift y funciona confiable en teclados Mac
- Las "tabs" que ves son en realidad buffers - usa comandos de buffer, no de tab
- Habilita el plugin IdeaVim en IntelliJ y carga el `.ideavimrc` para sincronización completa

---

**🚀 Happy Coding! | ¡Feliz Programación!**

*Configuration optimized for maximum productivity with cross-editor consistency.*
*Configuración optimizada para máxima productividad con consistencia entre editores.*