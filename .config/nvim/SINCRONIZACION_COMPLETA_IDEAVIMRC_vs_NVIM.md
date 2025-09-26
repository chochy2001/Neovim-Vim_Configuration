# 🔄 **ANÁLISIS COMPLETO: SINCRONIZACIÓN .ideavimrc ↔ Neovim**

**Total comandos .ideavimrc:** 97
**Fecha análisis:** $(date)
**Estado:** ANÁLISIS EXHAUSTIVO COMANDO POR COMANDO

---

## 📊 **RESUMEN EJECUTIVO**

| Estado | Cantidad | Porcentaje |
|--------|----------|------------|
| ✅ **SINCRONIZADO** | 0 | 0% |
| ⚠️ **PARCIAL** | 0 | 0% |
| ❌ **FALTANTE** | 0 | 0% |
| **TOTAL** | 97 | 100% |

---

## 🎯 **ANÁLISIS POR CATEGORÍAS**

### **1. 🔧 CORE & BASIC MAPPINGS (14 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `inoremap jj <Esc>` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("i", "jj", "<Esc>")` | ✅ Perfecto |
| `nnoremap <leader><leader> :nohl<CR>` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader><leader>", ":nohl<CR>")` | ✅ Perfecto |
| `nnoremap <leader>b :action Back<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>b", "<C-o>")` | ✅ Equivalente |
| `nnoremap <leader>f :action Forward<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>wh <C-w>h` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>wh", "<C-w>h")` | ✅ Perfecto |
| `nnoremap <leader>wj <C-w>j` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>wj", "<C-w>j")` | ✅ Perfecto |
| `nnoremap <leader>wk <C-w>k` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>wk", "<C-w>k")` | ✅ Perfecto |
| `nnoremap <leader>wl <C-w>l` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>wl", "<C-w>l")` | ✅ Perfecto |
| `nnoremap <A-j> :m .+1<CR>==` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <A-k> :m .-2<CR>==` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `vnoremap <A-j> :m '>+1<CR>gv=gv` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `vnoremap <A-k> :m '<-2<CR>gv=gv` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `vnoremap > >gv` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `vnoremap < <gv` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Core:** 8/14

---

### **2. 📍 SEARCH & NAVIGATION (6 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap n nzz` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap N Nzz` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap * *zz` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap # #zz` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `vnoremap <leader>u gu` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `vnoremap <leader>U gU` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Search:** 6/6

---

### **3. 🔍 TELESCOPE EMULATION (9 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>ff :action GotoFile<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>ff", builtin.find_files)` | ✅ Perfecto |
| `nnoremap <leader>fg :action FindInPath<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>fg", builtin.live_grep)` | ✅ Perfecto |
| `nnoremap <leader>fo :action RecentFiles<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>fo", builtin.oldfiles)` | ✅ Perfecto |
| `nnoremap <leader>fb :action Switcher<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>fb", builtin.buffers)` | ✅ Perfecto |
| `nnoremap <leader>fh :action HelpTopics<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>fh", builtin.help_tags)` | ✅ Perfecto |
| `nnoremap <leader>fc :action GotoAction<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>fc", builtin.commands)` | ✅ Perfecto |
| `nnoremap <leader>ps :action GotoSymbol<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>. :action GotoFile<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>.", builtin.find_files)` | ✅ Perfecto |
| `nnoremap ,, :action GotoFile<CR>` | telescope.lua | ✅ IGUAL | `vim.keymap.set("n", ",,", builtin.find_files)` | ✅ Perfecto |

**Comandos faltantes en Telescope:** 1/9

---

### **4. 🌳 NEO-TREE EMULATION (2 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>pv :action ActivateProjectToolWindow<CR>` | neo-tree.lua | ✅ IGUAL | `{ "<leader>pv", "<cmd>Neotree filesystem toggle<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>fr :action SelectInProjectView<CR>` | neo-tree.lua | ✅ IGUAL | `{ "<leader>fr", "<cmd>Neotree filesystem reveal<cr>" }` | ✅ Perfecto |

**Comandos faltantes en Neo-tree:** 0/2

---

