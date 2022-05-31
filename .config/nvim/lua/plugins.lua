local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua", "html", "css", "json", "yaml", "toml", "bash", "graphql", "dockerfile" },
        highlight = {
            enable = true,
        },
    })
    end
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'neovim/nvim-lspconfig',
      'windwp/nvim-autopairs',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
    after = {
      'nvim-lspconfig',
      'nvim-autopairs'
    },
    config = function()
      -- menuone: popup even when there is only one match
      -- noinsert: do not insert text until a selection is made
      -- noselect: do not select, force user to select one from the menu
      vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
      -- avoid showing extra messages when using completion
      vim.opt.shortmess = vim.opt.shortmess + { c = true }

      local cmp = require('cmp')
      cmp.setup({
          mapping = {
              -- ['<Tab>'] = cmp.mapping.select_next_item(),
              -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
              ['<Tab>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
              })
          },
          sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_signature_help' },
              { name = 'nvim_lua' }
          }, {
              { name = 'buffer', keyword_length = 3 }
          }),
      })

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end
  }

  use {
    'simrat39/rust-tools.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
    },
    after = {
      'nvim-lspconfig',
      'telescope.nvim',
      'nvim-cmp'
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lsp_attach = function(client, buf)
        vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
        vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
        vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
      end

      require('rust-tools').setup({
        capabilities = capabilities,
        on_attach = lsp_attach
      })

      -- 300ms of no cursor movements to trigger CursorHold
      vim.opt.updatetime = 300
      vim.opt.signcolumn = 'yes'
      -- deprecated, find replacement
      -- vim.cmd("autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })")
      vim.cmd("autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)")
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lea/plenary.nvim'
    },
    config = function()
      local actions = require('telescope.actions')
        require('telescope').setup({
          defaults = {
            layout_strategy = "vertical",
            mappings = {
              i = {
                ["<Esc>"] = actions.close,
                ["<Tab>"] = actions.move_selection_worse,
                ["<S-Tab>"] = actions.move_selection_better
              },
            },
          },
        })
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup()
    end
  }

  use {
    'phaazon/hop.nvim',
    branch = 'v1',
    config = function()
      require('hop').setup({
        keys = '.cpgasonidetuh',
      })
    end
  }

  use {
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup()
    end
  }

  use {
    'folke/which-key.nvim',
    config = function()
      vim.opt.timeoutlen = 300

      local wk = require('which-key')

      wk.setup({
        ignore_missing = true
      })
      wk.register({
        h = { '<cmd>HopChar1<cr>', 'hop' },
        d = { '<cmd>Telescope lsp_definitions<cr>', 'go to definition' },
        t = {
          name = 'telescope',
          g = { '<cmd>Telescope git_files<cr>', 'git files' },
          -- t = { '<cmd>Telescope file_browser<cr>', 'tree' },
          b = { '<cmd>Telescope buffers<cr>', 'buffers' },
          s = { '<cmd>Telescope lsp_workspace_symbols<cr>', 'symbols' },
          r = { '<cmd>Telescope lsp_references<cr>', 'references' },
          d = { '<cmd>Telescope diagnostics<cr>', 'diagnostics' },
          c = { '<cmd>Telescope lsp_code_actions<cr>', 'code actions' },
        },
        w = { ':w<cr>', 'write' },
        q = { ':wq<cr>', 'quit' }
      }, { prefix = "<Leader>" })
    end
  }

  use 'haishanh/night-owl.vim'

  -- automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

