# Complete Shortcuts & Workflow Guide

Leader key: **Space**

All keybindings are synchronized between Neovim and JetBrains IDEs (.ideavimrc).

---

## Core Editing

| Key | Mode | Action |
|-----|------|--------|
| `jj` | Insert | Exit insert mode |
| `<leader><leader>` | Normal | Clear search highlight |
| `<leader>f` | Normal | Forward (go to next location) |
| `<A-j>` | Normal | Move line down |
| `<A-k>` | Normal | Move line up |
| `<A-j>` | Visual | Move selection down |
| `<A-k>` | Visual | Move selection up |
| `>` | Visual | Indent (keep selection) |
| `<` | Visual | Unindent (keep selection) |
| `n` | Normal | Next search result (centered) |
| `N` | Normal | Previous search result (centered) |
| `*` | Normal | Search word forward (centered) |
| `#` | Normal | Search word backward (centered) |
| `g*` | Normal | Search partial word forward (centered) |
| `g#` | Normal | Search partial word backward (centered) |
| `<leader>u` | Visual | Convert to lowercase |
| `<leader>U` | Visual | Convert to uppercase |
| `gcc` | Normal | Toggle line comment |
| `gc` | Visual | Toggle comment on selection |
| `s` | Normal/Visual/Operator | Flash: jump to any character |
| `S` | Normal/Visual/Operator | Flash: treesitter select |

---

## Treesitter Text Objects

| Key | Mode | Action |
|-----|------|--------|
| `af` / `if` | Visual/Operator | Around/inside function |
| `ac` / `ic` | Visual/Operator | Around/inside class |
| `aa` / `ia` | Visual/Operator | Around/inside argument |
| `ai` / `ii` | Visual/Operator | Around/inside conditional |
| `al` / `il` | Visual/Operator | Around/inside loop |
| `]f` / `[f` | Normal | Next/previous function start |
| `]c` / `[c` | Normal | Next/previous class start |
| `]a` / `[a` | Normal | Next/previous argument |
| `]F` / `[F` | Normal | Next/previous function end |
| `<leader>sa` | Normal | Swap argument with next |
| `<leader>sA` | Normal | Swap argument with previous |

---

## Find & Search (Telescope)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep (search in files) |
| `<leader>fo` | Normal | Recent/old files |
| `<leader>fb` | Normal | Buffers |
| `<leader>fh` | Normal | Help tags |
| `<leader>fc` | Normal | Commands |
| `<leader>fk` | Normal | Keymaps |
| `<leader>fp` | Normal | Projects |
| `<leader>ps` | Normal | Workspace symbols (LSP) |
| `<leader>.` | Normal | Quick find files |
| `,,` | Normal | Quick find files (alternative) |
| `<leader>sr` | Normal/Visual | Search and replace (grug-far) |

---

## File Explorer

### Neo-tree

| Key | Mode | Action |
|-----|------|--------|
| `<leader>pv` | Normal | Toggle file tree |
| `<leader>pe` | Normal | Focus file tree |
| `<leader>pf` | Normal | Focus project tree |
| `<leader>fr` | Normal | Reveal current file in tree |
| `<leader>bf` | Normal | Show buffers (floating) |
| `<leader>we` | Normal | Focus editor window |
| `<leader>wt` | Normal | Focus tree window |

### Oil.nvim (edit directory as buffer)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>-` | Normal | Open parent directory |
| `<leader>oe` | Normal | Open file explorer |

---

## Git Operations

### Core Git

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gs` | Normal | Git status |
| `<leader>gc` | Normal | Git commit |
| `<leader>gp` | Normal | Git push |
| `<leader>gl` | Normal | Git pull |
| `<leader>gf` | Normal | Git fetch |

### Blame & History

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gb` | Normal | Git blame |
| `<leader>gbl` | Normal | Git blame line |
| `<leader>gbt` | Normal | Toggle inline blame |
| `<leader>gbr` | Normal | Git browse/branches |
| `<leader>gbc` | Normal | Branch compare (HEAD~1) |
| `<leader>gh` | Normal | Git log (oneline) |
| `<leader>ghd` | Normal | Git log (graph, all branches) |

### Diff

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gd` | Normal | Git diff split |
| `<leader>gdo` | Normal | Open diffview |
| `<leader>gdq` | Normal | Close diffview |
| `<leader>gdh` | Normal | Diff file history |
| `<leader>gdf` | Normal | Toggle diff files panel |
| `<leader>gdl` | Normal | Diff local changes |

### Hunk Navigation (Gitsigns)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gn` | Normal | Next hunk |
| `<leader>gnp` | Normal | Previous hunk |
| `<leader>gsa` | Normal | Stage hunk |
| `<leader>gsr` | Normal | Reset hunk |
| `<leader>gsu` | Normal | Undo stage hunk |
| `<leader>gsp` | Normal | Preview hunk |
| `<leader>gsb` | Normal | Reset entire buffer |
| `<leader>ih` | Operator/Visual | Select hunk (text object) |