### **5. 🎯 HARPOON EMULATION (11 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>mm :action ShowBookmarks<CR>` | ❌ CONFLICTO | ⚠️ DIFERENTE | `<leader>mh` en harpoon.lua | ⚠️ Cambié a mh |
| `nnoremap <leader>ma :action ToggleBookmark<CR>` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>ma", harpoon:list():add)` | ✅ Perfecto |
| `nnoremap <leader>1 '1` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>1", harpoon:list():select(1))` | ✅ Perfecto |
| `nnoremap <leader>2 '2` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>2", harpoon:list():select(2))` | ✅ Perfecto |
| `nnoremap <leader>3 '3` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>3", harpoon:list():select(3))` | ✅ Perfecto |
| `nnoremap <leader>4 '4` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>4", harpoon:list():select(4))` | ✅ Perfecto |
| `nnoremap <leader>5 '5` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>5", harpoon:list():select(5))` | ✅ Perfecto |
| `nnoremap <leader>6 '6` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>6", harpoon:list():select(6))` | ✅ Perfecto |
| `nnoremap <leader>7 '7` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>7", harpoon:list():select(7))` | ✅ Perfecto |
| `nnoremap <leader>8 '8` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>8", harpoon:list():select(8))` | ✅ Perfecto |
| `nnoremap <leader>9 '9` | harpoon.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>9", harpoon:list():select(9))` | ✅ Perfecto |

**Comandos con conflictos en Harpoon:** 1/11

---

### **6. 📑 BUFFER MANAGEMENT (8 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <S-l> :action NextTab<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")` | ✅ Perfecto |
| `nnoremap <S-h> :action PreviousTab<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")` | ✅ Perfecto |
| `nnoremap <space>l :action NextSplitter<CR>` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("n", "<space>l", "<C-w>l")` | ✅ Perfecto |
| `nnoremap <space>h :action PrevSplitter<CR>` | vim-options.lua | ✅ IGUAL | `vim.keymap.set("n", "<space>h", "<C-w>h")` | ✅ Perfecto |
| `nnoremap <leader>bn :action NextTab<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>")` | ✅ Perfecto |
| `nnoremap <leader>bp :action PreviousTab<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>")` | ✅ Perfecto |
| `nnoremap <leader>bd :action CloseContent<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>bd", ":bd<CR>")` | ✅ Perfecto |
| `nnoremap <leader>bl :action CloseAllToTheRight<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>bl", ":BufferLineCloseRight<CR>")` | ✅ Perfecto |
| `nnoremap <leader>bh :action CloseAllToTheLeft<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>bh", ":BufferLineCloseLeft<CR>")` | ✅ Perfecto |
| `nnoremap <leader>to :action CloseAllEditorsButActive<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Buffers:** 1/9

---

### **7. 🖥️ TERMINAL (3 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>tt :action ActivateTerminalToolWindow<CR>` | terminal.lua | ✅ IGUAL | `{ "<leader>tt", "<cmd>ToggleTerm direction=float<CR>" }` | ✅ Perfecto |
| `tnoremap <C-[><C-[> <C-w><C-p>` | terminal.lua | ✅ IGUAL | `vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>")` | ✅ Perfecto |
| `tnoremap jj <C-w><C-p>` | terminal.lua | ✅ IGUAL | `vim.keymap.set("t", "jj", "<C-\\><C-n>")` | ✅ Perfecto |

**Comandos faltantes en Terminal:** 0/3

---

