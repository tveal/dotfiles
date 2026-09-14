-- Make highlight groups transparent by clearing their background colors.
-- Uses the legacy highlight system (vim.cmd.highlight) because that's what
-- colorschemes use, and the new nvim_set_hl() system gets overridden.

local function make_transparent(name)
  pcall(vim.cmd, "highlight " .. name .. " guibg=NONE ctermbg=NONE guisp=NONE")
end

local groups = {
  -- transparent background
  "Normal",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "Pmenu",
  "Terminal",
  "EndOfBuffer",
  "FoldColumn",
  "Folded",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "NormalNC",
  "WhichKeyFloat",
  "TelescopeBorder",
  "TelescopeNormal",
  "TelescopePromptBorder",
  "TelescopePromptTitle",
  -- neotree
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeVertSplit",
  "NeoTreeWinSeparator",
  "NeoTreeEndOfBuffer",
  -- nvim-tree
  "NvimTreeNormal",
  "NvimTreeVertSplit",
  "NvimTreeEndOfBuffer",
  -- notify
  "NotifyINFOBody",
  "NotifyERRORBody",
  "NotifyWARNBody",
  "NotifyTRACEBody",
  "NotifyDEBUGBody",
  "NotifyINFOTitle",
  "NotifyERRORTitle",
  "NotifyWARNTitle",
  "NotifyTRACETitle",
  "NotifyDEBUGTitle",
  "NotifyINFOBorder",
  "NotifyERRORBorder",
  "NotifyWARNBorder",
  "NotifyTRACEBorder",
  "NotifyDEBUGBorder",
  -- tabs, statusline, winbar
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "StatusLine",
  "StatusLineNC",
  "WinBar",
  "WinBarNC",
  "VertSplit",
  -- snacks picker
  "SnacksPickerBackdrop",
}

local function apply_transparency()
  for _, name in ipairs(groups) do
    make_transparent(name)
  end
  vim.api.nvim_exec_autocmds("User", { pattern = "TransparencyApplied", modeline = false })
end

apply_transparency()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_transparency,
})
