local Fmts = require("projects.utils.fmts")
local Path = require("projects.utils.path")

local Config = {}

---@type projects.UserOpts
local DEFAULT_OPTS = {
  data_dir = vim.fn.stdpath("data") .. "/projects.nvim",
}

local FIELD_RESOLVERS = {
  ---@param value string|fun(): string
  data_dir = function(value)
    assert(value, "value is required")
    return Path.new(type(value) == "string" and value or value()):resolve()
  end,
}

--- Returns a validated projects.ResolvedConfig from inputs. Otherwise, terminates with a comprehensive error message.
---
---@param ... projects.UserOpts zero or more opts merged with |vim.tbl_deep_extend()| and `"keep"`.
---@return projects.Config
function Config.resolve_opts(...)
  ---@type projects.UserOpts
  local unresolved = vim.tbl_deep_extend("keep", {}, ..., DEFAULT_OPTS)
  local resolved = {}
  local resolve_errors = vim
    .iter(FIELD_RESOLVERS)
    :map(function(field, resolver)
      local ok, err = pcall(function() resolved[field] = resolver(unresolved[field]) end)
      if not ok then return Fmts.assign_error(err, field, unresolved[field]) end
    end)
    :totable()
  assert(#resolve_errors == 0, Fmts.call_error(Fmts.merge_lines(resolve_errors), "resolve_opts", ...))
  return resolved
end

return Config
