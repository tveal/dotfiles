return {
  -- disable fancy UI for messages, cmdline, popupmenu
  { "folke/noice.nvim", enabled = false },
  -- -- disable inline hints
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      inlay_hints = { enabled = false },
    },
  },
}
