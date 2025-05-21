local Errs = require("projects.utils.errs")
local State = require("projects.state")

local API = {
  ---@private
  ---@type projects.State
  global_state = State.init(),
}

---@param opts? projects.UserOpts
function API.setup(opts) API.global_state:resolve(opts) end

---@param opts? projects.AddProjectOpts
---@return boolean ok, unknown|? err
function API.add_project(opts) return pcall(API.global_state.add_project, API.global_state, opts) end

---@param opts? projects.DeleteProjectOpts
---@return boolean ok, unknown|? err
function API.delete_project(opts) return pcall(API.global_state.delete_project, API.global_state, opts) end

---@param opts? projects.EnterProjectDirectoryOpts|?
---@return boolean ok, unknown|? err
function API.enter_project_directory(opts) return Errs.TODO("API.enter_project_directory", opts) end

---@param opts? projects.GetRecentProjectsOpts|?
---@return boolean ok, unknown|? err
function API.get_recent_projects(opts) return Errs.TODO("API.get_recent_projects", opts) end

return API
