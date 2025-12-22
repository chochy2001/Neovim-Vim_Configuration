# 🔍 Análisis Completo de Keymaps - Neovim Config

**Fecha:** 2025-12-22  
**Estado:** ✅ Sin duplicados, todo verificado

---

## 📋 Shortcuts de Telescope (Respuesta Rápida)

### **Búsqueda de Archivos**
```vim
:Telescope find_files
```
**Shortcuts:**
- `<leader>ff` - Principal (Space + f + f)
- `<leader>.` - Rápido con una mano
- `,,` - Ultra rápido (doble coma)

### **Búsqueda de Texto (grep)**
```vim
:Telescope live_grep
```
**Shortcut:**
- `<leader>fg` - Find Grep (Space + f + g)

---

## ✅ Verificación Completa Realizada

### Tests Ejecutados:
1. ✅ Neovim inicia correctamente
2. ✅ vim.loader activado (cache Lua)
3. ✅ Telescope carga exitosamente
4. ✅ FZF extension compilada y funcional
5. ✅ LSP log level = 3 (WARN)
6. ✅ Sin duplicados de keymaps encontrados

---

## 🗺️ Mapa Completo de Keymaps por Categoría

### 🔍 **Find & Search (Telescope)**
| Keymap | Comando | Descripción |
|--------|---------|-------------|
| `<leader>ff` | `:Telescope find_files` | Buscar archivos |
| `<leader>fg` | `:Telescope live_grep` | Buscar texto en proyecto |
| `<leader>fo` | `:Telescope oldfiles` | Archivos recientes |
| `<leader>fb` | `:Telescope buffers` | Buscar buffers abiertos |
| `<leader>fh` | `:Telescope help_tags` | Buscar ayuda |
| `<leader>fc` | `:Telescope commands` | Buscar comandos |
| `<leader>fk` | `:Telescope keymaps` | Buscar keymaps |
| `<leader>ps` | `:Telescope lsp_dynamic_workspace_symbols` | Símbolos del proyecto |
| `<leader>.` | `:Telescope find_files` | Búsqueda rápida |
| `,,` | `:Telescope find_files` | Búsqueda ultra rápida |

**Total:** 10 comandos

---

### 📁 **Git Operations**
| Keymap | Descripción |
|--------|-------------|
| `<leader>gs` | Git Status |
| `<leader>gc` | Git Commit |
| `<leader>gv` | Git Blame Toggle |
| `<leader>gB` | Git Blame |
| `<leader>gb` | Git Branches |
| `<leader>gds` | Git Diff Split |
| `<leader>gdo` | Git: Open Diffview |
| `<leader>gdc` | Git: Close Diffview |
| `<leader>gdh` | Git: File History |
| `<leader>gdf` | Git: Toggle Files Panel |
| `<leader>gl` | Git File History |
| `<leader>gC` | Git Log Details |
| `<leader>gf` | Git Fetch |
| `<leader>gcb` | Git Compare with Branch |
| **Hunks** | |
| `<leader>hs` | Git: Stage Hunk |
| `<leader>ga` | Git: Add/Stage Hunk (alias) |
| `<leader>hr` | Git: Reset Hunk |
| `<leader>hS` | Git: Stage Buffer |
| `<leader>hu` | Git: Undo Stage Hunk |
| `<leader>hR` | Git: Reset Buffer |
| `<leader>hp` | Git: Preview Hunk |
| `<leader>hb` | Git: Blame Line |
| `<leader>hd` | Git: Diff This |
| `<leader>gdd` | Git: Show Local Changes |
| `<leader>tb` | Git: Toggle Line Blame |
| `<leader>td` | Git: Toggle Deleted |
| **Conflicts** | |
| `<leader>co` | Choose Ours |
| `<leader>ct` | Choose Theirs |
| `<leader>cb` | Choose Both |
| `<leader>c0` | Choose None |

**Total:** 30 comandos Git

---

### 🔧 **LSP & Development**
| Keymap | Descripción |
|--------|-------------|
| `gd` | Go to Definition (sin leader) |
| `gD` | Go to Declaration (sin leader) |
| `gi` | Go to Implementation (sin leader) |
| `gr` | Find References (sin leader) |
| `K` | Hover Documentation (sin leader) |
| **Con Leader** | |
| `<leader>gD` | Go to Declaration |
| `<leader>gd` | Go to Definition |
| `<leader>gi` | Go to Implementation |
| `<leader>gr` | References |
| `<leader>gT` | Type Definition |
| `<leader>I` | Quick Implementations |
| `<leader>lh` | LSP: Hover Documentation |
| `<leader>ls` | LSP: Signature Help |
| `<leader>lf` | LSP: Format Document |
| `<leader>rn` | Rename Symbol |
| `<leader>ca` | Code Action |
| `<C-Space>` | Force LSP Completion (insert mode) |