### **8. 🔄 GIT/VCS (25 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>gs :action ActivateVersionControlToolWindow<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gs", "<cmd>Git<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>gc :action CheckinProject<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gc", "<cmd>Git commit<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>gps :action Vcs.Push<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gP", "<cmd>Neogit push<CR>" }` | ⚠️ Diferente key |
| `nnoremap <leader>gpl :action Vcs.UpdateProject<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gp", "<cmd>Neogit pull<CR>" }` | ⚠️ Diferente key |
| `nnoremap <leader>gl :action Vcs.ShowTabbedFileHistory<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>gC :action Git.Log.Show.Details<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>gv :action Annotate<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gv", "<cmd>Git blame<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>gn :action VcsShowNextChangeMarker<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>hn", gs.next_hunk)` | ⚠️ Diferente key |
| `nnoremap <leader>gN :action VcsShowPrevChangeMarker<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>hP", gs.prev_hunk)` | ⚠️ Diferente key |
| `nnoremap <leader>hs :action ChangesView.Shelve<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>hs", gs.stage_hunk)` | ✅ Perfecto |
| `nnoremap <leader>ga :action ChangesView.Shelve<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>hr :action Vcs.RollbackChangedLines<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>hr", gs.reset_hunk)` | ✅ Perfecto |
| `nnoremap <leader>hR :action ChangesView.Revert<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>hR", gs.reset_buffer)` | ✅ Perfecto |
| `nnoremap <leader>gdd :action Vcs.Show.Local.Changes<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>gdo :action Compare.LastVersion<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gdo", "<cmd>DiffviewOpen<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>gdc :action CloseContent<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gdc", "<cmd>DiffviewClose<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>co :action ChooseOurs<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set('n', '<leader>co', '<Plug>(git-conflict-ours)')` | ✅ Perfecto |
| `nnoremap <leader>ct :action ChooseTheirs<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set('n', '<leader>ct', '<Plug>(git-conflict-theirs)')` | ✅ Perfecto |
| `nnoremap <leader>cb :action ChooseBoth<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set('n', '<leader>cb', '<Plug>(git-conflict-both)')` | ✅ Perfecto |
| `nnoremap <leader>c0 :action ChooseNone<CR>` | git-stuff.lua | ✅ IGUAL | `vim.keymap.set('n', '<leader>c0', '<Plug>(git-conflict-none)')` | ✅ Perfecto |
| `nnoremap <leader>gf :action Git.Fetch<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>gb :action Git.Branches<CR>` | git-stuff.lua | ✅ IGUAL | `{ "<leader>gb", "<cmd>GBrowse<cr>" }` | ⚠️ Diferente acción |
| `nnoremap <leader>gcb :action Git.CompareWithBranch<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>we :action NextSplitter<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>wt :action PrevSplitter<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>gds :action Compare.SameVersion<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Git:** 8/25

---

### **9. 📝 UNDOTREE (1 comando)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>u :action LocalHistory.ShowHistory<CR>` | undotree.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")` | ✅ Perfecto |

**Comandos faltantes en Undotree:** 0/1

---

### **10. 💬 COMMENTS (2 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap gcc :action CommentByLineComment<CR>` | editing.lua | ✅ IGUAL | Comment.nvim (automático) | ✅ Perfecto |
| `vnoremap gc :action CommentByLineComment<CR>` | editing.lua | ✅ IGUAL | Comment.nvim (automático) | ✅ Perfecto |

**Comandos faltantes en Comments:** 0/2

---

### **11. 🧠 LSP (9 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap K :action QuickJavaDoc<CR>` | lsp-config.lua | ✅ IGUAL | LSP automático | ✅ Perfecto |
| `nnoremap gd :action GotoDeclaration<CR>` | lsp-config.lua | ✅ IGUAL | LSP automático | ✅ Perfecto |
| `nnoremap gi :action GotoImplementation<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation)` | ⚠️ Con leader |
| `nnoremap go :action GotoTypeDeclaration<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition)` | ⚠️ Diferente key |
| `nnoremap gr :action FindUsages<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)` | ⚠️ Con leader |
| `nnoremap gs :action ParameterInfo<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help)` | ⚠️ Diferente key |
| `nnoremap <leader>ca :action ShowIntentionActions<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)` | ✅ Perfecto |
| `inoremap <C-space> <C-x><C-o>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>lf :action OptimizeImports<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)` | ✅ Perfecto |
| `nnoremap <leader>lw :action Bookmarks<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>lw", ...)` | ✅ Perfecto |
| `nnoremap <leader>rn :action RenameElement<CR>` | lsp-config.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)` | ✅ Perfecto |

**Comandos con diferencias en LSP:** 5/10

---

### **12. 🚨 TROUBLE EMULATION (7 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>xx :action ActivateProblemsViewToolWindow<CR>` | trouble.lua | ✅ IGUAL | `{ "<leader>xx", "<cmd>TroubleToggle<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>xw :action ActivateProblemsViewToolWindow<CR>` | trouble.lua | ✅ IGUAL | `{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>xd :action ActivateProblemsViewToolWindow<CR>` | trouble.lua | ✅ IGUAL | `{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>xl :action ActivateProblemsViewToolWindow<CR>` | trouble.lua | ✅ IGUAL | `{ "<leader>xl", "<cmd>TroubleToggle loclist<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>xq :action ActivateProblemsViewToolWindow<CR>` | trouble.lua | ✅ IGUAL | `{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" }` | ✅ Perfecto |
| `nnoremap <leader>xn :action GotoNextError<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>xp :action GotoPreviousError<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Trouble:** 2/7

---

### **13. 📂 FOLDING (5 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>za :action ExpandCollapseToggleAction<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>zR :action ExpandAllRegions<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>zM :action CollapseAllRegions<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>zr :action ExpandRegion<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>zm :action CollapseRegion<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Folding:** 5/5

---

### **14. 🏗️ BUILD/RUN/DEBUG (4 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>rr :action RunClass<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>rd :action Debug<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>rs :action Stop<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>rb :action Android.SyncProject<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Build/Run:** 4/4

---

### **15. ✂️ SPLITS (5 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>sv :action SplitVertically<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>sh :action SplitHorizontally<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>sc :action Unsplit<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>so :action UnsplitAll<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>_ :action MaximizeEditorInSplit<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Splits:** 5/5

---

### **16. 👁️ QUICK VIEWS (1 comando)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>I :action QuickImplementations<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Quick Views:** 1/1

---

### **17. 🧪 TESTING (4 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>T :action RunClass<CR>` | vim-test.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>T", ":TestNearest<CR>")` | ✅ Perfecto |
| `nnoremap <leader>Tf :action RunClass<CR>` | vim-test.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>Tf", ":TestFile<CR>")` | ✅ Perfecto |
| `nnoremap <leader>Ta :action RunAll<CR>` | vim-test.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>Ta", ":TestSuite<CR>")` | ✅ Perfecto |
| `nnoremap <leader>Tl :action Rerun<CR>` | vim-test.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>Tl", ":TestLast<CR>")` | ✅ Perfecto |

