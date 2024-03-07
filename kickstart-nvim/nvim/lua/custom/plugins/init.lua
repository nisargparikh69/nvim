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
}
