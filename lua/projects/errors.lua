local M = {}

--- Raises a helpful error with debug info about the call responsible.
---
---@param err unknown The error object.
---@param func_name string The name of the function that raised the error.
---@param ... any The arguments passed to the function.
---@return unknown ... This function never returns, but the annotation convinces LuaLS that it does.
function M.call_failure(err, func_name, ...)
  local debug_args = vim.fn.join(vim.tbl_map(vim.inspect, { ... }), ", ")
  error(string.format("%s(%s) error: %s", func_name, debug_args, tostring(err)))
end

--- Raises a helpful "not implemented" error.
---
---@param func_name string The name of the function that raised the error.
---@param ... any The arguments passed to the function.
---@return unknown ... This function never returns, but the annotation convinces LuaLS that it does.
M.TODO = function(func_name, ...) M.call_failure("not implemented", func_name, ...) end

return M
