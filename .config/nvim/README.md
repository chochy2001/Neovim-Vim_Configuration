# 🧠 Neovim + IntelliJ Ultra Configuration | Configuración Ultra Completa

> **EN**: Professional Neovim configuration with lazy.nvim, native LSP (Neovim 0.12+), and 70+ curated plugins with **130+ leader keymaps (audited: zero hard conflicts)** grouped by logical prefixes for multi-language development (Flutter/Dart, Swift, Kotlin, C/C++, etc.) + complete Android Studio/IntelliJ IDEA synchronization. **✅ Cross-platform: Windows, macOS and Linux (validated September 2026)**.
>
> **ES**: Configuración profesional de Neovim con lazy.nvim, LSP nativo (Neovim 0.12+), y más de 70 plugins con **más de 130 keymaps con leader (auditados: cero conflictos)** agrupados por prefijos lógicos para desarrollo en múltiples lenguajes + sincronización completa con Android Studio/IntelliJ IDEA. **✅ Multiplataforma: Windows, macOS y Linux (validado en septiembre de 2026)**.

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

## ✨ **Latest Update: Neovim 0.12 Migration | Ultima Actualizacion: Migracion a Neovim 0.12**

### 🎯 **Neovim 0.12 Native API Migration (kept current through September 2026)**

**EN**: Full migration to Neovim 0.12 native APIs. Configuration updated for zero deprecation warnings and maximum compatibility:

- ✅ **Native LSP API** - Migrated from `require('lspconfig').setup()` to `vim.lsp.config()` / `vim.lsp.enable()`
- ✅ **New nvim-treesitter** - Parser-only plugin with `vim.treesitter.start()` FileType autocmd for highlighting
- ✅ **Telescope v0.2.2** - Updated from v0.1.8, fixes preview syntax highlighting
- ✅ **Trouble v3** - Migrated from deprecated `TroubleToggle` to `Trouble` commands
- ✅ **mason-lspconfig v2** - Uses `automatic_enable` with `vim.lsp.enable()` integration
- ✅ **Gitsigns** - Replaced deprecated `next_hunk`/`prev_hunk` with `nav_hunk()`
- ✅ **Zero deprecated API calls** - No `sign_define` warnings, no `supports_method` dot-call warnings
- ✅ **tree-sitter-cli** - Required dependency for parser compilation

**ES**: Migracion completa a APIs nativas de Neovim 0.12. Configuracion actualizada sin warnings de depreciacion:

- ✅ **API LSP nativa** - Migrado de `require('lspconfig').setup()` a `vim.lsp.config()` / `vim.lsp.enable()`
- ✅ **Nuevo nvim-treesitter** - Plugin solo para parsers con autocmd FileType y `vim.treesitter.start()`
- ✅ **Telescope v0.2.2** - Actualizado desde v0.1.8, corrige resaltado de sintaxis en previews
- ✅ **Trouble v3** - Migrado de `TroubleToggle` deprecado a comandos `Trouble`
- ✅ **mason-lspconfig v2** - Usa `automatic_enable` con integracion `vim.lsp.enable()`
- ✅ **Gitsigns** - Reemplazado `next_hunk`/`prev_hunk` deprecados por `nav_hunk()`
- ✅ **Cero llamadas deprecadas** - Sin warnings de `sign_define`, `supports_method`
- ✅ **tree-sitter-cli** - Dependencia requerida para compilacion de parsers

### Requirements | Requisitos

```bash
# Required for treesitter parser compilation
npm install -g tree-sitter-cli
```

---

## 🚀 Quick Install | Instalación Rápida

### English
```bash
# Prerequisites: Neovim 0.12+, Node.js 22+, Git, C compiler
npm install -g tree-sitter-cli

# Clone to a dedicated folder, then symlink ONLY .config/nvim
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git ~/Neovim-Vim_Configuration
mkdir -p ~/.config
ln -sfn ~/Neovim-Vim_Configuration/.config/nvim ~/.config/nvim
ln -sf ~/Neovim-Vim_Configuration/.ideavimrc ~/.ideavimrc

nvim   # plugins install on first launch; Mason installs LSPs/formatters
```

Windows (PowerShell, as Administrator if the junction needs elevation):

```powershell
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git $HOME\Neovim-Vim_Configuration
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\Neovim-Vim_Configuration\.config\nvim"
Copy-Item "$HOME\Neovim-Vim_Configuration\.ideavimrc" "$HOME\_ideavimrc"
```

### Español
```bash
# Requisitos: Neovim 0.12+, Node.js 22+, Git, compilador C
npm install -g tree-sitter-cli

git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git ~/Neovim-Vim_Configuration
mkdir -p ~/.config
ln -sfn ~/Neovim-Vim_Configuration/.config/nvim ~/.config/nvim
ln -sf ~/Neovim-Vim_Configuration/.ideavimrc ~/.ideavimrc

nvim
```

Windows (PowerShell):