**Comandos faltantes en Testing:** 0/4

---

### **18. 🦋 FLUTTER (9 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>Fs :action Run<CR>` | flutter-tools.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>Fs", "<cmd>FlutterRun<cr>")` | ✅ Perfecto |
| `nnoremap <leader>Fr :action Flutter.HotReload<CR>` | flutter-tools.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>Fr", "<cmd>FlutterReload<cr>")` | ✅ Perfecto |
| `nnoremap <leader>FR :action Flutter.Restart<CR>` | flutter-tools.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>FR", "<cmd>FlutterRestart<cr>")` | ✅ Perfecto |
| `nnoremap <leader>Fq :action Stop<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>Fd :action Flutter.Open.DevTools<CR>` | flutter-tools.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>Fd", "<cmd>FlutterDevTools<cr>")` | ✅ Perfecto |
| `nnoremap <leader>FD :action DeviceAndSnapshotComboBox<CR>` | flutter-tools.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>FD", "<cmd>FlutterDevices<cr>")` | ✅ Perfecto |
| `nnoremap <leader>Fe :action AvdManager<CR>` | flutter-tools.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>")` | ✅ Perfecto |
| `nnoremap <leader>Fo :action ActivateStructureToolWindow<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |
| `nnoremap <leader>Fc :action AndroidLogcatToolWindowFactory.CloseLogcatConsole<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Flutter:** 3/9

---

### **19. 📁 PROJECT MANAGEMENT (1 comando)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>fp :action ManageRecentProjects<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>fp", "<Cmd>Telescope projects<CR>")` | ✅ Perfecto |

**Comandos faltantes en Project:** 0/1

---

### **20. 🏃 CODE RUNNER (1 comando)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>rp :action RunProject<CR>` | terminal.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>rp", ":RunProject<CR>")` | ✅ Perfecto |

**Comandos faltantes en Code Runner:** 0/1

---

### **21. 👀 OVERSEER (2 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>oo :action ActivateRunToolWindow<CR>` | terminal.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>oo", "<cmd>OverseerToggle<cr>")` | ✅ Perfecto |
| `nnoremap <leader>oi :action EditConfigurations<CR>` | ❌ FALTA | ❌ FALTA | - | ❌ No mapeado |

**Comandos faltantes en Overseer:** 1/2

---

### **22. 🪟 WINDOW MANAGEMENT (1 comando)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>wm :action MoveEditorToOppositeTabGroup<CR>` | session-workspace.lua | ✅ IGUAL | `vim.keymap.set("n", "<leader>wm", "<cmd>WinShift<cr>")` | ✅ Perfecto |

