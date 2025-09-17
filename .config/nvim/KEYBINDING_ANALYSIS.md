# 🔍 NVIM ↔ IDEAVIM KEYBINDING ANALYSIS | ANÁLISIS COMPLETO DE KEYBINDINGS

> **Objetivo**: Verificar que TODOS los keybindings de Neovim estén correctamente mapeados en .ideavimrc
> **Objetivo**: Verify that ALL Neovim keybindings are correctly mapped in .ideavimrc

---

## 📋 **PLUGIN BY PLUGIN ANALYSIS | ANÁLISIS PLUGIN POR PLUGIN**

### 🔍 **1. TELESCOPE.LUA** (Fuzzy Finder)

#### **Neovim Keybindings Found:**
- `<leader>ff` → `builtin.find_files` (Find Files)
- `<leader>fg` → `builtin.live_grep` (Find Grep)
- `<leader>fo` → `builtin.oldfiles` (Find Old Files)
- `<leader>fb` → `builtin.buffers` (Find Buffers)
- `<leader>fh` → `builtin.help_tags` (Find Help)
- `<leader>fc` → `builtin.commands` (Find Commands)
- `<leader>fk` → `builtin.keymaps` (Find Keymaps)
- `<leader><leader>` → `builtin.find_files` (Quick Find Files)
- `<leader>fd` → `builtin.find_files` (Find Files duplicate)
- `<leader>.` → `builtin.find_files` (Quick Find Files)
- `,,` → `builtin.find_files` (Quick Find Files)

#### **Expected .ideavimrc Mappings:**
- `<leader>ff` → `:action GotoFile`
- `<leader>fg` → `:action FindInPath`
- `<leader>fo` → `:action RecentFiles`
- `<leader>fb` → `:action Switcher`
- `<leader>fh` → `:action HelpTopics`
- `<leader>fc` → `:action GotoAction`
- `<leader>fk` → `:action Keymap`
- `<leader><leader>` → `:action GotoFile`
- `<leader>fd` → `:action GotoFile`
- `<leader>.` → `:action GotoFile`
- `,,` → `:action GotoFile`

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🌳 **2. NEO-TREE.LUA** (File Explorer)

#### **Neovim Keybindings Found:**
- `<leader>1` → `Neotree filesystem focus` (Focus NeoTree)
- `<leader>pf` → `Neotree filesystem focus` (Project Focus)
- `<leader>we` → `<C-w>l` (Window: Focus editor)
- `<leader>wt` → `<C-w>h` (Window: Focus tree)

#### **Expected .ideavimrc Mappings:**
- `<leader>1` → `:action ActivateProjectToolWindow`
- `<leader>pf` → `:action ActivateProjectToolWindow`
- `<leader>we` → `:action` equivalent for focus editor
- `<leader>wt` → `:action` equivalent for focus tree

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🎯 **3. HARPOON.LUA** (Quick File Bookmarking)

#### **Neovim Keybindings Found:**
- `<leader>ma` → `harpoon:list():add()` (Harpoon: Add File)
- `<leader>mm` → `harpoon.ui:toggle_quick_menu()` (Harpoon: Toggle UI)
- `<leader>1` → `harpoon:list():select(1)` (Harpoon: Select 1)
- `<leader>2` → `harpoon:list():select(2)` (Harpoon: Select 2)
- `<leader>3` → `harpoon:list():select(3)` (Harpoon: Select 3)
- `<leader>4` → `harpoon:list():select(4)` (Harpoon: Select 4)
- `<leader>5` → `harpoon:list():select(5)` (Harpoon: Select 5)
- `<leader>6` → `harpoon:list():select(6)` (Harpoon: Select 6)
- `<leader>7` → `harpoon:list():select(7)` (Harpoon: Select 7)
- `<leader>8` → `harpoon:list():select(8)` (Harpoon: Select 8)
- `<leader>9` → `harpoon:list():select(9)` (Harpoon: Select 9)