```powershell
git clone git@github.com:chochy2001/Neovim-Vim_Configuration.git $HOME\Neovim-Vim_Configuration
New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\Neovim-Vim_Configuration\.config\nvim"
Copy-Item "$HOME\Neovim-Vim_Configuration\.ideavimrc" "$HOME\_ideavimrc"
```

### How to use | Cómo usarlo

**EN**: Leader is **Space**. Run `nvim` with no file for the CAPDESIS dashboard. Live shortcut list: `:Telescope keymaps`. Plugin UI: `:Lazy`. LSP installer: `:Mason`. Format: `<leader>fm`. Git: `<leader>gs` → `<leader>gsa` → `<leader>gc` → `<leader>gp`. AI: `<leader>aa` or visual `<leader>as`.

Dashboard (empty `nvim` only): `f` find · `g` grep · `r` recent · `e` explorer · `a` AI · `m` Mason · `l` Lazy · `q` quit.

**ES**: Leader = **Espacio**. `nvim` sin archivo abre el dashboard. Lista viva: `:Telescope keymaps`. Formatear: `<leader>fm`. Git y AI igual que arriba. Guía completa: [WORKFLOW.md](../../WORKFLOW.md) (repo root).

---

## ⌨️ Complete Keymap Guide | Guía Completa de Keymaps

> **Leader Key**: `<Space>` | **Modo Normal** salvo que se indique lo contrario

### 🔍 Find & Search | Búsqueda

> Shared Telescope prefixes with `.ideavimrc`. Live list: `:Telescope keymaps`.

| Keymap | Neovim Plugin | Neovim Action | IntelliJ Action | Status | Description |
|--------|---------------|---------------|-----------------|---------|-------------|
| `<leader>ff` | **telescope.lua** | `builtin.find_files` | `:action GotoFile` | ✅ **PERFECT** | **Main command** - Find files by name |
| `<leader>fg` | **telescope.lua** | `builtin.live_grep` | `:action FindInPath` | ✅ **PERFECT** | Search text content in project |
| `<leader>fo` | **telescope.lua** | `builtin.oldfiles` | `:action RecentFiles` | ✅ **PERFECT** | Recent/old files access |
| `<leader>fb` | **telescope.lua** | `builtin.buffers` | `:action Switcher` | ✅ **PERFECT** | Find and switch between open buffers |
| `<leader>fh` | **telescope.lua** | `builtin.help_tags` | `:action HelpTopics` | ✅ **PERFECT** | Search help documentation |
| `<leader>fc` | **telescope.lua** | `builtin.commands` | `:action GotoAction` | ✅ **PERFECT** | Find and execute commands |
| `<leader>fk` | **telescope.lua** | `builtin.keymaps` | `:action GotoAction` | ✅ **PERFECT** | **v4.0** - Find keymaps/shortcuts |
| `<leader>fp` | **session-workspace.lua** | `:Telescope projects` | `:action ManageRecentProjects` | ✅ **PERFECT** | Find and switch projects |
| `<leader>fr` | **neo-tree.lua** | `:Neotree filesystem reveal` | `:action SelectInProjectView` | ✅ **PERFECT** | Reveal current file in tree |
| **Quick Access** | | | | | |
| `<leader>.` | **telescope.lua** | `builtin.find_files` | `:action GotoFile` | ✅ **PERFECT** | **One-handed** - Quick file search |
| `,,` | **telescope.lua** | `builtin.find_files` | `:action GotoFile` | ✅ **PERFECT** | **Double comma** - Ultra quick access |

**Telescope**: same `f*` prefixes in Neovim and IdeaVim.

### 📁 Git Operations | Operaciones Git

> **✅ v5.0 - Zero Uppercase** | **v5.0 - Cero Mayúsculas** - 28 commands, 0 uppercase, logical grouping

