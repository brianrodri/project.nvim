local Path = require("projects.models.path")
local formats = require("projects.utils.formats")

local M = {} -- Module (public exports)
local H = {} -- Helper (private)

---@param setup_opts projects.SetupOpts
---
---@return projects.Config
function M.from_setup_opts(setup_opts)
  local config = vim.deepcopy(H.CONFIG)
  local resolve_errors = {}
  for field_name, field_resolver in pairs(H.FIELD_RESOLVERS) do
    if field_resolver then
      local ok, err = pcall(function() config[field_name] = field_resolver(setup_opts) end)
      if not ok then table.insert(resolve_errors, formats.assign_error(err, field_name, setup_opts[field_name])) end
    end
  end
  assert(#resolve_errors == 0, formats.call_error(formats.merge_lines(resolve_errors), "from_setup_opts", setup_opts))
  return config
end

---@class projects.Config
H.CONFIG = {
  --- The directory used to persist state between sessions.
  data_dir = Path.new(vim.fn.stdpath("data"), "projects.nvim"),
}

H.FIELD_RESOLVERS = {
  ---@param opts projects.SetupOpts
  data_dir = function(opts)
    local data_dir = assert(opts.data_dir, "value is required")
    return Path.new(type(data_dir) == "string" and data_dir or data_dir())
  end,
}

return M