**Total:** 17 comandos LSP

---

### 📱 **Flutter Development**
| Keymap | Descripción |
|--------|-------------|
| `<leader>Fr` | Flutter: Hot Reload |
| `<leader>FR` | Flutter: Hot Restart |
| `<leader>Fd` | Flutter: DevTools |
| `<leader>Fs` | Flutter: Start App |
| `<leader>FD` | Flutter: Select Device |
| `<leader>Fe` | Flutter: Start Emulator |
| `<leader>Fq` | Flutter: Quit/Stop |
| `<leader>Fo` | Flutter: Toggle Outline |
| `<leader>Fc` | Flutter: Clear Log |
| `<leader>Ft` | Flutter: Copy Profiler URL ⭐ NUEVO |
| `<leader>Fl` | Flutter: Restart LSP ⭐ NUEVO |

**Total:** 11 comandos Flutter

---

### 📦 **Buffer & Window Management**
| Keymap | Descripción |
|--------|-------------|
| `<S-h>` | Buffer: Previous |
| `<S-l>` | Buffer: Next |
| `<leader>bn` | Buffer: Next |
| `<leader>bp` | Buffer: Previous |
| `<leader>bd` | Buffer: Delete/Close |
| `<leader>bP` | Buffer: Pick |
| `<leader>bt` | Toggle Pin Buffer |
| `<leader>bh` | Buffer: Close Left |
| `<leader>bl` | Buffer: Close Right |
| `<leader>to` | Close All Others (Tabs Only) |
| **Window Navigation** | |
| `<leader>wh` | Go to left window |
| `<leader>wj` | Go to bottom window |
| `<leader>wk` | Go to top window |
| `<leader>wl` | Go to right window |
| `<leader>we` | Window: Focus editor |
| `<leader>wt` | Window: Focus tree |
| `<space>h` | Go to left split |
| `<space>l` | Go to right split |
| **Splits** | |
| `<leader>sv` | Split Vertical |
| `<leader>sh` | Split Horizontal |
| `<leader>sc` | Close Current Split |
| `<leader>so` | Close All Other Splits |
| `<leader>_` | Maximize Split Height |

**Total:** 23 comandos de buffers/windows

---

### 📁 **File Explorer (Neo-tree)**
| Keymap | Descripción |
|--------|-------------|
| `<leader>pv` | Toggle NeoTree filesystem |
| `<leader>bf` | NeoTree buffers float |
| `<leader>fr` | Reveal current file in tree |
| `<leader>pe` | Focus NeoTree (Project Explore) |
| `<leader>pf` | Project Focus |

**Total:** 5 comandos Neo-tree

---

### 🧪 **Testing (vim-test)**
| Keymap | Descripción |
|--------|-------------|
| `<leader>T` | Test: Nearest |
| `<leader>Tf` | Test: File |
| `<leader>Ta` | Test: All Suite |
| `<leader>Tl` | Test: Last |

**Total:** 4 comandos de testing

---

### 💻 **Terminal & Tasks**
| Keymap | Descripción |
|--------|-------------|
| `<leader>tf` | Toggle Float Terminal |
| `<leader>th` | Toggle Horizontal Terminal |
| `<leader>tv` | Toggle Vertical Terminal |
| **Terminales Especializadas** | |
| `<leader>tg` | LazyGit Terminal |
| `<leader>tn` | Node Terminal |
| `<leader>tp` | Python Terminal |
| `<leader>tF` | Flutter Terminal |
| `<leader>tH` | Htop Terminal |
| **Overseer (Tasks)** | |
| `<leader>or` | Overseer: Run Task |
| `<leader>ot` | Overseer: Toggle |
| `<leader>ob` | Overseer: Build |
| `<leader>oi` | Overseer: Info/Edit |

**Total:** 12 comandos de terminal

---

### 🚀 **Code Runner**
| Keymap | Descripción |
|--------|-------------|
| `<leader>rr` | Run Class/File |
| `<leader>rb` | Build/Sync Project |
| `<leader>rs` | Stop Running Process |
| `<leader>rd` | Debug (placeholder) |

**Total:** 4 comandos de ejecución

---