| Keymap | Neovim Action | IntelliJ Action | Description |
|--------|---------------|-----------------|-------------|
| **Core** | | | |
| `<leader>gs` | `:Git` (fugitive) | `:action ActivateVersionControlToolWindow` | Git status |
| `<leader>gc` | `:Git commit` | `:action CheckinProject` | Git commit |
| `<leader>gp` | `:Neogit push` | `:action Vcs.Push` | Git push (was gps ⚡25% faster) |
| `<leader>gl` | `:Neogit pull` | `:action Vcs.UpdateProject` | Git pull (was gpl ⚡25% faster) |
| `<leader>gf` | *Manual* | `:action Git.Fetch` | Git fetch |
| **Blame** | | | |
| `<leader>gb` | `:Git blame` | `:action Annotate` | Git blame toggle |
| `<leader>gbl` | `:Git blame` | `:action Annotate` | Git blame line |
| `<leader>gbt` | `gs.toggle_current_line_blame` | `:action Annotate` | Toggle line blame |
| `<leader>gbr` | `:GBrowse` | `:action Git.Branches` | Git branches |
| `<leader>gbc` | `:Git diff HEAD~1` | `:action Git.CompareWithBranch` | Compare with branch |
| **History** | | | |
| `<leader>gh` | `:Git log --oneline` | `:action Vcs.ShowTabbedFileHistory` | File history |
| `<leader>ghd` | `:Git log --graph --oneline --all` | `:action Git.Log.Show.Details` | Log details |
| **Diff** | | | |
| `<leader>gd` | `:Gdiffsplit` (fugitive) | `:action Compare.SameVersion` | Diff split |
| `<leader>gdo` | `:DiffviewOpen` | `:action Compare.LastVersion` | Open diffview |
| `<leader>gdq` | `:DiffviewClose` | `:action CloseContent` | Close diffview (was gdc) |
| `<leader>gdl` | `gs.diffthis` | `:action ActivateVersionControlToolWindow` | Local changes |
| `<leader>gdh` | `:DiffviewFileHistory` | `:action Vcs.ShowTabbedFileHistory` | Diff history |
| `<leader>gdf` | `:DiffviewToggleFiles` | `:action Compare.LastVersion` | Toggle files panel |
| **Stage (Hunks)** | | | |
| `<leader>gsa` | `gs.stage_hunk` | `:action Vcs.Add` | Stage hunk |
| `<leader>gsr` | `gs.reset_hunk` | `:action Vcs.RollbackChangedLines` | Reset hunk |
| `<leader>gsu` | `gs.stage_hunk` (toggle) | `:action Vcs.RollbackChangedLines` | Stage/unstage hunk |
| `<leader>gsp` | `gs.preview_hunk` | `:action VcsShowCurrentChangeMarker` | Preview hunk |
| `<leader>gsb` | `gs.reset_buffer` | `:action Vcs.Add` | Reset buffer |
| **Navigation** | | | |
| `<leader>gn` | `gs.nav_hunk("next")` | `:action VcsShowNextChangeMarker` | Next hunk |
| `<leader>gnp` | `gs.nav_hunk("prev")` | `:action VcsShowPrevChangeMarker` | Prev hunk |
| **Conflicts** | | | |
| `<leader>gco` | `<Plug>(git-conflict-ours)` | `:action ChooseOurs` | Choose ours (was co) |
| `<leader>gct` | `<Plug>(git-conflict-theirs)` | `:action ChooseTheirs` | Choose theirs (was ct) |
| `<leader>gcb` | `<Plug>(git-conflict-both)` | `:action ChooseBoth` | Choose both (was cb) |
| `<leader>gcn` | `<Plug>(git-conflict-none)` | `:action ChooseNone` | Choose none (was c0) |
| `<leader>gcp` | `<Plug>(git-conflict-prev-conflict)` | `:action VcsShowPrevChangeMarker` | Conflict prev |
| `<leader>gcnn` | `<Plug>(git-conflict-next-conflict)` | `:action VcsShowNextChangeMarker` | Conflict next |

**Git**: `g*` prefixes in Neovim and IdeaVim (see master table below).

**🚀 Key v5.0 Improvements**:
- ⚡ **25% faster**: `gpl`→`gl`, `gps`→`gp` (removed extra keypress)
- 🎯 **Logical grouping**: `gb*` blame, `gd*` diff, `gs*` staging, `gc*` conflicts
- 🚫 **0 uppercase**: All `h*`, `gB`, `gC`, `gP` converted to logical prefixes

### 🔧 LSP & Development | LSP y Desarrollo

> **✅ v5.0 - Streamlined** | **v5.0 - Simplificado** - 7 commands, duplicates eliminated

| Keymap | Neovim Action | IntelliJ Action | Description |
|--------|---------------|---------------|-----------------|-------------|
| **Core Navigation (native 0.11+ defaults + custom)** | | | |
| `gd` | native `vim.lsp.buf.definition` | `:action GotoDeclaration` | Go to definition |
| `gi` | native `vim.lsp.buf.implementation` | `:action GotoImplementation` | Go to implementation |
| `go` | custom `vim.lsp.buf.type_definition` | `:action GotoTypeDeclaration` | Go to type definition |
| `gR` | Trouble `lsp_references` | `:action FindUsages` | Find references |
| `K` | native `vim.lsp.buf.hover` | `:action QuickJavaDoc` | Hover documentation |
| **Code Actions & Formatting** | | | |
| `<leader>ca` | `vim.lsp.buf.code_action` | `:action ShowIntentionActions` | Code actions |
| `<leader>rn` | `vim.lsp.buf.rename` | `:action RenameElement` | Rename symbol |
| `<leader>fm` | `vim.lsp.buf.format` | `:action OptimizeImports` | Format document |

**LSP**: native `gd`/`gi`/`K` plus `<leader>rn`/`ca`/`fm`.

