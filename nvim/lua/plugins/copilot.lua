return {
  'zbirenbaum/copilot.lua',
  requires = {
    'copilotlsp-nvim/copilot-lsp', -- optional, for NES functionality
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<C-j>',
        accept_word = '<C-k>',
        accept_line = '<C-l>',
        next = '<C-]>',
        prev = '<C-[>',
        dismiss = '<C-x>',
      },
    },
    panel = { enabled = true },
  },
  config = function(_, opts)
    require('copilot').setup(opts)
  end,
}
