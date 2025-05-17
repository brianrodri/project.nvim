local errors = require("projects.errors")
local state = require("projects.state")

---@class projects.API
local API = {
  --- Global state for the API.
  ---
  ---@type projects.State
  ---@private
  global_state = state.init(),
}

---@param opts? projects.UserConfig
---@return projects.API
function API.setup(opts)
  API.global_state:resolve(opts)
  return setmetatable({}, API)
end

---@param opts projects.AddProjectOpts
---@return boolean ok, unknown err
function API:add_project(opts) return pcall(self.global_state.add_project, self.global_state, opts) end

---@param opts projects.DeleteProjectOpts
---@return boolean ok, unknown err
function API:delete_project(opts) return pcall(self.global_state.delete_project, self.global_state, opts) end

---@param opts projects.EnterProjectDirectoryOpts|?
---@return boolean ok, unknown err
function API:enter_project_directory(opts) return errors.TODO("API.enter_project_directory", self, opts) end

---@param opts projects.GetRecentProjectsOpts|?
---@return boolean ok, unknown err
function API:get_recent_projects(opts) return errors.TODO("API.get_recent_projects", self, opts) end

return API