**🚀 Key v5.0 Improvements**:
- 🗑️ **Eliminated 10 duplicates**: Removed `<leader>gd`, `<leader>gi`, `<leader>gr`, `gD`, `gT`, `<leader>I`, `<leader>lh`, `<leader>ls` (all duplicated native commands)
- ⚡ **Cleaner**: Only essential, non-redundant LSP commands
- 🎯 **Focus**: Native vim commands (gd, gi, gr, K) + 3 leader actions (ca, rn, fm)

### 📌 Marks & Harpoon | Marcas y Harpoon

> Harpoon `m*` prefixes shared with IdeaVim bookmarks.

| Keymap | Neovim Plugin | Neovim Action | IntelliJ Action | Status | Description |
|--------|---------------|---------------|-----------------|---------|-------------|
| **Main Harpoon Commands** | | | | | |
| `<leader>ma` | **harpoon.lua** | `harpoon:list():add()` | `:action ToggleBookmark` | ✅ **PERFECT** | **Main command** - Add file to harpoon/bookmarks |
| `<leader>mh` | **harpoon.lua** | `harpoon.ui:toggle_quick_menu()` | `:action ShowBookmarks` | ✅ **PERFECT** | Toggle harpoon UI |
| **Harpoon Navigation** | | | | | |
| `<leader>mp` | **harpoon.lua** | `harpoon:list():prev()` | `:action PreviousTab` | ✅ **v4.0** | **Restored** - Previous harpoon file |
| `<leader>mn` | **harpoon.lua** | `harpoon:list():next()` | `:action NextTab` | ✅ **v4.0** | **Restored** - Next harpoon file |
| **Quick Access Slots** | | | | | |
| `<leader>1` | **harpoon.lua** | `harpoon:list():select(1)` | `'1` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 1 |
| `<leader>2` | **harpoon.lua** | `harpoon:list():select(2)` | `'2` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 2 |
| `<leader>3` | **harpoon.lua** | `harpoon:list():select(3)` | `'3` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 3 |
| `<leader>4` | **harpoon.lua** | `harpoon:list():select(4)` | `'4` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 4 |
| `<leader>5` | **harpoon.lua** | `harpoon:list():select(5)` | `'5` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 5 |
| `<leader>6` | **harpoon.lua** | `harpoon:list():select(6)` | `'6` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 6 |
| `<leader>7` | **harpoon.lua** | `harpoon:list():select(7)` | `'7` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 7 |
| `<leader>8` | **harpoon.lua** | `harpoon:list():select(8)` | `'8` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 8 |
| `<leader>9` | **harpoon.lua** | `harpoon:list():select(9)` | `'9` (vim mark) | ✅ **ADAPTED** | Quick jump to slot 9 |

**Harpoon**: `ma`/`mh`/`1`–`9`/`mp`/`mn`.

**🔧 Key v4.0 Improvements**:
- ✅ **Navigation Restored**: `<leader>mp` and `<leader>mn` for harpoon navigation
- ✅ **Smart Adaptation**: Uses vim marks for quick slots (create with `m1`, `m2`, etc.)

**💡 Usage**: In Neovim, use `<leader>ma` to add files, `<leader>mh` to see list. In IntelliJ, same commands create/show bookmarks.

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

