local fmt = require("projects.utils.fmt")

local M = {
  --- Terminates the last protected call with a helpful "not implemented" error.
  ---
  ---@param func_name string The name of the function that caused the error.
  ---@param ... any The arguments passed to the function.
  ---@return unknown ... This function never returns, but the annotation convinces LuaLS that it does.
  TODO = function(func_name, ...) error(fmt.call_error("not implemented", func_name, ...)) end,

  -- NOTE: TODO's definition is intentionally inconsistent so that tools don't consider it as an _actual_ TODO.
}

--- Joins the error objects into a string.
---
---@param ... unknown|? The error objects to join. `nil` values are skipped.
---@return string
function M.join(...)
  -- NOTE: `:h Iter:map` skips over `nil` return values.
  local errs = vim.iter({ ... }):map(function(err) return err and tostring(err) end):totable()
  if #errs == 0 then return "" end
  if #errs == 1 then return errs[1] end
  return vim.iter(errs):map(function(err) return "\t" .. err end):join("\n")
end

return M
