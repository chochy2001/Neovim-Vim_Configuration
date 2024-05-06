# English Version
# Vim Commands and Configuration Guide

This document explains the commands and configurations used in the provided `.vimrc` file, as well as some additional Vim commands.

## .vimrc File Configuration

### Plugins

The `.vimrc` file uses the `vim-plug` plugin manager to install and manage the following plugins:

- `mhinz/vim-startify`: Provides a customizable start screen for Vim.
- `dart-lang/dart-vim-plugin`: Plugin for the Dart programming language.
- `thosakwe/vim-flutter`: Plugin for the Flutter framework.
- `kien/ctrlp.vim`: File search and navigation.
- `voldikss/vim-floaterm`: Floating terminal for Vim.
- `roxma/vim-hug-neovim-rpc`: Support for communication between Vim and Neovim.
- `junegunn/fzf` and `junegunn/fzf.vim`: File search and navigation using fuzzy finding.
- `fatih/vim-go`: Plugin for the Go programming language.
- `jiangmiao/auto-pairs`: Automatic insertion of matching pairs.
- `preservim/nerdtree`: File explorer in a tree structure.
- `vim-airline/vim-airline` and `vim-airline/vim-airline-themes`: Customizable status bar and themes.
- `tpope/vim-fugitive`, `tpope/vim-commentary`, `tpope/vim-surround`, and `tpope/vim-sensible`: Tim Pope's plugins for additional functionality.
- `sheerun/vim-polyglot`: Support for multiple programming languages.
- `github/copilot.vim`: Integration with GitHub Copilot.
- `natebosch/vim-lsc`: Support for language server.
- `preservim/tagbar`: Sidebar for displaying tags.
- `dense-analysis/ale`: Linting and error correction.
- Various color scheme plugins: `dracula/vim`, `tomasr/molokai`, `altercation/vim-colors-solarized`, `joshdick/onedark.vim`, `morhetz/gruvbox`.
- `luochen1990/rainbow`: Rainbow parentheses.
- `airblade/vim-gitgutter`: Git change indicators in the left margin.
- `easymotion/vim-easymotion`: Quick navigation within a file.
- `scrooloose/nerdcommenter`: Commenting and uncommenting code.
- `Yggdroot/indentLine`: Visual indentation lines.

### General Configurations

- `let mapleader = " "`: Sets the leader key as the space bar.
- `set synmaxcol=200`: Limits syntax highlighting to 200 columns.
- `set scrolloff=8`: Keeps at least 8 lines visible above and below the cursor when scrolling.
- `set number`: Displays absolute line numbers.
- `set relativenumber`: Displays line numbers relative to the cursor.
- `set tabstop=4 softtabstop=4`: Sets the tab width and soft tab width to 4 spaces.
- `set shiftwidth=4`: Sets the indentation width to 4 spaces.
- `set expandtab`: Converts tabs to spaces.
- `set smartindent`: Enables smart indentation.
- `set termguicolors`: Enables true colors in the terminal.
- `syntax enable`: Enables syntax highlighting in Vim.
- `colorscheme dracula`: Sets the Dracula color scheme.

### Key Mappings

- `nnoremap <leader>pv :Vex<CR>`: Maps `<leader>pv` to open the file explorer with `:Vex`.
- `nnoremap <leader>ph :Hex<CR>`: Maps `<leader>ph` to open the file explorer with `:Hex`.
- `nnoremap <Leader><CR> :so ~/.vimrc<CR>`: Maps `<leader><Enter>` to reload the `.vimrc` file.
- `nnoremap <C-p> :GFiles<CR>`: Maps `<Control>p` to search for files in the current Git directory and subdirectories.
- `nnoremap <C-k> :cnext<CR>`, `nnoremap <C-j> :cprev<CR>`, `nnoremap <C-E> :copen<CR>`: Mappings for navigating the error list.

- Mappings for NERDTree:
  - `nnoremap <leader>n :NERDTreeFocus<CR>`: Focuses NERDTree.
  - `nnoremap <C-n> :NERDTree<CR>`: Opens NERDTree.
  - `nnoremap <C-t> :NERDTreeToggle<CR>`: Toggles NERDTree visibility.
  - `nnoremap <C-f> :NERDTreeFind<CR>`: Finds the current file in NERDTree.

- Mappings for navigating between buffers:
  - `nnoremap <leader>bn :bn<CR>`: Go to the next buffer.
  - `nnoremap <leader>bp :bp<CR>`: Go to the previous buffer.

