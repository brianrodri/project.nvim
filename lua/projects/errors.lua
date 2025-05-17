local M = {}

--- Returns a helpful error message with debug info about the function call responsible.
---
---@param err unknown The error object.
---@param func_name string The name of the function that caused the error.
---@param ... any The arguments passed to the function.
---@return string call_error A helpful error with debug info about the call responsible.
function M.format_call_error(err, func_name, ...)
  local debug_args = vim.fn.join(vim.tbl_map(vim.inspect, { ... }), ", ")
  return string.format("%s(%s) error: %s", func_name, debug_args, tostring(err))
end

--- Terminates the last protected call with a helpful "not implemented" error.
---
---@param func_name string The name of the function that caused the error.
---@param ... any The arguments passed to the function.
---@return unknown ... This function never returns, but the annotation convinces LuaLS that it does.
M.TODO = function(func_name, ...)
  -- NOTE: Intentionally different definition style: I don't want searches to consider this line as a TODO.
  error(M.format_call_error("not implemented", func_name, ...))
end

return M
