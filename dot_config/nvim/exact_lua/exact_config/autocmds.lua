-- tmpl file types for syntax highlighting
vim.filetype.add({
  pattern = {
    [".*zshrc%.tmpl"] = "zsh",
    [".*bashrc%.tmpl"] = "bash",
    [".*profile%.tmpl"] = "sh",
    [".*tmux%.conf%.tmpl"] = "tmux",
    [".*%.toml%.tmpl"] = "toml",
    [".*%.ya?ml%.tmpl"] = "yaml",
    [".*%.sh%.tmpl"] = "bash",
    [".*%.lua%.tmpl"] = "lua",
    [".*gitconfig%.tmpl"] = "gitconfig",
    [".*gitconfig"] = "gitconfig",
  },
})

-- Keep Snacks Explorer synchronized after external window changes
-- (e.g. NeoGit) without rebuilding/duplicating the Explorer tree.
--
-- IMPORTANT:
-- Use explorer_update instead of picker:refresh().
-- picker:refresh() can rebuild the picker/tree and cause duplicate
-- Explorer windows during unrelated window lifecycle events.

local group = vim.api.nvim_create_augroup("snacks_explorer_refresh", {
  clear = true,
})
local update_timer
local function update_explorer()
  if not vim.v.vim_did_enter then
    return
  end
  -- Debounce window lifecycle events. Plugins such as NeoGit can cause
  -- several WinClosed events in quick succession.
  if update_timer then
    update_timer:stop()
  end
  update_timer = vim.defer_fn(function()
    update_timer = nil
    local ok, Snacks = pcall(require, "snacks")
    if not ok or not Snacks.picker then
      return
    end
    local explorers = Snacks.picker.get({ source = "explorer" })
    for _, picker in ipairs(explorers) do
      if not picker.closed then
        pcall(picker.action, picker, "explorer_update")
      end
    end
  end, 50)
end

-- NeoGit / other plugins may destroy windows while Explorer is open.
-- Wait until the window lifecycle has settled before updating Explorer.
vim.api.nvim_create_autocmd("WinClosed", {
  group = group,
  callback = update_explorer,
})
