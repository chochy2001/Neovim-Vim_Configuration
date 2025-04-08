# 🧠 Neovim Config - Modular Keymaps & Plugin Setup

Esta configuración de Neovim está enfocada en mantener los **keymaps organizados por plugin o funcionalidad**, utilizando una estructura modular basada en Lua.

## 📁 Estructura del proyecto

```
.config/nvim/
├── init.lua               # Entrada principal
├── init.vim.bak           # Backup antiguo
├── lua/
│   ├── keymaps.lua        # Importa todos los keymaps organizados
│   ├── plugins.lua        # Plugins configurados
│   ├── settings.lua       # Opciones de Neovim
│   ├── lsp.lua            # Configuración para LSP
│   └── keymaps/
│       ├── buffers.lua
│       ├── core.lua
│       ├── explorer.lua
│       ├── git.lua
│       ├── json.lua
│       ├── plugins.lua
│       ├── startify.lua
│       ├── telescope.lua
│       └── terminal.lua
```

## ✨ Características

- 🔌 Plugins manejados por `packer.nvim`
- 📁 Keymaps divididos por contexto y plugin
- 🚀 Soporte para Telescope, Git, Startify, Floaterm, entre otros
- 🧹 `.gitignore` cuidadosamente configurado para no ignorar configuraciones importantes
- 📜 Formateo de JSON con comando `:Fjson`
- 💡 Atajos útiles como `jj` o `jk` para salir de Insert Mode

## 🛠️ Instalación de dependencias externas

Algunos plugins requieren herramientas externas:

### 📦 Ripgrep (para Telescope)

```bash
brew install ripgrep
```

O descarga desde: [https://github.com/BurntSushi/ripgrep#installation](https://github.com/BurntSushi/ripgrep#installation)

## 📌 Keymaps destacados

| Tecla           | Acción                                 |
|----------------|----------------------------------------|
| `<C-p>`         | Buscar archivos git con Telescope      |
| `<leader>pf`    | Buscar archivos normales con Telescope |
| `<leader>bn`    | Buffer siguiente                       |
| `<leader>bp`    | Buffer anterior                        |
| `<leader>t`     | Abrir terminal flotante (Floaterm)     |
| `<leader>gl`    | Git log                                |
| `<leader>gc`    | Git commit                             |
| `<leader>ga`    | Git add del archivo actual             |
| `<leader>gs`    | Git status                             |
| `<leader>gps`   | Git push                               |
| `<leader>gpl`   | Git pull                               |
| `<leader>pi`    | Instalar plugins con Packer            |
| `<leader>pc`    | Limpiar plugins con Packer             |
| `<leader>st`    | Lanzar Startify                        |
| `<leader><CR>`  | Recargar configuración                 |
| `<leader>pv`    | Abrir explorador con `:Ex`             |
| `jj` / `jk`     | Salir del modo inserción               |

## 🧠 Cómo extender esta configuración

1. Crea un nuevo archivo `.lua` dentro de `lua/keymaps/` con tus mappings personalizados.
2. Añade `require('keymaps.tu_archivo')` en `keymaps.lua`.
3. Git ya está configurado para no ignorar estos archivos gracias a un `.gitignore` bien definido.

## 🧼 Git Tips

Si copiaste esta configuración desde otro repositorio, asegúrate de no tener un `.git` dentro de `.config/nvim` (que haría que Git lo trate como un submódulo accidental). Si lo tienes, puedes arreglarlo así:

```bash
git rm --cached .config/nvim
rm -rf ~/.config/nvim/.git
```

Luego vuelve a agregar tu configuración:

```bash
git add .config/nvim
git commit -m "Corrige submódulo accidental y agrega configuración modular"
```

---

¡Listo! Ya tienes tu entorno de Neovim modular, organizado y versionado correctamente. 🚀

