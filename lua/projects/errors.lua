local M = {}

--- Raises an error with debug information about the function call.
---
---@param err any The error object.
---@param func_name string The name of the function that raised the error.
---@param ... any The arguments passed to the function.
---@return unknown ...
function M.call_failure(err, func_name, ...)
  local debug_args = vim.fn.join(vim.tbl_map(vim.inspect, { ... }), ", ")
  error(string.format("%s(%s) error: %s", func_name, debug_args, tostring(err)))
end

--- Raises a helpful "not implemented" error.
---
---@param func_name string The name of the function that raised the error.
---@param ... unknown The arguments passed to the function.
---@return unknown ...
M.TODO = function(func_name, ...) M.call_failure("not implemented", func_name, ...) end

return M