**Comandos faltantes en Window Management:** 0/1

---

### **23. 💾 SESSION MANAGEMENT (3 comandos)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>qs :action RestoreSession<CR>` | session-workspace.lua | ✅ IGUAL | `{ "<leader>qs", require("persistence").load }` | ✅ Perfecto |
| `nnoremap <leader>ql :action RestoreLastSession<CR>` | session-workspace.lua | ✅ IGUAL | `{ "<leader>ql", require("persistence").load({ last = true }) }` | ✅ Perfecto |
| `nnoremap <leader>qd :action StopSession<CR>` | session-workspace.lua | ✅ IGUAL | `{ "<leader>qd", require("persistence").stop }` | ✅ Perfecto |

**Comandos faltantes en Session:** 0/3

---

### **24. 🧘 ZEN MODE (1 comando)**

| .ideavimrc | Nvim Archivo | Estado | Comando Nvim | Notas |
|------------|--------------|--------|--------------|-------|
| `nnoremap <leader>zz :action ToggleFullScreen<CR>` | session-workspace.lua | ✅ IGUAL | `{ "<leader>zz", "<cmd>ZenMode<cr>" }` | ✅ Perfecto |

**Comandos faltantes en Zen Mode:** 0/1

---

## 🎯 **RESUMEN FINAL ACTUALIZADO**

| Estado | Cantidad | Porcentaje |
|--------|----------|------------|
| ✅ **SINCRONIZADO** | 53 | 55% |
| ⚠️ **PARCIAL/DIFERENTE** | 7 | 7% |
| ❌ **FALTANTE** | 37 | 38% |
| **TOTAL** | 97 | 100% |

---

## 🚨 **COMANDOS CRÍTICOS FALTANTES**

### **❌ ALTA PRIORIDAD (15 comandos):**
1. `<leader>f` - Forward navigation
2. `<leader>ps` - Go to symbol
3. `<leader>to` - Close all others
4. `<leader>ga` - Git add/shelve
5. `<leader>gl` - Git file history
6. `<leader>gC` - Git log details
7. `<leader>gdd` - Show local changes
8. `<leader>gf` - Git fetch
9. `<leader>gcb` - Compare with branch
10. `<leader>xn` - Next error
11. `<leader>xp` - Previous error
12. `<leader>rr` - Run class
13. `<leader>rd` - Debug
14. `<leader>rs` - Stop
15. `<leader>rb` - Build/sync

### **❌ MEDIA PRIORIDAD (12 comandos):**
1. Alt+j/k - Move lines
2. `>` / `<` - Visual indent
3. `n/N/*/# + zz` - Center search
4. `<leader>u/U` - Case conversion
5. All folding commands (`<leader>z*`)
6. All split commands (`<leader>s*`)
7. `<leader>I` - Quick implementations
8. `inoremap <C-space>` - Completion
9. `<leader>Fq/Fo/Fc` - Flutter commands
10. `<leader>oi` - Edit configurations
11. `<leader>we/wt` - Window navigation
12. `<leader>gds` - Git diff split

### **❌ BAJA PRIORIDAD (10 comandos):**
- Principalmente duplicados o comandos especializados

---

## 📋 **PLAN DE ACCIÓN RECOMENDADO**

### **🔥 FASE 1: COMANDOS CRÍTICOS CORE (5 comandos)**
1. ✅ `<leader>f` - Forward navigation
2. ✅ `<leader>ps` - Go to symbol
3. ✅ `<leader>to` - Close all others
4. ✅ Alt+j/k - Move lines up/down
5. ✅ Visual indent preservation

### **🔥 FASE 2: GIT COMMANDS FALTANTES (6 comandos)**
1. ✅ `<leader>ga` - Git add/shelve
2. ✅ `<leader>gl` - Git file history
3. ✅ `<leader>gC` - Git log details
4. ✅ `<leader>gf` - Git fetch
5. ✅ `<leader>gdd` - Show local changes
6. ✅ `<leader>gcb` - Compare with branch

### **🔥 FASE 3: DESARROLLO COMMANDS (4 comandos)**
1. ✅ `<leader>rr` - Run class
2. ✅ `<leader>rd` - Debug
3. ✅ `<leader>rs` - Stop
4. ✅ `<leader>rb` - Build/sync

**¿Proceder con la implementación de los comandos faltantes?** 🚀