set nocompatible

"*****************************************************************************
"" Plugins 
"*****************************************************************************

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'hecal3/vim-leader-guide'
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'sbdchd/neoformat'
Plug 'osyo-manga/vim-over'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Shougo/deol.nvim'

Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'

"" Develpoment
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'

"" Syntax
Plug 'andys8/vim-elm-syntax'
Plug 'leafgarland/typescript-vim'
Plug 'ekalinin/Dockerfile.vim'

call plug#end()

filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

"" Convert tabs to spaces
set tabstop=2 shiftwidth=2 expandtab

"" Fix backspace indent
set backspace=indent,eol,start

"" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Fix wrapping
set textwidth=0 
set wrapmargin=0
set nowrap

"" Disabled mouse
set mouse=
set ttymouse=


"*****************************************************************************
"" Visual Settings
"*****************************************************************************

syntax enable
set ruler
set number

let no_buffers_menu=1

if has("gui_running")
  set guicursor=n:block
  set guicursor=v:block
  "" Set Fira Code as the font
  set macligatures
  set guifont=Fira\ Code:h16

  "" Color theme
  set background=dark
  let g:gruvbox_contrast_dark='soft'
  colors gruvbox
  "" Set colors for tildas to not show
  " highlight EndOfBuffer guifg=#3f3f3f guibg=#3f3f3f
  "" Remove scrollbars and tabline
  set guioptions=
else
  " exit vim here need gui
endif

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F


"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************

set autoread

"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END


"*****************************************************************************
"" Lightline
"*****************************************************************************

set laststatus=2
set showtabline=2

let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#reverse_buffers = 1

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

let g:lightline = {
  \ 'enable': {
  \   'statusline': 1,
  \   'tabline': 1
  \ },
  \ 'colorscheme': 'wombat',
  \ 'tabline': {
  \   'left': [
  \     [ 'buffers' ]
  \   ],
  \   'right': [
  \     [ 'tablinetitle' ]
  \   ]
  \ },
  \ 'active': {
  \   'left': [
  \     [ 'mode' ],
  \     [ 'filename' ],
  \     [ 'gitbranch' ]
  \   ],
  \   'right': [
  \     [ 'filetype' ],
  \     [ 'fileencoding' ],
  \     [ 'cocstatus' ]
  \   ]
  \ },
  \ 'inactive': {
  \   'right': [
  \   ]
  \ },
  \ 'component': {
  \   'tablinetitle': 'Buffers'
  \ },
  \ 'component_function': {
  \   'mode': 'LightlineMode',
  \   'filename': 'LightlineFilename',
  \   'fileencoding': 'LightlineEncoding',
  \   'gitbranch': 'LightlineFugitive',
  \   'cocstatus': 'coc#status'
  \ },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers'
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel'
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': {'left': '', 'right': '' }
\ }

function! LightlineMode()
  if &filetype ==# 'defx' 
    return ''
  else
    return lightline#mode()
endfunction

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'

  if &filetype ==# 'defx' 
    return ''
  else
    return filename
endfunction

function! LightlineEncoding()
  let encoding = &fenc !=# '' ? &fenc : &enc

  if &filetype ==# 'defx'
    return ''
  else
    return encoding
  endif
endfunction

function! LightlineFugitive()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ' '. branch : ''
  else
    return ''
  endif
endfunction


"*****************************************************************************
"" Defx
"*****************************************************************************

call defx#custom#column('icon', {
  \ 'directory_icon': '▸',
  \ 'opened_icon': '▾',
  \ 'root_icon': ' ',
  \ })

autocmd BufWritePost * call defx#redraw()

autocmd FileType defx call s:defx_my_settings()

function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('call', 'DefxOpen')

  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')

  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')

  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')

  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')

  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')

  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')

  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')

  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')

  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
endfunction