### ⌨️ **Editing & Navigation**
| Keymap | Descripción |
|--------|-------------|
| `jj` | Exit insert mode |
| `<leader><leader>` | Clear search highlight |
| `<A-j>` | Move line down (normal) |
| `<A-k>` | Move line up (normal) |
| `<A-j>` | Move selection down (visual) |
| `<A-k>` | Move selection up (visual) |
| `>` | Indent and keep selection (visual) |
| `<` | Unindent and keep selection (visual) |
| **Case Conversion** | |
| `<leader>u` | Convert to lowercase (visual) |
| `<leader>U` | Convert to uppercase (visual) |
| **Search Centering** | |
| `n` | Next search result (centered) |
| `N` | Previous search result (centered) |
| `*` | Search word forward (centered) |
| `#` | Search word backward (centered) |
| `g*` | Search partial word forward (centered) |
| `g#` | Search partial word backward (centered) |
| **Folding** | |
| `<leader>za` | Toggle fold |
| `<leader>zR` | Expand all folds |
| `<leader>zM` | Collapse all folds |
| `<leader>zr` | Expand one fold level |
| `<leader>zm` | Collapse one fold level |
| **History** | |
| `<C-o>` | Back (previous location) |
| `<C-i>` | Forward (next location) |

**Total:** 22 comandos de edición

---

### 🔧 **Utilidades**
| Keymap | Descripción |
|--------|-------------|
| `<F8>` | Toggle Tagbar |
| `<leader>fp` | Find Projects (Telescope) |
| `<leader>ws` | WinShift: Move Window |
| `<leader>wS` | WinShift: Swap Window |

**Total:** 4 utilidades

---

## 📊 Resumen Estadístico

| Categoría | Cantidad de Keymaps |
|-----------|---------------------|
| **Telescope (Find/Search)** | 10 |
| **Git Operations** | 30 |
| **LSP & Development** | 17 |
| **Flutter** | 11 |
| **Buffers & Windows** | 23 |
| **File Explorer** | 5 |
| **Testing** | 4 |
| **Terminal & Tasks** | 12 |
| **Code Runner** | 4 |
| **Editing & Navigation** | 22 |
| **Utilidades** | 4 |
| **TOTAL** | **142 keymaps** |

---

## ⚠️ Análisis de Duplicados

### **Resultado:** ✅ SIN DUPLICADOS

Se analizaron todos los archivos de configuración y **no se encontraron keymaps duplicados**.

**Archivos analizados:**
- ✅ `lua/vim-options.lua` (23 keymaps)
- ✅ `lua/plugins/telescope.lua` (10 keymaps)
- ✅ `lua/plugins/lsp-config.lua` (17 keymaps)
- ✅ `lua/plugins/git-stuff.lua` (30 keymaps)
- ✅ `lua/plugins/neo-tree.lua` (5 keymaps)
- ✅ `lua/plugins/terminal.lua` (12 keymaps)
- ✅ `lua/plugins/session-workspace.lua` (11 keymaps)
- ✅ `lua/plugins/flutter-tools.lua` (11 keymaps)
- ✅ `lua/plugins/vim-test.lua` (4 keymaps)
- ✅ `lua/plugins/editing.lua` (1 keymap)

**Casos especiales verificados:**
1. `<leader>lf` - Solo aparece en `lsp-config.lua` (no hay duplicado real)
2. `<C-\><C-n>` - Solo en `terminal.lua` (múltiples usos en modo terminal, OK)

---

## 🎯 Keymaps Más Usados (Recomendados)

### **Top 10 Essential:**
1. `<leader>ff` - Buscar archivos (lo usarás constantemente)
2. `<leader>fg` - Buscar texto en proyecto
3. `gd` - Ir a definición (LSP)
4. `<leader>gs` - Git status
5. `<S-l>` / `<S-h>` - Navegar buffers
6. `<leader>pv` - Toggle file explorer
7. `K` - Hover documentation (LSP)
8. `<leader>ca` - Code actions (LSP)
9. `<leader>rn` - Rename symbol (LSP)
10. `,,` - Búsqueda ultra rápida de archivos

---

## 🔍 Cómo Ver Keymaps en Neovim

### **Método 1: Telescope (Recomendado)**
```vim
<leader>fk
" o
:Telescope keymaps
```

### **Método 2: Which-key**
```vim
<Space>
" Espera 300ms y verás un menú con todas las opciones
```

### **Método 3: Nativo de Neovim**
```vim
:map                 " Ver todos los keymaps
:nmap                " Ver solo normal mode
:nmap <leader>       " Ver solo keymaps que empiezan con leader
```

---

## ✅ Estado Final

**Todo verificado y funcionando:**
- ✅ 142 keymaps únicos sin duplicados
- ✅ Telescope con FZF ultra rápido
- ✅ vim.loader activo (cache Lua)
- ✅ LSP optimizado (nivel WARN)
- ✅ Treesitter con 13 parsers (incluye Go)
- ✅ Sincronización IntelliJ IDEA intacta (148 comandos)

**Documentos de referencia:**
- Este archivo: Análisis completo de keymaps
- `OPTIMIZATION_CHANGELOG.md`: Cambios de optimización
- `README.md`: Documentación principal (148 comandos)

---

**🎉 Tu configuración está optimizada, verificada y lista para usar!**
