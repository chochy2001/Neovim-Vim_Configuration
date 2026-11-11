# Complete Shortcuts & Workflow Guide

Leader key: **Space**

Leader prefixes and the chords listed in `.ideavimrc` match Neovim where IntelliJ has an `<Action>(id)`. AI (`<leader>a*`) and CopilotChat (`<leader>c*`) are Neovim-only. Reload IdeaVim with `:source ~/.ideavimrc`.

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
| `S` | Normal/Operator | Flash: treesitter select (visual `S` is surround) |

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
| `<leader>we` | Normal (neo-tree buffer) | Focus editor window |
| `<leader>wt` | Normal (neo-tree buffer) | Focus tree window |

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
| `<leader>gsu` | Normal | Toggle stage of hunk under cursor (same action as gsa) |
| `<leader>gsp` | Normal | Preview hunk |
| `<leader>gsb` | Normal | Reset entire buffer |
| `ih` | Operator/Visual | Select hunk (text object) |

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
| `gd` | Normal | Go to definition (configured on LspAttach) |
| `gi` | Normal | Go to implementation (configured on LspAttach) |
| `go` | Normal | Go to type definition |
| `gs` | Normal | Signature help / parameter info |
| `gR` | Normal | References in Trouble |
| `K` | Normal | Hover documentation |

### Actions (with leader)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal/Visual | Code action |
| `<leader>fm` | Normal | Format (one attached none-ls client with an applicable source, otherwise one attached LSP) |
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
| `<leader>tv` | Normal | Terminal split on the right (`2<leader>tv` = terminal 2) |
| `<leader>th` | Normal | Terminal split at the bottom (`3<leader>th` = terminal 3) |
| `<leader>ta` | Normal | Show / hide all terminals |
| `<leader>tl` | Normal | Pick a terminal from a list |
| `<leader>tg` | Normal | LazyGit terminal |
| `<leader>tn` | Normal | Node REPL |
| `<leader>tp` | Normal | Python REPL |
| `<leader>tu` | Normal | System monitor (htop/tasklist) |
| `<leader>tF` | Normal | Flutter terminal |
| `<leader>tm` | Normal | Markdown: rendered (headings, tables, code) / raw |
| `jj` | Terminal | Exit terminal mode |
| `<C-[><C-[>` | Terminal | Exit terminal mode (alternative) |

tmux-style workflow: `<leader>tv` opens a shell on the right, `2<leader>th` a second one at the bottom. In a terminal, `jj` (or `Ctrl+[` twice) returns to Normal mode; then `Ctrl+h/j/k/l` moves between windows like tmux panes and `i` types into the terminal again. `<leader>ta` hides every terminal and brings them back with their processes still running.

### Code Runner

| Key | Mode | Action |
|-----|------|--------|
| `<leader>r` | Normal | Run code |
| `<leader>rf` | Normal | Run file |
| `<leader>rft` | Normal | Run file in new tab |
| `<leader>rp` | Normal | Run project task (Overseer) |
| `<leader>rc` | Normal | Close runner |
| `<leader>rs` | Normal | Stop current terminal job or choose an active terminal |
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

## AI Assistants (terminal CLIs, your subscriptions, no API keys)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>aa` | Normal | opencode terminal |
| `<leader>ax` | Normal | codex terminal |
| `<leader>ac` | Normal | claude terminal |
| `<leader>ag` | Normal | gemini terminal |
| `<leader>ak` | Normal | grok terminal |
| `<leader>ap` | Normal | copilot CLI terminal |
| `<leader>am` | Normal | muse terminal |
| `<leader>au` | Normal | cursor agent terminal (`cursor-agent`) |
| `<leader>an` | Normal | antigravity terminal (`agy`) |
| `<leader>ai` | Normal | kimi terminal |
| `<leader>as` | Visual | Send the selection to an agent with an instruction (picker) |

Workflow: select code → `<leader>as` → pick agent → type what to change (for example "refactor this and add tests"). The file is saved, and the agent opens on the right, in the repository root (where it reads `AGENTS.md`), already working on a prompt with your instruction, the file and line range, and the selected code. When it saves, the file reloads in your window; review it with `<leader>gsp` or `<leader>gdo`.

Every agent starts this way except kimi, which has no flag for an initial prompt, and Windows npm shims (`.cmd`), which cannot pass multi-line text: there the CLI opens and the prompt is copied to the clipboard and register a, so paste it, review and submit. Missing CLIs show their install command instead of failing.

Files changed on disk by an agent reload automatically, even while Neovim keeps focus: every open file is watched (`lua/external-changes.lua`), with `checktime` on focus, terminal leave, buffer switch and CursorHold as a fallback. A buffer with unsaved edits is never overwritten: you get a warning, then `:e!` takes the disk version and `:w` keeps yours.

### herdr + Neovim + agents (outside Neovim)

Layout: Neovim in one herdr pane to read and review code, one agent per pane (`opencode`, `codex`, `claude`, `agy`, `cursor-agent`, `muse`, `kimi`) editing the same repo. Every agent reads `AGENTS.md` (Claude through `CLAUDE.md`, Gemini/Antigravity through `GEMINI.md`). Grok only loads project rules in a workspace you trusted in grok.

- The agent saves a file and Neovim shows it within ~0.1 s, no focus change needed. Review with `<leader>gsp` (preview hunk) or `<leader>gdo` (diffview), undo a hunk with `<leader>gsr`.
- herdr's prefix is `Ctrl+b`, so Neovim's `Ctrl+b` (page up, completion docs up) does not reach Neovim while herdr is in front. Use `Ctrl+u` to scroll up, send the prefix through herdr, or set another `prefix` in `~/.config/herdr/config.toml` and run `herdr server reload-config`.
- herdr forwards focus events, so switching to the Neovim pane also runs `checktime`. The font comes from the terminal around herdr (README, Iconos).

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

These only work on the CAPDESIS dashboard (`nvim` with no file):

| Key | Action |
|-----|--------|
| `f` | Find files |
| `g` | Live grep |
| `r` | Recent files |
| `e` | File explorer |
| `a` | AI (opencode) |
| `m` | Mason |
| `l` | Lazy |
| `q` | Quit |

---

## Prefix Reference

| Prefix | Category |
|--------|----------|
| `<leader>f*` | Find/search |
| `<leader>a*` | AI assistants |
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
| `:checkhealth vim.lsp` | Active LSP servers |
| `:LspRestartDart` | Restart Dart LSP |
| `:LspStatus` | Check LSP status |
| `:CheckFormatters` | List available formatters |
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
1. `gd` to jump to definition, `gR` to find all references
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
