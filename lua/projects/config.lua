local errors = require("projects.errors")
local path = require("projects.utils.path")

local M = {}

---@type projects.UserConfig
local DEFAULT_CONFIG = {
  data_dir = vim.fn.stdpath("data"),
}

---@generic T
---@type table<string, fun(opts: projects.UserConfig)>
local FIELD_RESOLVERS = {
  data_dir = function(opts)
    opts.data_dir = path.new(type(opts) == "string" and opts or opts.data_dir()):resolve().path_str
  end,
}

---@param opts? projects.UserConfig
---@return projects.UserConfig
function M.resolve_opts(opts)
  opts = vim.tbl_deep_extend("force", vim.deepcopy(DEFAULT_CONFIG), opts or {})
  local resolve_errors = {}
  for field, resolver in pairs(FIELD_RESOLVERS) do
    local ok, value = pcall(resolver, opts)
    if not ok then table.insert(resolve_errors, string.format('invalid "%s": %s', field, tostring(value))) end
  end
  assert(#resolve_errors == 0, errors.format_call_error(errors.join(resolve_errors), "resolve_opts", opts))
  return opts
end

return M