function! DefxOpen(_)
  if defx#is_directory()
    call defx#call_action('open_or_close_tree')
  else
    let filepath = defx#get_candidate()['action__path']
    call defx#call_action('quit')
    execute 'badd' filepath
    execute 'b' bufnr('$')
  endif
endfunction


"*****************************************************************************
"" Coc
"*****************************************************************************

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <Tab>
      \ pumvisible() ? '<C-n>' :
      \ <SID>check_back_space() ? '<Tab>' :
      \ coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? '<C-p>' : '<C-h>'

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <CR> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <Enter> pumvisible() ? '<C-y>' : '<C-g>u<Enter>'


"*****************************************************************************
"" Neoformat
"*****************************************************************************

augroup fmt
  autocmd!
  autocmd BufWritePre *.js | silent Neoformat
  autocmd BufWritePre *.jsx | silent Neoformat
  autocmd BufWritePre *.ts | silent Neoformat
  autocmd BufWritePre *.tsx | silent Neoformat
  autocmd BufWritePre *.elm | silent Neoformat
augroup END

let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_graphql = ['prettier']
let g:neoformat_enabled_html = ['prettier']
let g:neoformat_enabled_css = ['prettier']


"*****************************************************************************
"" Rainbow
"*****************************************************************************

let g:rainbow_active = 1


"*****************************************************************************
"" EditorConfig
"*****************************************************************************

let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']


"*****************************************************************************
"" EasyMotion
"*****************************************************************************

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_keys = 'asidonetuh'


"*****************************************************************************
"" Mappings
"*****************************************************************************