> **✅ Verified**: All terminal commands work | **Todos los comandos de terminal funcionan**

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>tt` | Float terminal | `:action ActivateTerminalToolWindow` | **EN**: Floating terminal / **ES**: Terminal flotante |
| `<leader>tg` | LazyGit terminal | `:action ActivateTerminalToolWindow` | **EN**: LazyGit interface / **ES**: Interfaz LazyGit |
| `<leader>tF` | Flutter terminal | `:action ActivateTerminalToolWindow` | **EN**: Flutter terminal / **ES**: Terminal Flutter |
| **Task Management** | | | |
| `<leader>ob` | Build project | `:action BuildProject` | **EN**: Build project / **ES**: Construir proyecto |
| `<leader>oo` | Task manager | `:action ActivateRunToolWindow` | **EN**: Task manager / **ES**: Gestor de tareas |

### 📱 Flutter Development | Desarrollo Flutter

> **✅ v5.0 - Zero Uppercase** | **v5.0 - Cero Mayúsculas** - 11 commands, all with `fl*` prefix

| Keymap | Neovim Action | IntelliJ Action | Description |
|--------|---------------|-----------------|-------------|
| `<leader>flr` | Flutter reload | `:action Flutter.HotReload` | Hot reload (was Fr ⚡no Shift) |
| `<leader>fls` | Flutter restart | `:action Flutter.HotRestart` | Hot restart (was FR ⚡no Shift) |
| `<leader>fld` | Flutter DevTools | `:action Flutter.OpenDevTools` | Open DevTools (was Fd) |
| `<leader>flq` | Flutter quit | `:action Flutter.Stop` | Quit/stop (was Fq) |
| `<leader>fle` | Flutter emulator | `:action Flutter.StartEmulator` | Start emulator (was Fe) |
| `<leader>flsd` | Flutter device | `:action RunConfiguration` | Select device (was FD) |
| `<leader>flo` | Flutter outline | `:action Flutter.Outline` | Toggle outline (was Fo) |
| `<leader>flc` | Flutter clear | `:action Flutter.ClearLog` | Clear log (was Fc) |
| `<leader>flp` | Flutter profiler | `:action Flutter.CopyProfilerUrl` | Copy profiler URL (was Ft) |
| `<leader>fll` | Flutter LSP | `:action RestartFlutterLsp` | Restart LSP (was Fl) |
| `<leader>fla` | Flutter start | `:action RunClass` | Start app (was Fs) |

**Flutter**: `fl*` lowercase prefixes (IdeaVim maps the same letters).

**🚀 Key v5.0 Improvements**:
- 🚫 **0 uppercase**: All `F*` converted to `fl*` (no Shift needed)
- 🎯 **Logical prefix**: `fl*` groups all Flutter commands for autocomplete
- ⚡ **Faster**: `Fr`→`flr` easier to type without Shift key

### 🧪 Testing | Pruebas

> **✅ v5.0 - Zero Uppercase** | **v5.0 - Cero Mayúsculas** - 4 commands, `te*` prefix

| Keymap | Neovim Action | IntelliJ Action | Description |
|--------|---------------|-----------------|-------------|
| `<leader>ten` | Test nearest | `:action RunClass` | Test nearest |
| `<leader>tenf` | Test file | `:action RunClass` | Test file |
| `<leader>tena` | Test all | `:action RunAll` | Test all suite |
| `<leader>tenl` | Test last | `:action Rerun` | Rerun last test |

**Testing**: `ten*` prefix (`ten` / `tenf` / `tena` / `tenl`).

**🚀 Testing notes**:
- 🎯 **Logical prefix**: `ten*` groups all testing commands for autocomplete

### 🚀 Code Runner | Ejecutor de Código

> **✅ Verified**: All runner actions confirmed working | **Todas las acciones de runner confirmadas funcionando**

| Keymap | Neovim Action | IntelliJ Action | Description/Descripción |
|--------|---------------|-----------------|-------------------------|
| `<leader>r` | Run code | `:action Run` | **EN**: Run current code / **ES**: Ejecutar código actual |
| `<leader>rf` | Run file | `:action Run` | **EN**: Run current file / **ES**: Ejecutar archivo actual |
| `<leader>rp` | Run project | `:action RunProject` | **EN**: Run project / **ES**: Ejecutar proyecto |
| `<leader>rc` | Stop execution | `:action Stop` | **EN**: Stop execution / **ES**: Detener ejecución |

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
  - `<leader>.` para búsqueda rápida (leader + punto)
  - `,,` para búsqueda rápida (doble coma)
  - `<leader>1-9` con Harpoon para cambio instantáneo

---

## 📦 Plugin Ecosystem | Ecosistema de Plugins

### 🔧 Core Development | Desarrollo Principal

#### **Language Server Protocol (LSP)**
- **nvim-lspconfig**: Native `vim.lsp.config()` for 11 servers (guarded: only enabled when the binary exists)
- **Servers**: `lua_ls`, `dartls`, `clangd`, `sourcekit` (macOS), `kotlin_language_server`, `jsonls`, `yamlls`, `gopls`, `pyright`, `vtsls`, `astro`
- **cmp-nvim-lsp**: LSP autocompletion integration
- **none-ls.nvim**: Code formatting and linting (community-maintained null-ls successor)
- **schemastore.nvim**: JSON schema validation
- **mason-tool-installer.nvim**: Self-installs `lua-language-server`, `stylua`, `prettier`, `clang-format` on startup

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
- **dashboard-nvim**: CAPDESIS startup screen (`f`/`g`/`r`/`e`/`a`/`m`/`l`/`q`)
- **dropbar.nvim**: Winbar breadcrumbs
- **nvim-highlight-colors**: Hex / Tailwind color preview
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
- **dart-vim-plugin**: Dart filetype helpers (`dart_format_on_save` is off; format via `<leader>fm`)
- **nvim-dap**: Debugging support

#### **Code Intelligence**
- **nvim-treesitter**: Advanced syntax highlighting
- **trouble.nvim**: Diagnostics list
- **Comment.nvim**: Smart commenting
- **nvim-autopairs**: Auto-closing brackets

#### **AI Assistants**
- **copilot.vim + CopilotChat.nvim**: Inline suggestions + chat (`<leader>c*`, visual fix/review)
- **AI terminal CLIs** (`lua/plugins/ai-terminal.lua`): `opencode`, `codex`, `claude`, `gemini`, `grok`, `copilot` as floating terminals (`<leader>a*`) — each keeps its own subscription, no API keys in Neovim
- **Visual workflow**: select code → `<leader>as` → pick any agent → type the instruction → selection is sent (backup copy stays in the clipboard)

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
1. **Daily Development**: `<leader>gs` → `<leader>gsa` → `<leader>gc`
2. **Code Review**: `<leader>gdo` → `<leader>gn`/`<leader>gnp` → `<leader>gdq`
3. **Conflict Resolution**: Auto-detected → `<leader>gco`/`<leader>gct`
4. **History Investigation**: `<leader>gb` (blame) → `<leader>gdh` (file history)

#### **Flutter Development Workflow**
1. **Start Development**: `<leader>fle` → `<leader>flsd` → `<leader>fla`
2. **Active Development**: `<leader>flr` (hot reload) → `<leader>fls` (hot restart if needed)
3. **Debugging**: `<leader>fld` (DevTools) → `<leader>flo` (outline)
4. **Testing**: `<leader>ten` → `<leader>tenf` → `<leader>tena`

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
  - `<leader>gn`/`<leader>gnp` to review changes before committing
  - `<leader>gsa`/`<leader>gsr` for staging/resetting hunks
- **Terminal & Diagnostics**:
  - `<leader>tg` for LazyGit, `<leader>tF` for Flutter commands
  - `<leader>xx` for trouble diagnostics, `<leader>xn`/`<leader>xp` for navigation
- **LSP Power**: `<leader>ca` works in any LSP-supported file, `<leader>fm` for formatting

#### **Cross-Editor Consistency**
- **Identical Keymaps**: All commands work the same in both Neovim and IntelliJ
- **Muscle Memory**: Switch between editors without mental overhead
- **Project Synchronization**: Open same project in both tools seamlessly

---

## 🔧 IntelliJ IDEA Synchronization | Sincronización con IntelliJ

### 📋 Complete .ideavimrc Integration

The included `.ideavimrc` (repo **root**, not inside `.config/nvim/`) mirrors the Neovim leader prefixes so muscle memory transfers between Neovim and Android Studio/IntelliJ IDEA. AI terminals (`<leader>a*`) and CopilotChat (`<leader>c*`) are Neovim-only.

### English Setup
1. **Copy the configuration**: `ln -sf ~/Neovim-Vim_Configuration/.ideavimrc ~/.ideavimrc` (Windows: `Copy-Item ... $HOME\_ideavimrc`)
2. **Restart IntelliJ IDEA**
3. **Enable IdeaVim plugin** in Settings → Plugins
4. **Shared prefixes work the same**; Neovim-only maps (AI CLIs, CopilotChat, Oil, Tagbar) stay in Neovim

### Español Configuración
1. **Copiar la configuración**: `ln -sf ~/Neovim-Vim_Configuration/.ideavimrc ~/.ideavimrc` (Windows: `Copy-Item ... $HOME\_ideavimrc`)
2. **Reiniciar IntelliJ IDEA**
3. **Habilitar plugin IdeaVim** en Settings → Plugins
4. **Los prefijos compartidos coinciden**; los mapas solo-Neovim (CLIs de IA, CopilotChat, Oil, Tagbar) quedan en Neovim

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

---

## 🔍 **Master Command Reference | Referencia Maestra de Comandos**

> **EN**: Tables below match the Lua config as of September 2026. Visual `S` is vim-surround (Flash treesitter select is normal/operator only). IdeaVim equivalents live in the **repo-root** `.ideavimrc`. Live list: `:Telescope keymaps`.
>
> **ES**: Las tablas coinciden con el Lua de septiembre de 2026 (volcado de keymaps, cero conflictos duros). Los equivalentes de IdeaVim están en `.ideavimrc` **en la raíz del repo**. Lista en vivo: `:Telescope keymaps`.
>
> `<leader><leader>` clears search highlight (`:nohl`). It is **not** a file finder.

### 🔭 **1. Telescope & Search | Búsqueda**

| Keymap | Neovim | IntelliJ (`.ideavimrc`) |
|--------|--------|-------------------------|
| `<leader>ff` | `builtin.find_files` | `GotoFile` |
| `<leader>fg` | `builtin.live_grep` | `FindInPath` |
| `<leader>fo` | `builtin.oldfiles` | `RecentFiles` |
| `<leader>fb` | `builtin.buffers` | `Switcher` |
| `<leader>fh` | `builtin.help_tags` | `HelpTopics` |
| `<leader>fc` | `builtin.commands` | `GotoAction` |
| `<leader>fk` | `builtin.keymaps` | `GotoAction` |
| `<leader>.` | `builtin.find_files` | `GotoFile` |
| `,,` | `builtin.find_files` | `GotoFile` |
| `<leader>ps` | `builtin.lsp_dynamic_workspace_symbols` | `GotoSymbol` |
| `<leader>fp` | `:Telescope projects` | `ManageRecentProjects` |
| `<leader>sr` | grug-far search/replace | — (Neovim only) |

### 🔄 **2. Git**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `<leader>gs` | `:Git` | `ActivateVersionControlToolWindow` |
| `<leader>gc` | `:Git commit` | `CheckinProject` |
| `<leader>gp` | `:Neogit push` | `Vcs.Push` |
| `<leader>gl` | `:Neogit pull` | `Vcs.UpdateProject` |
| `<leader>gf` | `:Git fetch` | `Git.Fetch` |
| `<leader>gb` / `gbl` / `gbt` | blame | `Annotate` |
| `<leader>gbr` | `:GBrowse` | `Git.Branches` |
| `<leader>gbc` | `:Git diff HEAD~1` | `Git.CompareWithBranch` |
| `<leader>gh` / `ghd` | git log | `Vcs.ShowTabbedFileHistory` |
| `<leader>gd` | `:Gdiffsplit` | `Compare.SameVersion` |
| `<leader>gdo` / `gdq` / `gdh` / `gdf` / `gdl` | Diffview / gitsigns | `Compare.LastVersion` / close / history |
| `<leader>gsa` / `gsr` / `gsu` / `gsp` / `gsb` | stage / reset / undo-stage / preview / reset-buffer | VCS hunk actions |
| `<leader>gn` / `gnp` | next / prev hunk | `VcsShowNextChangeMarker` / Prev |
| `<leader>gco` / `gct` / `gcb` / `gcn` / `gcp` / `gcnn` | git-conflict | ChooseOurs / Theirs / Both / None |

### 🔧 **3. LSP**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `gd` / `gi` / `K` | native 0.11+ defaults | `GotoDeclaration` / `GotoImplementation` / `QuickJavaDoc` |
| `go` | `vim.lsp.buf.type_definition` | `GotoTypeDeclaration` |
| `gs` | `vim.lsp.buf.signature_help` | `ParameterInfo` |
| `gR` | Trouble `lsp_references` | `FindUsages` |
| `<leader>rn` | rename | `RenameElement` |
| `<leader>ca` | code action | `ShowIntentionActions` |
| `<leader>fm` | format | `OptimizeImports` |
| `<C-space>` (insert) | completion | same |

### 📌 **4. Harpoon**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `<leader>ma` | add file | `ToggleBookmark` |
| `<leader>mh` | toggle menu | `ShowBookmarks` |
| `<leader>1`–`<leader>9` | jump to mark | vim marks `'1`–`'9` |
| `<leader>mp` / `mn` | prev / next | `GotoPreviousBookmark` / `GotoNextBookmark` |

### 💻 **5. Terminal, runner, tests, AI**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `<leader>tt` | float terminal | `ActivateTerminalToolWindow` |
| `<leader>tg` | LazyGit | same tool window |
| `<leader>tn` / `tp` / `tu` / `tF` | node / python / sysmon / flutter | — (Neovim only) |
| `<leader>r` / `rf` / `rp` / `rc` | code_runner | `Run` / `RunClass` / `RunProject` / `Stop` |
| `<leader>rs` | stop jobs | `Stop` |
| `<leader>rb` | `make` if present, else hint | `Android.SyncProject` |
| `<leader>oo` / `or` / `ob` / `oi` | Overseer | Run tool window / RunAnything / Make / EditConfigurations |
| `<leader>ten` / `tenf` / `tena` / `tenl` | vim-test | `RunClass` / `RunAll` / `Rerun` |
| `<leader>aa` / `ax` / `ac` / `ag` / `ak` / `ap` | AI CLIs (opencode/codex/claude/gemini/grok/copilot) | — (Neovim only) |
| `<leader>as` (visual) | send selection to any agent | — |
| `<leader>cc` / `ce` / `cr` / `cf` / `co` / `ct` | CopilotChat | — (Neovim only) |

### 📱 **6. Flutter (`fl*` lowercase)**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `<leader>flr` | Hot Reload | `Flutter.HotReload` |
| `<leader>fls` | Hot Restart | `Flutter.Restart` |
| `<leader>fld` | DevTools | `Flutter.Open.DevTools` |
| `<leader>fla` | Run | `Run` |
| `<leader>flsd` | Devices | `DeviceAndSnapshotComboBox` |
| `<leader>fle` | Emulators | `AvdManager` |
| `<leader>flq` | Quit | `Stop` |
| `<leader>flo` | Outline | `ActivateStructureToolWindow` |
| `<leader>flc` | Clear log | logcat close |
| `<leader>flp` | Profiler URL | — (Neovim only) |
| `<leader>fll` | Restart Dart LSP | — (Neovim only) |

### 📂 **7. Files**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `<leader>pv` | Neo-tree toggle | `ActivateProjectToolWindow` |
| `<leader>fr` | Reveal file | `SelectInProjectView` |
| `<leader>pe` / `pf` | Focus tree | same |
| `<leader>bf` | Buffer tree | `Switcher` |
| `<leader>-` / `<leader>oe` | Oil float | project tool window |

### 🔧 **8. Diagnostics (Trouble v3)**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `<leader>xx` / `xw` | workspace diagnostics | `ActivateProblemsViewToolWindow` |
| `<leader>xX` / `xd` | buffer diagnostics | same |
| `<leader>xl` / `xq` | loclist / quickfix | same |
| `<leader>xn` / `xp` | next / prev diagnostic | `GotoNextError` / `GotoPreviousError` |
| `<leader>xt` | TODOs | — (Neovim only) |

### ⚡ **9. Buffers & windows**

| Keymap | Neovim | IntelliJ |
|--------|--------|----------|
| `<leader>b` | Back (`<C-o>`) | `Back` |
| `<leader>bn` / `bp` | next / prev buffer | `NextTab` / `PreviousTab` |
| `<leader>bd` | close buffer | `CloseContent` |
| `<leader>bl` / `bh` | close right / left | `CloseAllToTheRight` / Left |
| `<leader>bP` / `bt` | pick / pin | — / `PinActiveTab` |
| `<S-l>` / `<S-h>` | next / prev | `NextTab` / `PreviousTab` |
| `<leader>wh/j/k/l` | window nav | same |
| `<leader>sv` / `sh` / `sc` / `so` | splits | SplitVertically / Horizontally / Unsplit |
| `<leader>wm` / `ws` | WinShift move / swap | MoveEditorToOppositeTabGroup |

> **Live list**: `:Telescope keymaps`. Prefix delays (`<leader>f` vs `<leader>ff`) wait `timeoutlen=300` — by design, not a conflict.

### 🚀 **Current Configuration Achievements (validated September 2026)**

- ✅ **Zero hard conflicts** - 500+ runtime keymaps audited, no two actions share a key
- ✅ **Cross-editor sync** - ~110 shared leader keymaps with `.ideavimrc`
- ✅ **Cross-platform** - Windows, macOS and Linux (paths/shells auto-detected)
- ✅ **Lazy-loaded architecture** - ~60% of plugin specs load at startup idle, the rest on demand
- ✅ **Zero deprecation warnings** - native 0.12 APIs throughout

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
- **Fast startup**: ~9 of ~77 specs load at idle (lazy.nvim)

---

## 📊 **Configuration Stats | Estadísticas de Configuración**

### 📈 **By the Numbers | Por los Números** (measured September 2026)
- **~77 plugin specs**: curated; ~9 load at idle startup
- **Runtime keymaps**: audited conflict-free (prefix delays wait `timeoutlen=300`)
- **LSP**: Mason auto-enables Lua, C/C++, Kotlin, JSON, YAML, Go, Python, TypeScript, Astro, PHP (intelephense) when installed; Dart is started by flutter-tools; Swift is macOS-only (`sourcekit-lsp`)
- **Formatters**: stylua, prettier (Mason); black / clang-format via `uv` on Windows; dart_format / gofmt from SDKs
- **7 themes**: Dracula (default), molokai, solarized, onedark, gruvbox, rose-pine, catppuccin
- **Cross-platform**: Windows, macOS, Linux (shells, paths and tools auto-detected)
- **3 ways**: Quick file access (`ff`, `<leader>.`, `,,`)
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
# Check active servers (native 0.12 API)
:checkhealth vim.lsp

# Missing servers/formatters install themselves via Mason on startup.
# You can also install manually:
:MasonInstall lua-language-server stylua prettier

# For Dart/Flutter
flutter doctor

# For C/C++
which clangd

# For Swift
which sourcekit-lsp
```