### Conflict Resolution

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gco` | Normal | Choose ours |
| `<leader>gct` | Normal | Choose theirs |
| `<leader>gcb` | Normal | Choose both |
| `<leader>gcn` | Normal | Choose none |
| `<leader>gcp` | Normal | Previous conflict |
| `<leader>gcnn` | Normal | Next conflict |

---

## LSP & Code Intelligence

### Navigation (no leader - instant)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gi` | Normal | Go to implementation |
| `gr` | Normal | Find references |
| `go` | Normal | Go to type definition |
| `gs` | Normal | Signature help / parameter info |
| `gR` | Normal | References in Trouble |
| `K` | Normal | Hover documentation |

### Actions (with leader)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal/Visual | Code action |
| `<leader>fm` | Normal | Format document |
| `<leader>lf` | Normal | Format buffer (safe, with timeout) |
| `<C-space>` | Insert | Trigger completion |

---

## Harpoon (Quick File Marks)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ma` | Normal | Add file to harpoon |
| `<leader>mh` | Normal | Toggle harpoon UI |
| `<leader>1` - `<leader>9` | Normal | Jump to mark 1-9 |
| `<leader>mp` | Normal | Previous mark |
| `<leader>mn` | Normal | Next mark |

---

## Diagnostics & Trouble

| Key | Mode | Action |
|-----|------|--------|
| `<leader>xx` | Normal | Toggle trouble |
| `<leader>xw` | Normal | Workspace diagnostics |
| `<leader>xd` | Normal | Document diagnostics |
| `<leader>xl` | Normal | Location list |
| `<leader>xq` | Normal | Quickfix list |
| `<leader>xt` | Normal | TODOs in trouble |
| `<leader>xn` | Normal | Next error/diagnostic |
| `<leader>xp` | Normal | Previous error/diagnostic |
| `]t` | Normal | Next TODO comment |
| `[t` | Normal | Previous TODO comment |

---

## Terminal & Task Runner

### Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Float terminal (main) |
| `<leader>tg` | Normal | LazyGit terminal |
| `<leader>tn` | Normal | Node REPL |
| `<leader>tp` | Normal | Python REPL |
| `<leader>tu` | Normal | System monitor (htop/tasklist) |
| `<leader>tF` | Normal | Flutter terminal |
| `jj` | Terminal | Exit terminal mode |
| `<C-[><C-[>` | Terminal | Exit terminal mode (alternative) |

### Code Runner

| Key | Mode | Action |
|-----|------|--------|
| `<leader>r` | Normal | Run code |
| `<leader>rf` | Normal | Run file |
| `<leader>rft` | Normal | Run file in new tab |
| `<leader>rp` | Normal | Run project |
| `<leader>rc` | Normal | Close runner |
| `<leader>rs` | Normal | Stop running process |
| `<leader>rb` | Normal | Build (make) |

### Overseer (Task Runner)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>oo` | Normal | Toggle overseer |
| `<leader>or` | Normal | Run task |
| `<leader>ob` | Normal | Build |
| `<leader>oi` | Normal | Edit configurations |

---

## Copilot AI Chat

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cc` | Normal | Toggle chat window |
| `<leader>ce` | Normal/Visual | Explain selected code |
| `<leader>cr` | Normal/Visual | Review code |
| `<leader>cf` | Normal/Visual | Fix code |
| `<leader>co` | Normal/Visual | Optimize code |
| `<leader>ct` | Normal/Visual | Generate tests |

---

## Flutter Development

| Key | Mode | Action |
|-----|------|--------|
| `<leader>flr` | Normal | Hot reload |
| `<leader>fls` | Normal | Hot restart |
| `<leader>fld` | Normal | Open DevTools |
| `<leader>fla` | Normal | Run app |
| `<leader>flsd` | Normal | Select device |
| `<leader>fle` | Normal | Start emulator |
| `<leader>flq` | Normal | Quit/stop |
| `<leader>flo` | Normal | Toggle outline |
| `<leader>flc` | Normal | Clear log |
| `<leader>flp` | Normal | Copy profiler URL |
| `<leader>fll` | Normal | Restart LSP |

---

## Testing

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ten` | Normal | Test nearest |
| `<leader>tenf` | Normal | Test file |
| `<leader>tena` | Normal | Test all (suite) |
| `<leader>tenl` | Normal | Rerun last test |

---

## Debugging (DAP)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>db` | Normal | Toggle breakpoint |
| `<leader>dB` | Normal | Conditional breakpoint |
| `<leader>dc` | Normal | Continue / start debugging |
| `<leader>do` | Normal | Step over |
| `<leader>di` | Normal | Step into |
| `<leader>dO` | Normal | Step out |
| `<leader>dr` | Normal | Toggle REPL |
| `<leader>dl` | Normal | Run last debug config |
| `<leader>dx` | Normal | Terminate debug session |
| `<leader>du` | Normal | Toggle debug UI |

---

## Buffer & Tab Management

