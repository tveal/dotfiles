return {
  name = "faster-hjkl",
  dir = vim.fn.stdpath("config"),
  config = function(_, opts)
    local uv = vim.uv or vim.loop

    local config = {
      last_times = {},
      counters   = {},
    }

    local function move(to)
      local now = uv.hrtime() / 1e9
      local gap = now - (config.last_times[to] or now)
      config.last_times[to] = now

      -- reset counter when key was "released" (gap > 90ms)
      if gap > 0.09 then
        config.counters[to] = 0
      else
        config.counters[to] = (config.counters[to] or 0) + 1
      end

      local c = config.counters[to]
      local step
      if c >= 4 then step = 10
      elseif c == 3 then step = 4
      elseif c == 2 then step = 2
      else step = 1 end

      vim.schedule(function()
        vim.cmd("normal! " .. step .. to)
      end)
    end

    local function motion(keys)
      return function()
        if vim.v.count > 0 then
          vim.cmd("normal! " .. vim.v.count .. keys)
        else
          move(keys)
        end
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once    = true,
      callback = function()
        vim.keymap.set({ "n", "v" }, "j", motion("j"), { noremap = true, silent = true, desc = "Accelerate j movement" })
        vim.keymap.set({ "n", "v" }, "k", motion("k"), { noremap = true, silent = true, desc = "Accelerate k movement" })
        vim.keymap.set({ "n", "v" }, "h", motion("h"), { noremap = true, silent = true, desc = "Accelerate h movement" })
        vim.keymap.set({ "n", "v" }, "l", motion("l"), { noremap = true, silent = true, desc = "Accelerate l movement" })
      end,
    })
  end,
}
