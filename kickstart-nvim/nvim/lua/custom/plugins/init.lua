-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
    "christoomey/vim-tmux-navigator",
    lazy = false,
	},
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
  {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  lazy = false, -- This plugin is already lazy
  config = function()
      vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(true)
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
          },
        },
      },
      -- DAP configuration
      dap = {
      },
    }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
	{
    "github/copilot.vim",
    lazy = false,
    config = function() end,
	},
  	{
    "zbirenbaum/copilot.lua",
    lazy = false,
    opts = function ()
      return require "custom.configs.copilot"
    end,
    config = function(_, opts)
      require("copilot").setup(opts)
    end
  	},
	{
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    config = function()
        require('crates').setup()
    end,
	},
	{
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
	},
	{
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local M = require "kickstart.plugins.nvimtree"
      M.git.enable = true
      M.git.ignore = false
      M.renderer.icons.show.git = true
      M.renderer.highlight_opened_files = "icon"
      M.renderer.highlight_modified = "name"
      return M
    end,
  	},
	{
    "NvChad/nvterm",
    config = function ()
    require("nvterm").setup()
  	end,
    opts = function()
		local terminal = require("nvterm.terminal")
		local toggle_modes = {'n', 't'}
		local mappings = {
		  { toggle_modes, '<A-h>', function () terminal.toggle('horizontal') end },
		  { toggle_modes, '<A-v>', function () terminal.toggle('vertical') end },
		  { toggle_modes, '<A-i>', function () terminal.toggle('float') end },
		}
		local opts = { noremap = true, silent = true }
		for _, mapping in ipairs(mappings) do
		  vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
		end    
		return terminal
	end,
  	},
	 {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require("toggleterm").setup{
               open_mapping = [[<A-h>]],
               direction = 'horizontal',
                shell = 'pwsh',
              on_open = function(term)
                  local nvimtree_api = require "nvim-tree.api"
                  local nvimtree_view = require "nvim-tree.view"
                  if nvimtree_view.is_visible() and term.direction == "horizontal" then
                      local nvimtree_width = vim.fn.winwidth(nvimtree_view.get_winnr())
                      nvimtree_api.tree.toggle()
                      nvimtree_view.View.width = nvimtree_width
                      nvimtree_api.tree.toggle(false, true)
                  end
             end
            }
            function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
          end        
        end
      },
    {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = function()
    local barbar = require("barbar")
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Move to previous/next
    map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
    -- Re-order to previous/next
    map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
    -- Goto buffer in position...
    map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
    map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
    map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
    map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
    map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
    map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
    map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
    map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
    map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
    map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
    -- Pin/unpin buffer
    map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    -- Close buffer
    map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    -- Wipeout buffer
    --                 :BufferWipeout
    -- Close commands
    map('n', '<A-q>', '<Cmd>BufferCloseAllButCurrent<CR>', opts)
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight
    -- Magic buffer-picking mode
    map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
    -- Sort automatically by...
    map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

    -- Other:
    -- :BarbarEnable - enables barbar (enabled by default)
    -- :BarbarDisable - very bad command, should never be used
    return barbar
    end,
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    {
    'rmagatti/goto-preview',
    event = "BufEnter",
    config = function()
      require('goto-preview').setup({
        default_mappings = true, -- Enable default mappings
        -- Other configuration options can be specified here
      })
    end
    },
}