#### **Expected .ideavimrc Mappings:**
- `<leader>ma` → `:action AddToFavorites`
- `<leader>mm` → `:action RecentFiles`
- `<leader>1` → `'1` (mark 1)
- `<leader>2` → `'2` (mark 2)
- `<leader>3` → `'3` (mark 3)
- `<leader>4` → `'4` (mark 4)
- `<leader>5` → `'5` (mark 5)
- `<leader>6` → `'6` (mark 6)
- `<leader>7` → `'7` (mark 7)
- `<leader>8` → `'8` (mark 8)
- `<leader>9` → `'9` (mark 9)

#### **Status**: ⏳ PENDING VERIFICATION

---

### 📦 **4. SESSION-WORKSPACE.LUA** (Buffer & Session Management)

#### **Neovim Keybindings Found:**
- `<leader>fp` → `Telescope projects` (Find Projects)
- `<leader>bn` → `:BufferLineCycleNext` (Buffer: Next)
- `<leader>bP` → `:BufferLineCyclePrev` (Buffer: Previous)
- `<leader>bd` → `:BufferLinePickClose` (Buffer: Pick to Close)
- `<leader>bl` → `:BufferLineCloseRight` (Buffer: Close Right)
- `<leader>bh` → `:BufferLineCloseLeft` (Buffer: Close Left)
- `<leader>bp` → `:BufferLinePick` (Buffer: Pick)
- `<leader>bt` → `:BufferLineTogglePin` (Toggle Pin Buffer)
- `<S-l>` → `:BufferLineCycleNext` (Buffer: Next)
- `<S-h>` → `:BufferLineCyclePrev` (Buffer: Previous)
- `<leader>wm` → `WinShift` (WinShift: Move Window)
- `<leader>ws` → `WinShift swap` (WinShift: Swap Window)

#### **Expected .ideavimrc Mappings:**
- `<leader>fp` → `:action ManageRecentProjects`
- `<leader>bn` → `:action NextTab`
- `<leader>bP` → `:action PreviousTab`
- `<leader>bd` → `:action CloseContent`
- `<leader>bl` → `:action CloseAllToTheRight`
- `<leader>bh` → `:action CloseAllToTheLeft`
- `<leader>bp` → `:action Switcher`
- `<leader>bt` → `:action PinActiveTab`
- `<S-l>` → `:action NextTab`
- `<S-h>` → `:action PreviousTab`
- `<leader>wm` → `:action MoveEditorToOppositeTabGroup`
- `<leader>ws` → `:action MoveTabToOppositeTabGroup`

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🔧 **5. LSP-CONFIG.LUA** (Language Server Protocol)

#### **Neovim Keybindings Found:**
- `<leader>gD` → `vim.lsp.buf.declaration` (Go to Declaration)
- `<leader>gd` → `vim.lsp.buf.definition` (Go to Definition)
- `<leader>gi` → `vim.lsp.buf.implementation` (Go to Implementation)
- `<leader>gr` → `vim.lsp.buf.references` (References)
- `<leader>gT` → `vim.lsp.buf.type_definition` (Type Definition)
- `<leader>lh` → `vim.lsp.buf.hover` (LSP: Hover Documentation)
- `<leader>ls` → `vim.lsp.buf.signature_help` (LSP: Signature Help)
- `<leader>rn` → `vim.lsp.buf.rename` (Rename Symbol)
- `<leader>ca` → `vim.lsp.buf.code_action` (Code Action)
- `<leader>lf` → Format function (LSP Format)
- `<leader>lw` → Workspace function (List Workspace)

#### **Expected .ideavimrc Mappings:**
- `<leader>gD` → `:action GotoDeclaration`
- `<leader>gd` → `:action GotoDeclaration`
- `<leader>gi` → `:action GotoImplementation`
- `<leader>gr` → `:action FindUsages`
- `<leader>gT` → `:action GotoTypeDeclaration`
- `<leader>lh` → `:action QuickJavaDoc`
- `<leader>ls` → `:action ParameterInfo`
- `<leader>rn` → `:action RenameElement`
- `<leader>ca` → `:action ShowIntentionActions`
- `<leader>lf` → `:action ReformatCode`
- `<leader>lw` → `:action ShowBookmarks`

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🌿 **6. GIT-STUFF.LUA** (Git Integration)

