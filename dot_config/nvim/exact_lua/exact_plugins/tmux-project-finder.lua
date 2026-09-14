-- DISABLE by uncommenting the following line
if true then return {} end

local PROJECT_ROOTS = {
  "~/code",
}

local function scan_projects()
  local roots = table.concat(PROJECT_ROOTS, " ")
  local cmd = 'fd --hidden --type d "^.git$" ' .. roots .. ' | sed "s/\\.git\\/$//"'

  local handle, err = io.popen(cmd)
  assert(handle, err)
  local result = handle:read("*a")
  handle:close()

  local projects = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(projects, line)
  end

  return projects
end

-- local function open_in_tmux(project)
--   local session = vim.fn.fnamemodify(project, ":t") -- folder name
--
--   -- Check if session exists
--   local exists = os.execute("tmux has-session -t " .. session .. " 2>/dev/null")
--
--   if exists ~= 0 then
--     -- Create new session
--     os.execute(string.format('tmux new-session -ds %s -c "%s" "nvim"', session, project))
--   end
--
--   -- Switch to it
--   os.execute("tmux switch-client -t " .. session)
-- end

local LOG = "/tmp/tmux-debug.log"
local function log(msg)
  vim.notify(msg)
  local f, err = io.open(LOG, "a")
  if not f then vim.notify("log open failed: " .. tostring(err)) return end
  f:write(msg .. "\n")
  f:close()
end

local function run(cmd)
  local h = io.popen(cmd .. " 2>&1")
  if not h then log("failed to run: " .. cmd) return "" end
  local out = h:read("*a") or ""
  h:close()
  log(cmd .. " => '" .. out .. "'")
  return out
end

local function open_in_tmux(project)
  local stripped = project:gsub("/$", "")
  local session = stripped
  for _, root in ipairs(PROJECT_ROOTS) do
    local expanded = vim.fn.expand(root):gsub("/$", "")
    local rel = stripped:match("^" .. vim.pesc(expanded) .. "/(.+)$")
    if rel then session = rel break end
  end
  session = session:gsub("[%.%s/]", "_")
  vim.notify("session: " .. session .. " | project: " .. project)

  local has_out = run("tmux has-session -t " .. session)

  if has_out ~= "" then
    run(string.format("tmux new-session -ds '%s' -c '%s'", session, project))
  end

  run("tmux switch-client -t " .. session)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      -- local telescope = require("telescope")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values

      vim.keymap.set("n", "<leader>fo", function()
        local projects = scan_projects()

        pickers
          .new({}, {
            prompt_title = "All Projects (Recursive)",
            finder = finders.new_table(projects),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local entry = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                open_in_tmux(entry[1])
              end)
              return true
            end,
          })
          :find()
      end, { desc = "Find ANY Project (recursive)" })
    end,
  },
}
