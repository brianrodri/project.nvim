local M = {}

--- Returns a consistent format for __tostring methods to use.
---
---@generic T: table
---@param obj T The class instance to format as a string.
---@param class_name string The class name as a string.
---@param ... string fields of the class to include in the string
function M.class_string(obj, class_name, ...)
  local fields = vim.iter({ ... }):map(function(f) return string.format("%s=%s", f, vim.inspect(obj[f])) end):join(", ")
  return string.format("%s(%s)", class_name, fields)
end

--- Returns a helpful error message with debug info about the function call responsible.
---
---@param err unknown The error object.
---@param func_name string The name of the function that caused the error.
---@param ... any The arguments passed to the function.
---@return string call_error A helpful error with debug info about the call responsible.
function M.call_error(err, func_name, ...)
  local debug_args = vim.fn.join(vim.tbl_map(vim.inspect, { ... }), ", ")
  return string.format("%s(%s) error: %s", func_name, debug_args, tostring(err))
end

return M
