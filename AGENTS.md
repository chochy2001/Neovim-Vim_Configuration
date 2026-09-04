# AGENTS.md — Neovim configuration

Bilingual notes for AI coding agents **and** humans working on this repo.

---

## English

### What this repo is

Cross-platform Neovim 0.12+ config (`lazy.nvim`) plus a synced `.ideavimrc` for JetBrains IDEs and a legacy `.vimrc`. Plugin specs live in `.config/nvim/lua/plugins/` (one file per concern). Core options/keymaps: `.config/nvim/lua/vim-options.lua`.

### Do / don't

- **Do** add a new plugin as a new file under `.config/nvim/lua/plugins/` (or extend an existing file in the same category). `init.lua` already does `require("lazy").setup("plugins")`.
- **Do** put user-facing keymaps in the lazy spec `keys = { ... }` table so the **first press** loads the plugin. Mapping only inside `config()` is a chicken-egg bug.
- **Do** gate every OS-specific path, binary, and `build` step with `vim.fn.has("win32")`, `vim.fn.executable(...)`, or `vim.uv.os_homedir()`.
- **Do** keep leader prefixes: `f*` find, `a*` AI CLIs, `g*` git, `fl*` flutter, `x*` diagnostics, `m*` harpoon, `b*` buffers, `w*` windows, `t*` terminal/test, `r*` run, `c*` CopilotChat, `d*` DAP, `z*` fold/zen, `q*` session, `o*` overseer/oil.
- **Don't** invent `<leader><leader>` as a finder — it is `:nohl`.
- **Don't** clone this repo *into* `~/.config/nvim`. Clone to a dedicated folder and **symlink** `.config/nvim` (Windows: Junction to `%LOCALAPPDATA%\nvim`).
- **Don't** put API keys in the config. AI CLIs (`opencode`, `codex`, `claude`, `gemini`, `grok`, `copilot`) keep their own login.
- **Don't** enable an LSP unless `vim.fn.executable(...)` is 1. Mason auto-installs a subset. **Dart LSP is owned by flutter-tools** — do not also `vim.lsp.enable("dartls")`.

### How to add a language tomorrow

1. Add the server to `lua/plugins/lsp-config.lua` behind an `executable()` guard and `table.insert(enabled, ...)`.
2. Add the Mason package name to `mason-lspconfig` `ensure_installed` **only** if Mason ships it (not Dart).
3. Add a formatter to `lua/plugins/none-ls.lua` if it is a CLI (gofmt, black, prettier, stylua, dart_format, clang-format).
4. If Mason cannot install it on Windows (needs `python3`), document `uv tool install <tool>` instead.
5. Update the language table in root `README.md` and this file.
6. Open a real file from a real repo and confirm `:lua print(table.concat(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients()), ","))`.

### How to validate (no false positives)

```bash
# Boot (must print boot-ok, no Error detected / E####)
nvim --headless "+lua local v=vim.version(); print('boot-ok '..v.major..'.'..v.minor..'.'..v.patch)" +qa

# Open a real file from each stack and inspect clients (wait ~10s):
# Dart:   repos/.../lib/main.dart          → dartls (flutter-tools), null-ls
# Go:     .../cmd/main.go                  → gopls,null-ls
# Python: .../nodo.py                      → pyright (+ null-ls if file < 50 KB)
# JS/TS:  .../astro.config.mjs             → vtsls,null-ls
# Astro:  .../Footer.astro                 → astro,null-ls (Mason copy, not project node_modules)
# JSON:   .../package.json                 → jsonls,null-ls
# C:      a temp .c file                   → clangd,null-ls
# Kotlin: .../MainActivity.kt              → kotlin_language_server
# PHP:    .../index.php                    → intelephense
```

Keymap audit: dump `nvim_get_keymap` for modes n/v/x and assert no two maps share `(mode, lhs)` with different rhs.

### Performance rules

- Default every new plugin to `event` / `cmd` / `keys` / `ft`. Never add a bare spec that loads at startup unless it is the colorscheme or `nvim-web-devicons`.
- `mason-tool-installer` `run_on_start` is the only remaining startup I/O by design (one-shot installs).
- Treesitter parsers compile via `tree-sitter-cli` (`npm i -g tree-sitter-cli`).