- Mappings for Git:
  - `nnoremap <leader>gl :Git log<CR>`: Displays the Git log.
  - `nnoremap <leader>gc :Git commit<CR>`: Performs a Git commit.
  - `nnoremap <leader>ga :Git add %<CR>`: Adds the current file to the Git staging area.
  - `nnoremap <leader>gs :Git status<CR>`: Displays the current Git status.
  - `nnoremap <leader>gps :Git push<CR>`: Performs a Git push.
  - `nnoremap <leader>gpl :Git pull<CR>`: Performs a Git pull.

- `nnoremap <leader>pi :PlugInstall<CR>`: Installs the plugins specified in the `.vimrc` file.
- `nnoremap <silent> <leader>t :FloatermToggle<CR>`: Toggles the visibility of the floating terminal.
- `nnoremap <leader>st :Startify<CR>`: Opens the Startify start screen.
- `command! Fjson :source ~/.vim/scripts/formatear_json.vim`: Defines a custom command `Fjson` to format JSON.

## Additional Vim Commands

- `:set scrolloff=8`: Makes scrolling down smooth.
- `:set number`: Displays line numbers.
- `:set relativenumber`: Displays line numbers relative to the cursor.
- `:set norelativenumber`: Disables relative line numbers.
- `:Vex`: Opens the file explorer in a vertical window.
- `m<uppercase letter>`: Marks the current position with an uppercase letter.
- `'<uppercase letter>`: Jumps to the mark set with the corresponding uppercase letter.
- `:GFiles`: Searches for files in the current Git directory and subdirectories.
- `<Control>n` and `<Control>p`: Navigates through dropdown menu options.
- `<Control>w w`: Jumps to the next split in order.
- `<Control>w h/j/k/l`: Moves the cursor to the left/bottom/top/right split.
- `/searchterm`: Searches for and highlights matches of "searchterm".
- `:set hls ic`: Highlights search matches.
- `:set nohls`: Disables search highlighting.
- `/err.*or<CR>`: Searches using a regular expression.
- `:s/foo/baz<CR>`: Replaces "foo" with "baz" on the current line.
- `:s/foo/baz/g<CR>`: Replaces all occurrences of "foo" with "baz" on the current line.
- `:s/foo/baz/gc<CR>`: Replaces "foo" with "baz" on the current line, asking for confirmation.
- `:%s/foo/bar/gc`: Replaces "foo" with "bar" throughout the file, asking for confirmation.
- `{` and `}`: Jumps backward and forward to empty lines.
- `0`: Goes to the beginning of the line in normal mode.
- `$`: Goes to the end of the line in normal mode.
- `_`: Goes to the first non-blank character of the line.
- `vi(` and `ci(`: Selects and changes the content inside parentheses.
- `:e#`: Returns to the previous file.
- `:bp` and `:bn`: Navigates between open buffers.
- `:ls` or `:buffers`: Displays the list of open buffers.
- `<Control>v`: Selects multiple lines for editing.
- `<Control>a` and `<Control>x`: Increments and decrements the number under the cursor.
- `g<Control>a`: Increments the selected numbers sequentially.
- `o` and `O`: Changes the selection up or down in visual selection mode.
- `W`: Jumps by whitespace.
- `:4`: Goes to line 4 of the file.
- `gcc`: Comments or uncomments the current line.
- `gc`: Comments or uncomments the visual selection.
- `gc<motion>`: Comments based on the specified motion (e.g., `gc3j` comments the next three lines).
- `S(` and `cs"'`: Surrounds the selection with parentheses and changes double quotes to single quotes.
- `<Control>w` (in insert mode): Deletes the last word written.
- `<Control>u` (in insert mode): Deletes the entire current line.
- `<Space>t`: Opens a terminal.
- `<Control>d`: Closes the terminal.
- `:PlugClean`: Removes unused plugins.
- `U`: Undoes changes.
- `<Control>r`: Redoes changes.

# Versión en español
# Guía de comandos y configuración de Vim

Este documento explica los comandos y configuraciones utilizados en el archivo `.vimrc` proporcionado, así como algunos comandos adicionales de Vim.

## Configuración del archivo .vimrc

### Plugins

El archivo `.vimrc` utiliza el administrador de plugins `vim-plug` para instalar y gestionar los siguientes plugins:

- `mhinz/vim-startify`: Proporciona una pantalla de inicio personalizable para Vim.
- `dart-lang/dart-vim-plugin`: Plugin para el lenguaje de programación Dart.
- `thosakwe/vim-flutter`: Plugin para el framework Flutter.
- `kien/ctrlp.vim`: Búsqueda y navegación de archivos.
- `voldikss/vim-floaterm`: Terminal flotante para Vim.
- `roxma/vim-hug-neovim-rpc`: Soporte para comunicación entre Vim y Neovim.
- `junegunn/fzf` y `junegunn/fzf.vim`: Búsqueda y navegación de archivos mediante fuzzy finding.
- `fatih/vim-go`: Plugin para el lenguaje de programación Go.
- `jiangmiao/auto-pairs`: Inserción automática de pares de caracteres.
- `preservim/nerdtree`: Explorador de archivos en forma de árbol.
- `vim-airline/vim-airline` y `vim-airline/vim-airline-themes`: Barra de estado y temas personalizados.
- `tpope/vim-fugitive`, `tpope/vim-commentary`, `tpope/vim-surround` y `tpope/vim-sensible`: Plugins de Tim Pope para funcionalidades adicionales.
- `sheerun/vim-polyglot`: Soporte para múltiples lenguajes de programación.
- `github/copilot.vim`: Integración con GitHub Copilot.
- `natebosch/vim-lsc`: Soporte para servidor de lenguaje.
- `preservim/tagbar`: Barra lateral para mostrar etiquetas.
- `dense-analysis/ale`: Linting y corrección de errores.
- Varios plugins para esquemas de colores: `dracula/vim`, `tomasr/molokai`, `altercation/vim-colors-solarized`, `joshdick/onedark.vim`, `morhetz/gruvbox`.
- `luochen1990/rainbow`: Paréntesis de colores.
- `airblade/vim-gitgutter`: Indicadores de cambios de Git en el margen izquierdo.
- `easymotion/vim-easymotion`: Navegación rápida dentro del archivo.
- `scrooloose/nerdcommenter`: Comentado y descomentado de código.
- `Yggdroot/indentLine`: Líneas de indentación visual.

### Configuraciones generales

- `let mapleader = " "`: Establece la tecla líder como la barra espaciadora.
- `set synmaxcol=200`: Limita el resaltado de sintaxis a 200 columnas.
- `set scrolloff=8`: Mantiene al menos 8 líneas visibles por encima y por debajo del cursor al desplazarse.
- `set number`: Muestra el número de línea absoluto.
- `set relativenumber`: Muestra el número de línea relativo al cursor.
- `set tabstop=4 softtabstop=4`: Establece el ancho de tabulación y el ancho de tabulación suave en 4 espacios.
- `set shiftwidth=4`: Establece el ancho de desplazamiento (indentación) en 4 espacios.
- `set expandtab`: Convierte las tabulaciones en espacios.
- `set smartindent`: Habilita la indentación inteligente.
- `set termguicolors`: Habilita colores verdaderos en la terminal.
- `syntax enable`: Habilita el resaltado de sintaxis en Vim.
- `colorscheme dracula`: Establece el esquema de colores Dracula.

### Mapeos de teclas

- `nnoremap <leader>pv :Vex<CR>`: Mapea `<líder>pv` para abrir el explorador de archivos `:Vex`.
- `nnoremap <leader>ph :Hex<CR>`: Mapea `<líder>ph` para abrir el explorador de archivos `:Hex`.
- `nnoremap <Leader><CR> :so ~/.vimrc<CR>`: Mapea `<líder><Enter>` para recargar el archivo `.vimrc`.
- `nnoremap <C-p> :GFiles<CR>`: Mapea `<Control>p` para buscar archivos en el directorio de Git actual y subdirectorios.
- `nnoremap <C-k> :cnext<CR>`, `nnoremap <C-j> :cprev<CR>`, `nnoremap <C-E> :copen<CR>`: Mapeos para navegación en la lista de errores.

- Mapeos para NERDTree:
  - `nnoremap <leader>n :NERDTreeFocus<CR>`: Enfoca NERDTree.
  - `nnoremap <C-n> :NERDTree<CR>`: Abre NERDTree.
  - `nnoremap <C-t> :NERDTreeToggle<CR>`: Alterna la visibilidad de NERDTree.
  - `nnoremap <C-f> :NERDTreeFind<CR>`: Encuentra el archivo actual en NERDTree.

- Mapeos para moverse entre buffers:
  - `nnoremap <leader>bn :bn<CR>`: Ir al siguiente buffer.
  - `nnoremap <leader>bp :bp<CR>`: Ir al buffer anterior.