| Key | Mode | Action |
|-----|------|--------|
| `<leader>b` | Normal | Back (previous location) |
| `<leader>bn` | Normal | Next buffer |
| `<leader>bp` | Normal | Previous buffer |
| `<leader>bd` | Normal | Close buffer |
| `<leader>bl` | Normal | Close buffers to the right |
| `<leader>bh` | Normal | Close buffers to the left |
| `<leader>bP` | Normal | Pick buffer |
| `<leader>bt` | Normal | Toggle pin buffer |
| `<leader>to` | Normal | Close all other buffers |
| `<S-l>` | Normal | Next buffer (quick) |
| `<S-h>` | Normal | Previous buffer (quick) |

---

## Window & Split Management

| Key | Mode | Action |
|-----|------|--------|
| `<leader>wh` | Normal | Go to left window |
| `<leader>wj` | Normal | Go to bottom window |
| `<leader>wk` | Normal | Go to top window |
| `<leader>wl` | Normal | Go to right window |
| `<space>h` | Normal | Go to left split |
| `<space>l` | Normal | Go to right split |
| `<leader>sv` | Normal | Split vertical |
| `<leader>sh` | Normal | Split horizontal |
| `<leader>sc` | Normal | Close current split |
| `<leader>so` | Normal | Close all other splits |
| `<leader>_` | Normal | Maximize split height |
| `<leader>wm` | Normal | Move window (WinShift) |
| `<leader>ws` | Normal | Swap window |

---

## Folding (ufo.nvim - treesitter smart folding)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>za` | Normal | Toggle fold |
| `<leader>zR` | Normal | Expand all folds |
| `<leader>zM` | Normal | Collapse all folds |
| `<leader>zr` | Normal | Expand one level |
| `<leader>zm` | Normal | Collapse one level |
| `zR` | Normal | Open all folds (ufo) |
| `zM` | Normal | Close all folds (ufo) |
| `zK` | Normal | Peek folded lines or hover |
| `<leader>zz` | Normal | Zen mode (focus) |

---

## Session Management

| Key | Mode | Action |
|-----|------|--------|
| `<leader>qs` | Normal | Restore session |
| `<leader>ql` | Normal | Restore last session |
| `<leader>qd` | Normal | Don't save current session |

---

## Undo History

| Key | Mode | Action |
|-----|------|--------|
| `<leader>u` | Normal | Toggle undo tree |

---

## Dashboard Quick Actions

These only work on the dashboard startup screen:

| Key | Action |
|-----|--------|
| `1` | Find files |
| `2` | Live grep |
| `3` | Recent files |
| `4` | File explorer |
| `5` | Terminal |
| `6` | Edit config |
| `7` | Sync plugins |
| `8` | Mason (LSP installer) |

---

## Prefix Reference

| Prefix | Category |
|--------|----------|
| `<leader>f*` | Find/search |
| `<leader>g*` | Git operations |
| `<leader>fl*` | Flutter |
| `<leader>x*` | Diagnostics/trouble |
| `<leader>m*` | Marks/harpoon |
| `<leader>b*` | Buffers |
| `<leader>w*` | Windows |
| `<leader>t*` | Terminal/testing |
| `<leader>r*` | Run/debug |
| `<leader>c*` | Copilot AI |
| `<leader>d*` | Debugging (DAP) |
| `<leader>z*` | Folding/zen |
| `<leader>q*` | Sessions |
| `<leader>o*` | Overseer/oil |
| `<leader>s*` | Splits/search-replace |
| `g*` (no leader) | LSP navigation |

---

## Useful Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Plugin manager UI |
| `:Mason` | Install/manage LSP servers, formatters, debuggers |
| `:LspInfo` | Active LSP servers |
| `:LspRestartDart` | Restart Dart LSP |
| `:LspStatus` | Check LSP status |
| `:CheckFormatters` | List available formatters |
| `:TestFlutter` | Run Flutter setup test |
| `:CopilotChat` | Open AI chat |
| `:GrugFar` | Advanced find/replace |
| `:DiffviewOpen` | Open git diff viewer |
| `:Neotree` | File tree |
| `:Oil` | Directory editor |
| `:ZenMode` | Focus mode |

---

## Workflow Tips

### Quick file navigation
1. `<leader>ff` to find any file by name
2. `<leader>ma` to bookmark frequently used files
3. `<leader>1-9` to jump between bookmarks instantly
4. `<leader>fo` for recently edited files

### Git workflow
1. `<leader>gs` to check status
2. `<leader>gn` / `<leader>gnp` to navigate between changes
3. `<leader>gsa` to stage hunks selectively
4. `<leader>gc` to commit
5. `<leader>gp` to push
6. `<leader>tg` for full LazyGit TUI

### Code editing
1. `gd` to jump to definition, `gr` to find all references
2. `<leader>rn` to rename across the project
3. `<leader>ca` for quick fixes and refactoring
4. `<leader>fm` to format the file
5. `<leader>ce` to ask AI to explain code
6. `<leader>cf` to ask AI to fix issues

### Debugging diagnostics
1. `<leader>xx` to open the trouble panel
2. `<leader>xn` / `<leader>xp` to jump between errors
3. `K` to hover over symbols for documentation
4. `]t` / `[t` to navigate TODO comments
