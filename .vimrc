call plug#begin('~/.vim/plugged')

Plug 'roxma/vim-hug-neovim-rpc'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'ycm-core/YouCompleteMe'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dart-lang/dart-vim-plugin'
Plug 'natebosch/vim-lsc'
Plug 'preservim/tagbar'
Plug 'dense-analysis/ale'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'

call plug#end()

highlight Comment ctermfg=Gray guifg=#6272a4

let g:python3_host_prog = '/Library/Frameworks/Python.framework/Versions/3.11/bin/python3'

let g:deoplete#enable_at_startup = 1

" Configuración para Go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Configuración para Dart
let g:lsc_auto_map = v:true
let g:dart_format_on_save = 1

"Numero de lineas para el resaltado de sintaxis
set synmaxcol=200

" Mantiene al menos 8 líneas visibles por encima y por debajo del cursor
set scrolloff=8

" Muestra el número de línea absoluto
set number

" Muestra el número de línea relativo al cursor
set relativenumber

" Establece el ancho de tabulación y el ancho de tabulación suave en 4 espacios
set tabstop=4 softtabstop=4

" Establece el ancho de desplazamiento (indentación) en 4 espacios
set shiftwidth=4

" Convierte las tabulaciones en espacios
set expandtab

" Habilita la indentación inteligente
set smartindent

" Habilita el resaltado de sintaxis en Vim
syntax enable

" Establece Dracula como el esquema de colores actual
"colorscheme dracula
"colorscheme molokai
colorscheme onedark
"colorscheme gruvbox


" Habilita estilos de texto opcionales para Dracula
"let g:dracula_italic = 1 " Activa el texto en cursiva
"let g:dracula_bold = 1 " Activa el texto en negrita
"let g:dracula_underline = 1 " Activa el texto subrayado
"let g:dracula_undercurl = 1 " Activa el texto subrayado ondulado
"let g:dracula_inverse = 1 " Activa el texto inverso
"let g:dracula_colorterm = 1 " Habilita colores en terminales compatibles

let mapleader = " "
nnoremap <leader>pv :Vex<CR>
nnoremap <leader>ph :Hex<CR>

" I use neovim, btw
nnoremap <Leader><CR> :so ~/.vimrc<CR>
"Busca archivos en el directorio de git actual y subdirectorios
nnoremap <C-p> :GFiles<CR>
" Buscar archivos en el directorio actual y subdirectorios
"nnoremap <C-p> :Files<CR>
" I don't know if I love these remaps yet.  I am considering doing
" <leader>c(k|j|o)
nnoremap <C-k> :cnext<CR>
nnoremap <C-j> :cprev<CR>
nnoremap <C-E> :copen<CR>

" Scripts
command! Fjson :source ~/.vim/scripts/formatear_json.vim
