" =============================================================================
" Legacy Vim Configuration (.vimrc)
" NOTE: The Neovim configuration lives in .config/nvim/init.lua
" This file is kept for compatibility with classic Vim.
" =============================================================================

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

" Cross-platform Python3 detection
if has('mac')
    let g:python3_host_prog = '/Library/Frameworks/Python.framework/Versions/3.11/bin/python3'
elseif has('win32')
    let g:python3_host_prog = 'python'
elseif executable('python3')
    let g:python3_host_prog = exepath('python3')
endif

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

" Cross-platform clipboard
if has('mac') || has('win32')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif


" highlight Comment ctermfg=Gray guifg=#ffffbf
" highlight Function ctermfg=Blue guifg=Blue
" highlight Class ctermfg=Green guifg=Green
" highlight String ctermfg=Yellow guifg=Yellow
" Example for customizing colors
" autocmd Syntax * highlight Class ctermfg=Blue guifg=#268bd2

" Floating terminal
let g:floaterm_borderchars = '─│─│╭╮╯╰'
let g:floaterm_bordercolor = 'blue'
let g:floaterm_title = 'Terminal'
let g:floaterm_opacity = 0.8
" Cross-platform shell for floaterm
if has('win32')
    let g:floaterm_shell = 'powershell'
elseif executable('zsh')
    let g:floaterm_shell = 'zsh'
else
    let g:floaterm_shell = 'bash'
endif

" Go configuration
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Dart configuration
let g:lsc_auto_map = v:true
let g:dart_format_on_save = 1

" Maximum columns for syntax highlighting
set synmaxcol=2000

" Keep at least 8 lines visible above and below the cursor
set scrolloff=8

" Show absolute line numbers
set number

" Show relative line numbers
set relativenumber

" Set tab width and soft tab width to 4 spaces
set tabstop=4 softtabstop=4

" Set indent width to 4 spaces
set shiftwidth=4

" Convert tabs to spaces
set expandtab

" Enable smart indentation
set smartindent
set termguicolors

" Enable syntax highlighting
syntax enable
syntax on

" Set Dracula as the current colorscheme
colorscheme dracula

" Enable airline tabline and theme
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dark'

let mapleader = " "
nnoremap <leader>pv :Vex<CR>
nnoremap <leader>ph :Hex<CR>

" Map yp to copy to system clipboard in normal and visual mode
nnoremap yp "+yy
vnoremap yp "+y

" Exit insert mode using jj or jk
inoremap <leader>jk <Esc>
" I use neovim, btw
nnoremap <Leader><CR> :so $MYVIMRC<CR>
" Search files in current git directory and subdirectories
nnoremap <C-p> :GFiles<CR>
" Search files in current directory and subdirectories
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

" Navigate between buffers
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

" Map 'gl' to ':Git log'
nnoremap <leader>gl :Git log<CR>
" Map 'gc' to ':Git commit'
nnoremap <leader>gc :Git commit<CR>
" Map 'ga' to ':Git add %'
nnoremap <leader>ga :Git add %<CR>
" Map 'gs' to ':Git status'
nnoremap <leader>gs :Git status<CR>
" Map 'gps' to ':Git push'
nnoremap <leader>gps :Git push<CR>
" Map 'gpl' to ':Git pull'
nnoremap <leader>gpl :Git pull<CR>

" Install listed plugins
nnoremap <leader>pi :PlugInstall<CR>

" Terminal
nnoremap <silent> <leader>t :FloatermToggle<CR>

" Toggle Startify
nnoremap <leader>st :Startify<CR>

" Scripts
command! Fjson :execute 'source' expand('~/.vim/scripts/formatear_json.vim')
