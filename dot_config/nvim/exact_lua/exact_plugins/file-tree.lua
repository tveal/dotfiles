-- DISABLE by uncommenting the following line
-- if true then return {} end

-- snacks explorer with cleaner header
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- Replace the built-in "sidebar" layout globally.
      layouts = {
        -- remove orange border and dark backdrop from snacks explorer
        sidebar = {
          layout = {
            backdrop = false,
            width = 40,
            min_width = 40,
            height = 0,
            position = "left",
            border = "top",
            box = "vertical",
            title = " file-tree {flags}",
            title_pos = "left",
            {
              win = "input",
              height = 1,
              border = "none",
              title = "{title} {live} {flags}",
              title_pos = "center",
            },
            {
              win = "list",
              border = "none",
            },
            {
              win = "preview",
              title = "{preview}",
              height = 0.4,
              border = "top",
            },
          },
        },
      },

      sources = {
        explorer = {
          layout = {
            preset = "sidebar",
          },
        },
      },
    },
  },
}
