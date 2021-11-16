"====== PLUGINS

call plug#begin('~/.nvim/plugged')

" Prerequesite for other plugins
Plug 'nvim-lua/plenary.nvim'

" Misc
Plug 'nvim-lualine/lualine.nvim'
Plug 'easymotion/vim-easymotion'
Plug 'voldikss/vim-floaterm'

" Development
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate' }
Plug 'simrat39/rust-tools.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'nvim-telescope/telescope.nvim'

" Theme
Plug 'haishanh/night-owl.vim'

call plug#end()


"====== MISC

" make vim more useful
set nocompatible
" enable line numbers
set number
" enhance command-line completion
set wildmenu
" highlight current line
set cursorline
set autoindent
set smarttab
" allow backspace in insert mode
set backspace=indent,eol,start
" make tabs as wide as 4 spaces
set tabstop=4
" set amount of characters used for indentation
set shiftwidth=4
" insert spaces whenever tab is pressed
set expandtab
" highlight searches
set hlsearch
" highlight dynamically as pattern is typed
set incsearch
" use global substitute by default
set gdefault
" use utf-8 without bom
set encoding=utf-8 nobomb
" dont add empty newlines at the end of files
set binary
set noeol
" start scrolling three lines before the horizontal window border
set scrolloff=3
" centralize backups, swapfiles and undo history
set backupdir=~/.nvim/backups
set directory=~/.nvim/swaps
if exists("&undodir")
    set undodir=~/.nvim/undo
endif

if (has("termguicolors"))
    set termguicolors
endif

syntax enable
colorscheme night-owl

map <Space> <Leader>
nnoremap <Leader>q :wq<cr>


"====== LUALINE

lua << EOF
require'lualine'.setup{}
EOF


"====== FLOATERM

let g:floaterm_width = 0.8
let g:floaterm_keymap_toggle = '<C-t>'


"====== TREESITTER

lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "html", "css", "json", "yaml", "toml", "bash", "graphql", "dockerfile" },
    highlight = {
        enable = true,
        disable = { "tsx", "rust" },
    },
}
EOF


"====== LSP

lua << EOF
local nvim_lsp = require'lspconfig'
require('rust-tools').setup({})
EOF
" 300ms of no cursor movements to trigger CursorHold
set updatetime=300
set signcolumn=yes
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)


"====== COMPLETIONS

" menuone: popup even when there is only one match
" noinsert: do not insert text until a selection is made
" noselect: do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" avid showing extra messages when using completion
set shortmess+=c
lua << EOF
local cmp = require'cmp'
cmp.setup({
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
    },
})
EOF

"====== EASYMOTION

let g:EasyMotion_startofline = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_keys = 'asonidetuh'

nmap <Leader>e <Plug>(easymotion-overwin-f)


"====== TELESCOPE

lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        layout_strategy = "vertical",
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
    },
}
EOF

nnoremap <Leader>tp <cmd>Telescope find_files<cr>
nnoremap <Leader>tt <cmd>Telescope file_browser<cr>
nnoremap <Leader>tb <cmd>Telescope buffers<cr>
nnoremap <Leader>ts <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <Leader>tr <cmd>Telescope lsp_references<cr>
nnoremap <Leader>td <cmd>Telescope lsp_workspace_diagnostics<cr>
nnoremap <Leader>tc <cmd>Telescope lsp_code_actions<cr>

