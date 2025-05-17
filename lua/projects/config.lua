local M = {}

---@type projects.UserConfig
local DEFAULT_CONFIG = {}

---@param opts? projects.UserConfig
---@return projects.UserConfig
function M.resolve_opts(opts) return vim.tbl_deep_extend("force", vim.deepcopy(DEFAULT_CONFIG), opts or {}) end

return M