- Mapeos para Git:
  - `nnoremap <leader>gl :Git log<CR>`: Muestra el registro de Git.
  - `nnoremap <leader>gc :Git commit<CR>`: Realiza un commit en Git.
  - `nnoremap <leader>ga :Git add %<CR>`: Agrega el archivo actual al área de preparación de Git.
  - `nnoremap <leader>gs :Git status<CR>`: Muestra el estado actual de Git.
  - `nnoremap <leader>gps :Git push<CR>`: Realiza un push en Git.
  - `nnoremap <leader>gpl :Git pull<CR>`: Realiza un pull en Git.

- `nnoremap <leader>pi :PlugInstall<CR>`: Instala los plugins especificados en el archivo `.vimrc`.
- `nnoremap <silent> <leader>t :FloatermToggle<CR>`: Alterna la visibilidad de la terminal flotante.
- `nnoremap <leader>st :Startify<CR>`: Abre la pantalla de inicio de Startify.
- `command! Fjson :source ~/.vim/scripts/formatear_json.vim`: Define un comando personalizado `Fjson` para formatear JSON.

## Comandos adicionales de Vim

- `:set scrolloff=8`: Hace que el desplazamiento hacia abajo sea suave.
- `:set number`: Muestra los números de línea.
- `:set relativenumber`: Muestra los números de línea relativos al cursor.
- `:set norelativenumber`: Desactiva los números de línea relativos.
- `:Vex`: Abre el explorador de archivos en una ventana vertical.
- `m<letra mayúscula>`: Marca la posición actual con una letra mayúscula.
- `'<letra mayúscula>`: Salta a la marca establecida con la letra mayúscula correspondiente.
- `:GFiles`: Busca archivos en el directorio de Git actual y subdirectorios.
- `<Control>n` y `<Control>p`: Navega por las opciones de menú desplegables.
- `<Control>w w`: Salta al siguiente split en orden.
- `<Control>w h/j/k/l`: Mueve el cursor al split de la izquierda/abajo/arriba/derecha.
- `/nombreAbuscar`: Busca y resalta las coincidencias de "nombreAbuscar".
- `:set hls ic`: Resalta las coincidencias de búsqueda.
- `:set nohls`: Desactiva el resaltado de búsqueda.
- `/err.*or<CR>`: Busca utilizando una expresión regular.
- `:s/foo/baz<CR>`: Reemplaza "foo" por "baz" en la línea actual.
- `:s/foo/baz/g<CR>`: Reemplaza todas las apariciones de "foo" por "baz" en la línea actual.
- `:s/foo/baz/gc<CR>`: Reemplaza "foo" por "baz" en la línea actual, preguntando por cada aparición.
- `:%s/foo/bar/gc`: Reemplaza "foo" por "bar" en todo el archivo, preguntando por cada aparición.
- `{` y `}`: Salta hacia atrás y hacia adelante en los espacios vacíos.
- `0`: Va al principio de la línea en modo normal.
- `$`: Va al final de la línea en modo normal.
- `_`: Va al primer carácter no en blanco de la línea.
- `vi(` y `ci(`: Selecciona y cambia el contenido dentro de los paréntesis.
- `:e#`: Regresa al archivo anterior.
- `:bp` y `:bn`: Navega entre los buffers abiertos.
- `:ls` o `:buffers`: Muestra la lista de buffers abiertos.
- `<Control>v`: Selecciona múltiples líneas para edición.
- `<Control>a` y `<Control>x`: Incrementa y decrementa el número bajo el cursor.
- `g<Control>a`: Incrementa los números seleccionados de forma secuencial.
- `o` y `O`: Cambia la selección hacia arriba o hacia abajo en modo de selección visual.
- `W`: Salta por espacios en blanco.
- `:4`: Va a la línea 4 del archivo.
- `gcc`: Comenta o descomenta la línea actual.
- `gc`: Comenta o descomenta la selección visual.
- `gc<movimiento>`: Comenta según el movimiento especificado (por ejemplo, `gc3j` comenta las próximas tres líneas).
- `S(` y `cs"'`: Rodea la selección con paréntesis y cambia las comillas dobles por simples.
- `<Control>w` (en modo de inserción): Elimina la última palabra escrita.
- `<Control>u` (en modo de inserción): Elimina toda la línea actual.
- `<Espacio>t`: Abre una terminal.
- `<Control>d`: Cierra la terminal.
- `:PlugClean`: Elimina los plugins no utilizados.
- `U`: Deshace los cambios.
- `<Control>r`: Rehace los cambios.