set timeoutlen=1000
function! s:my_displayfunc()
  let g:leaderGuide#displayname =
  \ substitute(g:leaderGuide#displayname, '\c<cr>$', '', '')
  let g:leaderGuide#displayname = 
  \ substitute(g:leaderGuide#displayname, '^<Plug>', '', '')
endfunction
let g:leaderGuide_displayfunc = [function("s:my_displayfunc")]

" Map leader to space
nnoremap <Space> <Nop>
let mapleader=" "

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Make Shift-Tab work in insert mode
nnoremap <S-Tab> <C-d>

call leaderGuide#register_prefix_descriptions('<Space>', 'g:lmap')
nnoremap <silent> <Leader> :<C-U>LeaderGuide '<Space>'<CR>
vnoremap <silent> <Leader> :<C-U>LeaderGuideVisual '<Space>'<CR>


let g:lmap = {}
nmap <Plug>(buffer-1) <Plug>lightline#bufferline#go(1)
nmap <Leader>1 <Plug>(buffer-1)
nmap <Plug>(buffer-2) <Plug>lightline#bufferline#go(2)
nmap <Leader>2 <Plug>(buffer-2)
nmap <Plug>(buffer-3) <Plug>lightline#bufferline#go(3)
nmap <Leader>3 <Plug>(buffer-3)
nmap <Plug>(buffer-4) <Plug>lightline#bufferline#go(4)
nmap <Leader>4 <Plug>(buffer-4)
nmap <Plug>(buffer-5) <Plug>lightline#bufferline#go(5)
nmap <Leader>5 <Plug>(buffer-5)
nmap <Plug>(buffer-6) <Plug>lightline#bufferline#go(6)
nmap <Leader>6 <Plug>(buffer-6)
nmap <Plug>(buffer-7) <Plug>lightline#bufferline#go(7)
nmap <Leader>7 <Plug>(buffer-7)
nmap <Plug>(buffer-8) <Plug>lightline#bufferline#go(8)
nmap <Leader>8 <Plug>(buffer-8)
nmap <Plug>(buffer-9) <Plug>lightline#bufferline#go(9)
nmap <Leader>9 <Plug>(buffer-9)

nnoremap <Plug>(toggle-file-tree) :Defx -split=vertical -toggle -winwidth=50 -direction=botright<CR>
nmap <Leader>f <Plug>(toggle-file-tree)

nnoremap <Plug>(open-terminal) :Deol -split=horizontal<CR>
nmap <Leader>t <Plug>(open-terminal)
tnoremap <Esc> <C-w>c

nnoremap <Plug>(open-file) :Files<CR>
nmap <Leader>o <Plug>(open-file)

nmap <Leader><Leader> <Plug>(easymotion-bd-f2)

let g:lmap.v = { 'name' : '+Vim' }
nnoremap <Plug>(open-vimrc) :e $MYVIMRC<CR>
nmap <Leader>ve <Plug>(open-vimrc)
nnoremap <Plug>(reload-vimrc) :source $MYVIMRC<CR>
nmap <Leader>vr <Plug>(reload-vimrc)

let g:lmap.b = { 'name' : '+Buffer' }
nnoremap <Plug>(prev-buffer) :bp<CR>
nmap <Leader>bp <Plug>(prev-buffer)
nnoremap <Plug>(next-buffer) :bn<CR>
nmap <Leader>bn <Plug>(next-buffer)
nnoremap <Plug>(delete-buffer) :bd<CR>
nmap <Leader>bd <Plug>(delete-buffer)
nnoremap <Plug>(save-buffer) :w<CR>
nmap <Leader>bs <Plug>(save-buffer)
nnoremap <Plug>(format-buffer) :Neoformat<CR>
nmap <Leader>bf <Plug>(format-buffer)
nnoremap <Plug>(replace-in-buffer) :OverCommandLine<CR>
nmap <Leader>br <Plug>(replace-in-buffer)
nnoremap <Plug>(open-buffer) :Buffers<CR>
nmap <Leader>bo <Plug>(open-buffer)

let g:lmap.w = { 'name' : '+Window' }
nnoremap <Plug>(right-window) :wincmd l<CR>
nmap <Leader>wl <Plug>(right-window)
nnoremap <Plug>(left-window) :wincmd h<CR>
nmap <Leader>wh <Plug>(left-window)
nnoremap <Plug>(top-window) :wincmd k<CR>
nmap <Leader>wk <Plug>(top-window)
nnoremap <Plug>(bottom-window) :wincmd j<CR>
nmap <Leader>wj <Plug>(bottom-window)
nnoremap <Plug>(delete-window) :wincmd d<CR>
nmap <Leader>wd <Plug>(delete-window)

let g:lmap.g = { 'name' : '+Git' }
nnoremap <Plug>(commit-git) :Gcommit<CR>
nmap <Leader>gc <Plug>(commit-git)
nnoremap <Plug>(push-git) :Gpush<CR>
nmap <Leader>gp <Plug>(push-git)
nnoremap <Plug>(fetch-git) :Gfetch<CR>
nmap <Leader>gf <Plug>(fetch-git)
nnoremap <Plug>(status-git) :Gstatus<CR>
nmap <Leader>gs <Plug>(status-git)
nnoremap <Plug>(diff-git) :Gvdiffsplit<CR>
nmap <Leader>gd <Plug>(diff-git)
nnoremap <Plug>(new-branch-git) :Git checkout -b<Space>
nmap <Leader>gn <Plug>(new-branch-git)
nnoremap <Plug>(branch-git) :Git checkout<Space>
nmap <Leader>gb <Plug>(branch-git)

let g:lmap.d = { 'name' : '+Development' }
nnoremap <Plug>(hover-code) :call CocAction('doHover')<CR>
nmap <Leader>dh <Plug>(hover-code)
nnoremap <Plug>(outline-symbols) :CocList outline<CR>
nmap <Leader>do <Plug>(outline-symbols)
nmap <Leader>dp <Plug>(coc-diagnostic-prev-error)
nmap <Leader>dn <Plug>(coc-diagnostic-next-error)
nmap <Leader>dd <Plug>(coc-definition)
nmap <Leader>dr <Plug>(coc-rename)
nmap <Plug>(comment-line) <Plug>(Commentary)
nmap <Leader>dc <Plug>(comment-line)
vmap <Leader>dc <Plug>(comment-line)
