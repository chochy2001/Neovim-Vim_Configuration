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