#### **Neovim Keybindings Found:**
##### **Fugitive Keys:**
- `<leader>gs` → `Git` (Git Status)
- `<leader>gw` → `Gwrite` (Git Write)
- `<leader>gc` → `Git commit` (Git Commit)
- `<leader>gds` → `Gdiffsplit` (Git Diff Split)
- `<leader>gv` → `Git blame` (Git Blame Toggle)
- `<leader>gB` → `Git blame` (Git Blame)
- `<leader>gb` → `GBrowse` (Git Browse)

##### **GitSigns Keys:**
- `<leader>hn` → Next hunk function
- `<leader>hP` → Previous hunk function
- `<leader>hs` → `gs.stage_hunk` (Git: Stage Hunk)
- `<leader>hr` → `gs.reset_hunk` (Git: Reset Hunk)
- `<leader>hS` → `gs.stage_buffer` (Git: Stage Buffer)
- `<leader>hu` → `gs.undo_stage_hunk` (Git: Undo Stage Hunk)
- `<leader>hR` → `gs.reset_buffer` (Git: Reset Buffer)
- `<leader>hp` → `gs.preview_hunk` (Git: Preview Hunk)
- `<leader>hb` → `gs.blame_line` (Git: Blame Line)
- `<leader>tb` → `gs.toggle_current_line_blame` (Git: Toggle Line Blame)
- `<leader>hd` → `gs.diffthis` (Git: Diff This)
- `<leader>td` → `gs.toggle_deleted` (Git: Toggle Deleted)
- `<leader>ih` → Select hunk (text object)

##### **Diffview Keys:**
- `<leader>gdo` → `DiffviewOpen` (Git: Open Diffview)
- `<leader>gdc` → `DiffviewClose` (Git: Close Diffview)
- `<leader>gdh` → `DiffviewFileHistory` (Git: File History)
- `<leader>gdf` → `DiffviewToggleFiles` (Git: Toggle Files Panel)

##### **Neogit Keys:**
- `<leader>gg` → `Neogit` (Open Neogit)
- `<leader>gcn` → `Neogit commit` (Neogit Commit)
- `<leader>gp` → `Neogit pull` (Neogit Pull)
- `<leader>gP` → `Neogit push` (Neogit Push)

##### **Git Conflict Keys:**
- `<leader>co` → Git conflict ours
- `<leader>ct` → Git conflict theirs
- `<leader>cb` → Git conflict both
- `<leader>c0` → Git conflict none
- `<leader>cp` → Git conflict previous
- `<leader>cn` → Git conflict next

#### **Expected .ideavimrc Mappings:**
[TO BE VERIFIED AGAINST ACTUAL .ideavimrc]

#### **Status**: ⏳ PENDING VERIFICATION

---

### 💻 **7. TERMINAL.LUA** (Terminal Management)

#### **Neovim Keybindings Found:**
- `<Esc>` → `<C-\\><C-n>` (Exit terminal mode)
- `jj` → `<C-\\><C-n>` (Exit terminal mode)
- `<leader>wh` → `<C-w>h` (Window: Go Left)
- `<leader>wj` → `<C-w>j` (Window: Go Down)
- `<leader>wk` → `<C-w>k` (Window: Go Up)
- `<leader>wl` → `<C-w>l` (Window: Go Right)
- `<leader>tg` → LazyGit toggle function
- `<leader>tn` → Node toggle function
- `<leader>tu` → Htop toggle function
- `<leader>tp` → Python toggle function
- `<leader>tF` → Flutter toggle function
- `<leader>oo` → `OverseerToggle` (Overseer: Toggle)
- `<leader>or` → `OverseerRun` (Overseer: Run Task)
- `<leader>ob` → `OverseerBuild` (Overseer: Build)
- `<leader>r` → `RunCode` (Run Code)
- `<leader>rf` → `RunFile` (Run File)
- `<leader>rft` → `RunFile tab` (Run File in Tab)
- `<leader>rp` → `RunProject` (Run Project)
- `<leader>rc` → `RunClose` (Close Runner)

