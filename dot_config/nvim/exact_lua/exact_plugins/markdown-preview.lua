-- DISABLE by uncommenting the following line
-- if true then return {} end

local _browser_pane_id = nil
local _poll_generation = 0 -- incremented each time a new poll starts; old loops bail out when theirs doesn't match

return {
  {
    "selimacerbas/markdown-preview.nvim",
    name = "markdown-preview-modern",
    dependencies = { "selimacerbas/live-server.nvim" },
    ft = { "markdown" },

    -- fancy integration with herdr + terminal-browser
    -- - <leader>mp   open current md file in herdr side pane with terminal-browser
    -- - <leader>mx   close tracked herdr side pane with terminal-browser
    config = function()
      require("markdown_preview").setup({
        instance_mode = "multi", -- one instance per nvim
        theme = "dark",
        mermaid = {
          theme = "dark",
        },
        root = function()
          return vim.fn.getcwd()
        end,
        hooks = {
          on_start = function(url)
            vim.fn.jobstart({ "terminal-browser", "open", url, "--split", "right" }, {
              env = {
                HERDR_ENV = "1",
                HERDR_PANE_ID = vim.env.HERDR_PANE_ID or "",
                HERDR_TAB_ID = vim.env.HERDR_TAB_ID or "",
                HERDR_SOCKET_PATH = vim.env.HERDR_SOCKET_PATH or "",
                HERDR_BIN_PATH = vim.env.HERDR_BIN_PATH or "",
                HERDR_WORKSPACE_ID = vim.env.HERDR_WORKSPACE_ID or "",
                HOME = vim.env.HOME,
                PATH = vim.env.PATH,
              },
              detach = true,
            })
            -- Bump generation so any previous polling loop knows to bail out
            _poll_generation = _poll_generation + 1
            local my_gen = _poll_generation

            local attempts = 0
            local max_attempts = 20 -- 20 × 500ms = 10s max
            local function poll()
              if _poll_generation ~= my_gen then
                return
              end -- superseded by a newer start
              attempts = attempts + 1
              local result = vim.fn.system("terminal-browser ls --all --json")
              local ok, data = pcall(vim.json.decode, result)
              if ok and data and data.browsers then
                for _, browser in ipairs(data.browsers) do
                  if browser.tabs then
                    for _, tab in ipairs(browser.tabs) do
                      if tab.url == url then
                        _browser_pane_id = browser.pane and browser.pane.pane or nil
                        vim.print(
                          "[md-preview] stored pane_id: "
                            .. tostring(_browser_pane_id)
                            .. " (attempt "
                            .. attempts
                            .. ")"
                        )
                        return
                      end
                    end
                  end
                end
              end
              if attempts < max_attempts then
                vim.defer_fn(poll, 500)
              else
                vim.print("[md-preview] gave up finding tab for url: " .. url)
              end
            end
            vim.defer_fn(poll, 300)
          end,
          on_stop = function()
            vim.print("[md-preview] on_stop called, pane_id: " .. tostring(_browser_pane_id))
            if _browser_pane_id then
              vim.fn.jobstart({ "herdr", "pane", "close", _browser_pane_id }, { detach = true })
              _browser_pane_id = nil
            end
          end,
        },
        open_browser = false,
      })

      -- Buffer-local keymaps for markdown files only
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          vim.keymap.set(
            "n",
            "<leader>mp",
            "<cmd>MarkdownPreviewStop<cr><cmd>MarkdownPreview<cr>",
            { buffer = ev.buf, desc = "Markdown preview (start / retarget)" }
          )
          vim.keymap.set(
            "n",
            "<leader>mx",
            "<cmd>MarkdownPreviewStop<cr>",
            { buffer = ev.buf, desc = "Markdown preview stop" }
          )
        end,
      })
    end,
  },
}
