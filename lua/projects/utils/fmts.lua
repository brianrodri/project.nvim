local Fmts = {}

--- This function formats a string as a list item with customizable indentation for the first line and subsequent lines.
---
---@param str string
---@param opts? { head_indent?: string, body_indent?: string }
function Fmts.as_list_item(str, opts)
  local head_indent = opts and opts.head_indent or "- "
  local body_indent = opts and opts.body_indent or "  "
  return vim
    .iter(ipairs(vim.split(str, "\n")))
    :map(function(i, line) return (i == 1 and head_indent or body_indent) .. line end)
    :join("\n")
end

---@param items (unknown|false|nil)[]
---@param opts? { head_indent?: string, body_indent?: string }
function Fmts.merge_as_list(items, opts)
  ---@type string[]
  local strings = vim.iter(items):map(function(i) return i and tostring(i) or nil end):totable()
  if #strings == 0 then return nil end
  if #strings == 1 then return strings[1] end
  return vim.iter(strings):map(function(s) return Fmts.as_list_item(s, opts) end):join("\n")
end

--- Provides consistent formatting for errors raised by invalid assignments.
---
---@param err unknown           The error.
---@param field_name string     The name of the field.
---@param field_value any       The bad value assigned to the field.
---@return string assign_error  A helpful error message with debug info about the assignment responsible.
function Fmts.assign_error(err, field_name, field_value)
  return string.format("%s=%s error: %s", field_name, vim.inspect(field_value), tostring(err))
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

return Fmts
