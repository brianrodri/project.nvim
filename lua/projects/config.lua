local errors = require("projects.errors")
local fmt = require("projects.utils.fmt")
local path = require("projects.utils.path")

local M = {}

---@class projects.UserConfig
---@field data_dir? string|fun(): string  Determines where the plugin stores its persistent state.

---@class projects.ResolvedConfig: projects.UserConfig
---@field data_dir projects.Path

---@type projects.UserConfig
local DEFAULT_CONFIG = {
  data_dir = vim.fn.stdpath("data"),
}

---@generic T
---@type table<string, fun(opts: projects.UserConfig, resolved: projects.ResolvedConfig)>
local FIELD_RESOLVERS = {
  data_dir = function(opts, resolved)
    local data_dir = assert(opts.data_dir, "value is required")
    resolved.data_dir = path.join(type(data_dir) == "string" and data_dir or data_dir())
  end,
}

---@param opts? projects.UserConfig
---@return projects.ResolvedConfig
function M.resolve_opts(opts)
  local resolved = vim.tbl_deep_extend("force", vim.deepcopy(DEFAULT_CONFIG), opts or {})
  local resolve_errors = {}
  for field, resolver in pairs(FIELD_RESOLVERS) do
    local ok, value = pcall(resolver, opts)
    if not ok then table.insert(resolve_errors, string.format('invalid "%s": %s', field, vim.inspect(value))) end
  end
  assert(#resolve_errors == 0, fmt.call_error(errors.join(resolve_errors), "resolve_opts", opts))
  ---@cast resolved projects.ResolvedConfig
  return resolved
end

return M
