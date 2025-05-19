local Errs = require("projects.utils.errs")
local Fmts = require("projects.utils.fmts")
local Path = require("projects.utils.path")

local Config = {}

---@type projects.UserConfig
local DEFAULT_OPTS = {
  data_dir = vim.fn.stdpath("data") .. "/projects.nvim",
}

local FIELD_RESOLVERS = {
  data_dir = function(data_dir_value)
    return Path.join(type(data_dir_value) == "string" and data_dir_value or data_dir_value()):resolve()
  end,
}

--- Returns a validated projects.ResolvedConfig from inputs. Otherwise, terminates with a comprehensive error message.
---
---@param ... projects.UserConfig zero or more opts merged with |vim.tbl_deep_extend()| and `"keep"`.
---@return projects.ResolvedConfig
function Config.resolve_opts(...)
  ---@type projects.UserConfig
  local unresolved = vim.tbl_deep_extend("keep", {}, ..., DEFAULT_OPTS)
  local resolved = {}
  local failures = vim
    .iter(pairs(FIELD_RESOLVERS))
    :map(function(field, resolver)
      local ok, err = pcall(function() resolved[field] = resolver(unresolved[field]) end)
      return not ok and Fmts.assign_error(err, field, unresolved[field]) or nil
    end)
    :totable()
  assert(#failures == 0, Fmts.call_error(Errs.join(failures), "resolve_opts", ...))
  return resolved
end

return Config
