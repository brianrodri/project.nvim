local M = {}

---@param func_name string The name of the function that raised the error.
---@param err any The error object.
---@param ... any The arguments passed to the function.
function M.format_call_error(err, func_name, ...)
  local formatted_args = vim.iter({ ... }):map(vim.inspect):join(", ")
  return string.format("%s(%s) error: %s", func_name, formatted_args, vim.inspect(err))
end

return M