#### **Icons Not Showing | Iconos No Se Muestran**
```bash
# Install a Nerd Font for your terminal, then set it as the terminal font:
#   macOS:   brew install --cask font-fira-code-nerd-font
#   Windows: winget install "FiraCode Nerd Font"  (or download from nerdfonts.com)
#   Linux:   download from nerdfonts.com + fc-cache -fv
# Restart the terminal application
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
- `:checkhealth vim.lsp` - LSP server status
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

## 🎯 **Verified Configuration | Configuración Verificada**

### ✅ **Audited Keymaps | Keymaps Auditados**

**Runtime keymap dumps are checked for hard conflicts (same mode + same key triggering different actions). September 2026 audit: 500+ mappings, zero hard conflicts** | **Los volcados de keymaps se revisan contra conflictos duros. Auditoría de septiembre de 2026: más de 500 mapeos, cero conflictos**.

- **Cross-Editor Consistency** | **Consistencia Cross-Editor**
- **Verified Action IDs** | **Action IDs Verificados**

---

**🔗 Repository**: [Neovim-Vim_Configuration](https://github.com/chochy2001/Neovim-Vim_Configuration)
**✅ Platforms**: Windows, macOS, Linux (validated September 2026)
**⚡ Loading**: lazy.nvim, event-based (~60% of specs load at startup idle)
**🧠 Maintained by**: [Jorge Salgado Miranda](https://github.com/chochy2001)

---

*Happy coding! | ¡Feliz programación! 🚀*