#### **Expected .ideavimrc Mappings:**
[TO BE VERIFIED AGAINST ACTUAL .ideavimrc]

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🚀 **8. FLUTTER-TOOLS.LUA** (Flutter Development)

#### **Neovim Keybindings Found:**
- `<leader>Fs` → `FlutterRun` (Flutter: Start App)
- `<leader>FD` → `FlutterDevices` (Flutter: Select Device)
- `<leader>Fe` → `FlutterEmulators` (Flutter: Start Emulator)

#### **Expected .ideavimrc Mappings:**
- `<leader>Fs` → `:action Flutter.Start`
- `<leader>FD` → `:action Flutter.SelectDevice`
- `<leader>Fe` → `:action Flutter.StartEmulator`

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🧪 **9. VIM-TEST.LUA** (Testing Framework)

#### **Neovim Keybindings Found:**
- `<leader>T` → `:TestNearest` (Test: Nearest)
- `<leader>Tf` → `:TestFile` (Test: File)
- `<leader>Ta` → `:TestSuite` (Test: All Suite)
- `<leader>Tl` → `:TestLast` (Test: Last)

#### **Expected .ideavimrc Mappings:**
- `<leader>T` → `:action RunClass`
- `<leader>Tf` → `:action RunClass`
- `<leader>Ta` → `:action RunAllTestsInProject`
- `<leader>Tl` → `:action Rerun`

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🛠️ **10. OIL.LUA** (Directory Editor)

#### **Neovim Keybindings Found:**
- `<leader>-` → Oil parent directory function
- `<leader>oe` → Oil file explorer function

#### **Expected .ideavimrc Mappings:**
- `<leader>-` → `:action ActivateProjectToolWindow`
- `<leader>oe` → `:action ActivateProjectToolWindow`

#### **Status**: ⏳ PENDING VERIFICATION

---

### 🌲 **11. UNDOTREE.LUA** (Undo History)

#### **Neovim Keybindings Found:**
- `<leader>u` → `:UndotreeToggle` (Toggle Undotree)

#### **Expected .ideavimrc Mappings:**
- `<leader>u` → `:action LocalHistory.ShowHistory`

#### **Status**: ⏳ PENDING VERIFICATION

---

### 📝 **12. NONE-LS.LUA** (Formatting & Linting)

#### **Neovim Keybindings Found:**
- `<leader>lf` → Format function (Format Code)

#### **Expected .ideavimrc Mappings:**
- `<leader>lf` → `:action ReformatCode`

#### **Status**: ⏳ PENDING VERIFICATION

---

## 🔍 **NEXT STEPS | PRÓXIMOS PASOS**

### **Phase 1: Verification | Fase 1: Verificación**
1. ✅ Extract all nvim keybindings (DONE)
2. ⏳ Compare each with .ideavimrc
3. ⏳ Identify missing mappings
4. ⏳ Identify incorrect action IDs

### **Phase 2: Implementation | Fase 2: Implementación**
1. ⏳ Add missing mappings to .ideavimrc
2. ⏳ Fix incorrect action IDs
3. ⏳ Test each mapping individually
4. ⏳ Document verification results

### **Phase 3: Documentation | Fase 3: Documentación**
1. ⏳ Update README with 100% verified commands
2. ⏳ Create testing checklist
3. ⏳ Final validation

---

**📋 Total Keybindings Found**: ~80+ keybindings across 12+ plugins
**🎯 Goal**: 100% verification and synchronization between Neovim and IntelliJ IDEA
