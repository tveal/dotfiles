-- DISABLE by uncommenting the following line
-- if true then return {} end

return {
  -- enable search on hidden files
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
      },
    },
  },
}
