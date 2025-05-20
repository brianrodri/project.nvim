local Fmts = {}

---@class fmts.IndentOpts
local defaults = {
  --- Prepended to the first line of each message. Uses `"- "` by default.
  line1_indent = "- ",
  --- Prepended to the subsequent lines of each message. Uses `"  "` by default.
  lineN_indent = "  ",
}

---@class fmts.IndentUserOpts<T>: fmts.IndentOpts
---@field line1_indent? string
---@field lineN_indent? string

---@param message string
---@param opts? fmts.IndentUserOpts
function Fmts.indent(message, opts)
  opts = vim.tbl_extend("keep", {}, opts or {}, defaults) ---@cast opts fmts.IndentUserOpts
  return vim
    .iter(ipairs(vim.split(message, "\n")))
    :map(function(i, line) return (i == 1 and opts.line1_indent or opts.lineN_indent) .. line end)
    :join("\n")
end

--- Returns consistent formatting for two or more inputs, otherwise returns the formatted input alone (or `nil`).
---
---@generic T
---@param input T|false|nil|(T|false|nil)[]  A single value or an array of values. `false` and `nil` values are skipped.
---@param opts? fmts.IndentUserOpts          Formatting options.
---@return string|? merged
function Fmts.merge_lines(input, opts)
  if input and not vim.islist(input) then input = { input } end
  local messages = vim.iter(input or {}):map(function(val) return val and tostring(val) or nil end):totable()
  if #messages < 2 then return messages[1] end
  return vim.iter(messages):map(function(msg) return Fmts.indent(msg, opts) end):join("\n")
end

--- Provides consistent formatting for errors raised by invalid assignments.
---
---@param err unknown           The error.
---@param field string          The name of the field.
---@param value any             The bad value assigned to the field.
---@return string assign_error  A helpful error message with debug info about the assignment responsible.
function Fmts.assign_error(err, field, value)
  return string.format("%s=%s error: %s", field, vim.inspect(value), tostring(err))
end

--- Provides consistent formatting for errors raised by functions.
---
---@param err unknown         The error.
---@param func_name string    The name of the function.
---@param ... any             The arguments passed to the function.
---@return string call_error  A helpful error message with debug info about the call responsible.
function Fmts.call_error(err, func_name, ...)
  local formatted_args = vim.fn.join(vim.tbl_map(vim.inspect, { ... }), ", ")
  return string.format("%s(%s) error: %s", func_name, formatted_args, tostring(err))
end

--- Provides consistent formatting for implementing |__tostring| functions.
---
---@generic T: table
---@param obj T              The object to format.
---@param class_name string  The object's class name.
---@param ... string         The object fields included in the string.
---@return string obj_str    The object's string representation.
function Fmts.class_string(obj, class_name, ...)
  local format_field = function(field) return string.format("%s=%s", field, vim.inspect(obj[field])) end
  return string.format("%s{ %s }", class_name, vim.fn.join(vim.tbl_map(format_field, { ... }), ", "))
end

return Fmts
