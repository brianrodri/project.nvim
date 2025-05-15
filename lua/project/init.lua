local config = require("project.config")
local history = require("project.utils.history")
local M = {}

M.setup = config.setup
M.get_recent_projects = history.get_recent_projects

return M
