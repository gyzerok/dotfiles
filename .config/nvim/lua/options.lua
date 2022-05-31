vim.g.mapleader = " "
-- enable line numbers
vim.opt.number = true
-- highlight current line
vim.opt.cursorline = true
-- enhance command-line completion
vim.opt.wildmenu = true

-- 24-bit RGB colors
vim.opt.termguicolors = true
vim.cmd'colorscheme night-owl'

vim.cmd([[
filetype indent plugin on
syntax enable
]])
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- set system clipboard as default
vim.opt.clipboard = unnamedplus

-- start scrolling three lines before the horizontal window border
vim.opt.scrolloff = 3

-- for a split second highlight yanked text
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup end
]], false)


-- " allow backspace in insert mode
-- set backspace=indent,eol,start
-- " highlight searches
-- set hlsearch
-- " highlight dynamically as pattern is typed
-- set incsearch
-- " use global substitute by default
-- set gdefault
-- " use utf-8 without bom
-- set encoding=utf-8 nobomb
-- " dont add empty newlines at the end of files
-- set binary
-- set noeol
-- " centralize backups, swapfiles and undo history
-- set backupdir=~/.nvim/backups
-- set directory=~/.nvim/swaps
-- if exists("&undodir")
--     set undodir=~/.nvim/undo
-- endif
