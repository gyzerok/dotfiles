"#############################################################################
"                           VUNDLE CONFIGURATION

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'elmcast/elm-vim'

call vundle#end()
filetype plugin indent on


" ################

nnoremap <Space> <nop>
let mapleader=" "
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>j :bp<CR>
nnoremap <Leader>k :bn<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :wq<CR>

" #############################################################################
"                                  DONT KNOW THIS YES

" Airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1

set history=50		                " keep 50 lines of command line history
set backspace=2                  " Allow backspace on everything in insert mode
set textwidth=100


" #############################################################################
"                                  COLOR

set background=dark
colorscheme solarized
syntax enable                    " enable syntax processing


" #############################################################################
"                               SPACES and TABS

set autoindent                   " copy indent on new line
set smartindent
set smarttab
set tabstop=4                    " number of visual spaces per TAB
set softtabstop=4                " number of spaces in tab when editing
set expandtab                    " tabs are spaces
set shiftwidth=4

function! <SID>StripTrailingWhitespaces()
    let _s=@/
    let l=line(".")
    let c=col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

let blacklist = ['markdown']
autocmd BufWritePre * if index(blacklist, &ft) < 0 | :call <SID>StripTrailingWhitespaces()


" #############################################################################
"                                  UI CONFIG

set mouse=a                      " Enable mouse usage (all modes)
set number                       " show line numbers
set showcmd                      " show command in bottom bar
set cursorline                   " highlight current line
filetype indent on               " load filetype-specific indent files
set wildmenu                     " visual autocomplete for command menu
set lazyredraw                   " redraw only when we need to.
set showmatch                    " highlight matching [{()}]
set ignorecase                   " case insensitiveautoindent

" Show vertical ruler
highlight Overlength ctermbg=red ctermfg=white guibg=#592929
match Overlength /\%101v.\+/


" #############################################################################
"                                  SEARCHING

set incsearch                    " search as characters are entered
set hlsearch                     " highlight matches
" turn off search highlight with [,<space>]
" nnoremap <leader><space> :nohlsearch<CR>


" #############################################################################
"                                  FOLDING
"
set foldenable                   " enable folding
set foldlevelstart=10            " open most folds by default
set foldnestmax=3                " 3 nested fold max
" space open/closes folds
set foldmethod=indent            " fold based on indent level
