local M = {}

--- Returns a consistent format for __tostring methods to use.
---
---
---@generic T: table
---@param class_name string The class name as a string.
---@param class_inst T The class instance to format as a string.
---@param ... string fields of the class to include in the string
function M.class_string(class_inst, class_name, ...)
  local class_fields = vim
    .iter({ ... })
    :map(function(field) return string.format("%s=%s", field, vim.inspect(class_inst[field])) end)
    :join(", ")
  return string.format("%s(%s)", class_name, class_fields)
end

return M
