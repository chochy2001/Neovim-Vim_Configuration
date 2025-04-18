call plug#begin('~/.vim/plugged')
Plug 'artur-shaik/vim-javacomplete2'
Plug 'vim-syntastic/syntastic'
Plug 'udalov/kotlin-vim'
Plug 'hsanson/vim-android'
Plug 'keith/swift.vim'
Plug 'akinsho/flutter-tools.nvim'
Plug 'mhinz/vim-startify'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'kien/ctrlp.vim'
Plug 'voldikss/vim-floaterm'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'ycm-core/YouCompleteMe'
Plug 'github/copilot.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'natebosch/vim-lsc'
Plug 'preservim/tagbar'
Plug 'dense-analysis/ale'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'
Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/indentLine'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'ycm-core/YouCompleteMe'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

let g:ale_fix_on_save = 1
let g:ale_linters = {
    \ 'dart': ['dartanalyzer'],
    \ 'c': ['clang'],
    \ 'cpp': ['clang'],
    \ 'java': ['javac'],
    \ 'go': ['golangci-lint']
    \ }

let g:ale_fixers = {
    \ 'dart': ['dartfmt'],
    \ 'c': ['clang-format'],
    \ 'cpp': ['clang-format'],
    \ 'java': ['google_java_format'],
    \ 'go': ['gofmt']
    \ }
let NERDTreeShowHidden=1


let g:startify_custom_header = [
    \ '   ____               __            _     ',
    \ '  / ___|__ _ _ __  __|  | ___  ___ (_) ___ ',
    \ ' | |   / _` | ''_ \/  _` |/ _ \/ __|| |/ __|',
    \ ' | |__| (_| | |_) | (_| |  __/\__ \| |\__ \',
    \ '  \____\__,_| .__/ \__,_|\___||___/|_||___/',
    \ '            |_|                          ',
    \ ]

filetype plugin indent on

let g:python3_host_prog = '/Library/Frameworks/Python.framework/Versions/3.11/bin/python3'

let g:deoplete#enable_at_startup = 1

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

set clipboard=unnamedplus


" highlight Comment ctermfg=Gray guifg=#ffffbf
" highlight Function ctermfg=Blue guifg=Blue
" highlight Class ctermfg=Green guifg=Green
" highlight String ctermfg=Yellow guifg=Yellow
" Ejemplo para personalizar colores
" autocmd Syntax * highlight Class ctermfg=Blue guifg=#268bd2

"Terminal flotante
let g:floaterm_borderchars = '─│─│╭╮╯╰'
let g:floaterm_bordercolor = 'blue'
let g:floaterm_title = 'Terminal'
let g:floaterm_opacity = 0.8
let g:floaterm_shell = 'zsh'

" Configuración para Go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Configuración para Dart
let g:lsc_auto_map = v:true
let g:dart_format_on_save = 1

"Numero de lineas para el resaltado de sintaxis
set synmaxcol=2000

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
set termguicolors

" Habilita el resaltado de sintaxis en Vim
syntax enable
syntax on

" Establece Dracula como el esquema de colores actual
colorscheme dracula

" Habilita estilos de texto opcionales para Dracula
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dark'

let mapleader = " "
nnoremap <leader>pv :Vex<CR>
nnoremap <leader>ph :Hex<CR>

" Mapea yp para copiar al portapapeles tanto en modo normal como visual
nnoremap yp "+yy
vnoremap yp "+y

" Salir del modo inserción usando jj o jk
inoremap <leader>jk <Esc>
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

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"Moverse entre buffers
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

" Mapea 'gl' a ':Git log'
nnoremap <leader>gl :Git log<CR>
" Mapea 'gc' a ':Git commit'
nnoremap <leader>gc :Git commit<CR>
" Mapea 'ga' a ':Git add %'
nnoremap <leader>ga :Git add %<CR>
" Mapea 'gs' a ':Git status'
nnoremap <leader>gs :Git status<CR>
" Mapea 'gp' a ':Git push'
nnoremap <leader>gps :Git push<CR>
" Mapea 'gp' a ':Git pull'
nnoremap <leader>gpl :Git pull<CR>

" Instalar los plugins ya escritos
nnoremap <leader>pi :PlugInstall<CR>

" Terminal
nnoremap <silent> <leader>t :FloatermToggle<CR>

" para activar startify
nnoremap <leader>st :Startify<CR>

" Scripts
command! Fjson :source ~/.vim/scripts/formatear_json.vim