### Cross-platform checklist

| Concern | Pattern |
|---------|---------|
| Paths | `vim.uv.os_homedir()` + `sep = is_win and "\\" or "/"` |
| Shell (Windows) | `pwsh` else `powershell`, always set `shellcmdflag` |
| Builds | `build = executable("make") and "make" or (executable("cmake") and cmake_cmd or nil)` |
| Trash | `delete_to_trash = executable("trash") == 1` |
| Tests | vimux only when `TMUX` is set; else `neovim` strategy |

---

## Español

### Qué es este repo

Configuración de Neovim 0.12+ multiplataforma (`lazy.nvim`) más `.ideavimrc` sincronizado para IDEs JetBrains y un `.vimrc` legado. Los specs de plugins están en `.config/nvim/lua/plugins/` (un archivo por tema). Opciones y mapas núcleo: `.config/nvim/lua/vim-options.lua`.

### Hacer / no hacer

- **Sí** añade un plugin nuevo como archivo en `.config/nvim/lua/plugins/` (o extiende el archivo de la misma categoría). `init.lua` ya hace `require("lazy").setup("plugins")`.
- **Sí** pon los keymaps de usuario en la tabla `keys = { ... }` del spec de lazy para que **la primera pulsación** cargue el plugin. Mapear solo dentro de `config()` es un error de huevo-gallina.
- **Sí** protege cada ruta, binario y paso `build` específico de un SO con `vim.fn.has("win32")`, `vim.fn.executable(...)` o `vim.uv.os_homedir()`.
- **Sí** respeta los prefijos de leader: `f*` buscar, `a*` CLIs de IA, `g*` git, `fl*` flutter, `x*` diagnósticos, `m*` harpoon, `b*` buffers, `w*` ventanas, `t*` terminal/test, `r*` ejecutar, `c*` CopilotChat, `d*` DAP, `z*` plegado/zen, `q*` sesión, `o*` overseer/oil.
- **No** uses `<leader><leader>` como buscador — es `:nohl`.
- **No** clones este repo *dentro* de `~/.config/nvim`. Clónalo en una carpeta dedicada y **enlaza** `.config/nvim`.
- **No** pongas claves API en la config. Los CLIs de IA (`opencode`, `codex`, `claude`, `gemini`, `grok`, `copilot`) guardan su propio inicio de sesión.
- **No** habilites un LSP si `vim.fn.executable(...)` no es 1. Mason autoinstala un subconjunto. **El LSP de Dart lo arranca flutter-tools** — no hagas también `vim.lsp.enable("dartls")`.

### Cómo añadir un lenguaje mañana

1. Añade el servidor en `lua/plugins/lsp-config.lua` detrás de un guard `executable()` y `table.insert(enabled, ...)`.
2. Añade el nombre del paquete Mason a `ensure_installed` de `mason-lspconfig` **solo** si Mason lo publica (no Dart).
3. Añade un formateador a `lua/plugins/none-ls.lua` si es un CLI.
4. Si Mason no puede instalarlo en Windows (necesita `python3`), documenta `uv tool install <herramienta>`.
5. Actualiza la tabla de lenguajes en el `README.md` raíz y este archivo.
6. Abre un archivo real de un repo real y confirma los clientes LSP.

### Cómo validar (sin falsos positivos)

Arranque headless (debe imprimir `boot-ok`, sin `Error detected` / `E####`). Abre un archivo real de cada stack y espera ~10 s. Auditoría de keymaps: volcado de `nvim_get_keymap` y cero pares `(modo, lhs)` con rhs distinto.

### Rendimiento

Todo plugin nuevo debe tener `event` / `cmd` / `keys` / `ft`. No añadas un spec vacío que cargue al arranque salvo el colorscheme o `nvim-web-devicons`.

### Multiplataforma

Rutas con `os_homedir()` + `sep`. Shell Windows: `pwsh` o `powershell` con `shellcmdflag`. Builds: `make` si existe, si no `cmake`, si no `nil`. Tests: vimux solo con `TMUX`.
