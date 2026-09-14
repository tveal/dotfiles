-- DISABLE by uncommenting the following line
if true then return {} end

-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/1897
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    event_handlers = {
      {
        event = "neo_tree_popup_input_ready",
        ---@param args { bufnr: integer, winid: integer }
        handler = function(args)
          -- map <esc> to enter normal mode (by default closes prompt)
          -- don't forget `opts.buffer` to specify the buffer of the popup.
          vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
        end,
      },
    },
  },
}
