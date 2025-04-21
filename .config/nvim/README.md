# 🧠 Mi configuración de Neovim en Lua

Este es mi entorno personalizado para trabajar con Neovim usando Lua como lenguaje de configuración. Incluye soporte para varios lenguajes de programación (Dart, Go, Kotlin, Swift, Java), explorador de archivos, Git integrado, terminal flotante, búsqueda avanzada con Telescope, temas, completado automático, LSP, y mucho más.

## 🚀 Requisitos

- [Neovim v0.8.0+](https://neovim.io/)
- [Node.js](https://nodejs.org/) (para algunos plugins como markdown-preview)
- [Yarn](https://classic.yarnpkg.com/lang/en/) (para markdown-preview)
- Git

## 🛠 Instalación

```bash
git clone https://github.com/chochy2001/neovim_configuration.git ~/.config/nvim
```

Al abrir `nvim`, Packer se instalará automáticamente si no está presente y sincronizará todos los plugins. Luego de la instalación, cierra y vuelve a abrir Neovim.

## 📁 Estructura de archivos

```text
~/.config/nvim
├── init.lua           # Archivo principal que carga todo
└── lua
    ├── plugins.lua    # Lista y configuración de plugins usando Packer
    ├── settings.lua   # Opciones generales de Neovim
    ├── keymaps.lua    # Atajos de teclado personalizados
    └── lsp.lua        # Configuración de LSP (Lenguajes soportados)
```

## 🧩 Plugins destacados

- **Packer.nvim** – Gestor de plugins
- **nvim-cmp** + **LuaSnip** – Completado automático
- **LSP Config + Mason** – LSP para Go, Dart, Kotlin, Swift, etc.
- **nvim-tree** – Explorador de archivos
- **Telescope** – Búsqueda avanzada de archivos y fuzzy finder
- **Floaterm** – Terminal flotante integrada
- **Fugitive** – Git desde Neovim
- **Startify** – Página de inicio personalizada
- **Markdown Preview** – Vista previa de Markdown en navegador
- **Airline** – Barra de estado
- **Temas** – Dracula, OneDark, Molokai, Solarized, Gruvbox

## ⌨️ Atajos de teclado útiles

| Combinación           | Acción                                     |
| --------------------- | ------------------------------------------ |
| `jj` / `jk`           | Salir del modo inserción                   |
| `<C-p>`               | Buscar archivos del repo con Telescope     |
| `<leader>fb`          | Abrir explorador de archivos con Telescope |
| `<leader>t`           | Abrir/cerrar la terminal flotante          |
| `<leader>bn / bp`     | Siguiente/anterior buffer                  |
| `<leader>gl/gc/ga/gs` | Comandos de Git: log, commit, add, status  |
| `<leader>gps/gpl`     | Git push / pull                            |
| `<leader>pi / pc`     | Instalar / limpiar plugins con Plug        |
| `<leader>st`          | Mostrar Startify                           |
| `Fjson`               | Ejecutar script para formatear JSON        |

> Nota: `<leader>` es la tecla `espacio`.

## 🌈 Temas de colores

Para cambiar el tema, edita `settings.lua` y cambia la línea:

```lua
vim.cmd([[colorscheme dracula]])
```

Puedes usar cualquiera de los siguientes:

- `dracula`
- `onedark`
- `gruvbox`
- `molokai`
- `solarized`

## 🧠 LSP Integrado

Lenguajes soportados actualmente:

- Go (`gopls`)
- Dart (`dartls`)
- Kotlin (`kotlin_language_server`)
- Swift (`sourcekit`)
- Java (con `vim-javacomplete2`)
- Flutter (`flutter-tools`)

LSP se configura automáticamente usando `mason.nvim`.

## 🗒 Markdown Preview

Para activar la vista previa:

```vim
:MarkdownPreview
```

Recuerda tener instalado `yarn`.

## 🤖 Autocompletado

Con `nvim-cmp`, puedes usar:

- `<C-Space>` para sugerencias
- `<CR>` para aceptar

## ⚙️ Personalización

Puedes personalizar tus atajos y configuraciones modificando los archivos:

- `keymaps.lua` para mappings
- `settings.lua` para opciones
- `plugins.lua` para añadir o quitar plugins

## 🧼 Buenas prácticas

- Usa `:PackerSync` tras modificar `plugins.lua`
- Usa `:checkhealth` para diagnosticar errores
- Usa `:help <comando>` para ayuda dentro de Neovim

---

¡Disfruta programar con un Neovim turbo cargado! 🚀
