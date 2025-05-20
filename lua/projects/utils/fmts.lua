local Fmts = {}

--- Provides consistent formatting for errors raised by invalid assignments.
---
---@param err unknown           The error.
---@param field_name string     The name of the field.
---@param field_value any       The bad value assigned to the field.
---@return string assign_error  A helpful error message with debug info about the assignment responsible.
function Fmts.assign_error(err, field_name, field_value)
  return string.format("%s = %s error: %s", field_name, vim.inspect(field_value), tostring(err))
end

--- Provides consistent formatting for errors raised by functions.
---
---@param err unknown         The error.
---@param func_name string    The name of the function.
---@param ... any             The arguments passed to the function.
---@return string call_error  A helpful error message with debug info about the call responsible.
function Fmts.call_error(err, func_name, ...)
  local debug_args = vim.fn.join(vim.tbl_map(vim.inspect, { ... }), ", ")
  return string.format("%s(%s) error: %s", func_name, debug_args, tostring(err))
end

--- Provides consistent formatting for implementing |__tostring| functions.
---
---@generic T: table
---@param obj T              The object to format.
---@param class_name string  The object's class name.
---@param ... string         The object fields included in the string.
---@return string obj_str    The object's string representation.
function Fmts.class_string(obj, class_name, ...)
  local fields = vim.iter({ ... }):map(function(f) return string.format("%s=%s", f, vim.inspect(obj[f])) end):join(", ")
  return string.format("%s(%s)", class_name, fields)
end

function Fmts.exit_code(name, code) return string.format("%s(%d)", name, code) end

function Fmts.trim(str) return str:gsub("^%s+", ""):gsub("%s+$", "") end

return Fmts
