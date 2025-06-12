local errors = require("projects.utils.errors")

local M = {}

---@param opts? projects.SetupOpts
function M.setup(opts) errors.TODO("setup", opts) end

---@param root_dir string
---@param opts? projects.AddProjectOpts
---@return boolean ok, string|? err
function M.add_project(root_dir, opts) return errors.TODO("add_project", root_dir, opts) end

---@param root_dir string
---@param opts? projects.DeleteProjectOpts
---@return boolean ok, string|? err
function M.delete_project(root_dir, opts) return errors.TODO("delete_project", root_dir, opts) end

---@param opts? projects.EnterProjectRootOpts
---@return boolean ok, string|? err
function M.enter_project_root(opts) return errors.TODO("enter_project_root", opts) end

---@param opts? projects.GetRecentProjectsOpts
---@return string[] dirs, string|? err
function M.get_recent_projects(opts) return errors.TODO("get_recent_projects", opts) end

return M
