local formats = require("projects.utils.formats")

local M = {}

--- Terminates the last protected call with a helpful "not implemented" error.
---
---@param func_name string  The name of the unimplemented function.
---@param ... any           The arguments passed to the function.
---@return unknown ...      Although this function never returns, this annotation convinces LuaLS that it does.
function M.TODO(func_name, ...) error(formats.call_error("not implemented", func_name, ...)) end

return M
