return {
  'akinsho/toggleterm.nvim',
  lazy_load = true,
  config = function()
    require('toggleterm').setup {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'float', -- default float
      close_on_exit = true,
      shell = vim.o.shell,
    }

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Toggle floating terminal
    map('n', '<leader>tf', ':ToggleTerm direction=float<CR>', opts)

    -- Toggle horizontal split terminal
    map('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>', opts)

    -- Toggle vertical split terminal
    map('n', '<leader>tv', ':ToggleTerm direction=vertical<CR>', opts)

    -- Toggle terminal in current buffer (default direction)
    map('n', '<leader>tt', ':ToggleTerm<CR>', opts)

    -- Terminal mode mappings
    map('t', '<Esc>', [[<C-\><C-n>]], opts)
    map('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
    map('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
    map('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
    map('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
    map('t', '<leader>tt', [[<C-\><C-n>:ToggleTerm<CR>]], opts)
  end,
}
