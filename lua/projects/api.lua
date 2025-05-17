local errors = require("projects.errors")
local state = require("projects.state")

---@class projects.API
local API = {
  --- Global state for the API.
  ---
  ---@private
  ---@type projects.State|?
  state = nil,
}

---@param opts? projects.UserConfig
---@return projects.API
function API.setup(opts)
  local self = setmetatable({}, API)
  self.state = self.state or state.load_or_init(opts)
  return self
end

---@return projects.UserConfig
function API:get_options() return vim.deepcopy(self.state.opts) end

---@param opts projects.AddProjectOpts
---@return boolean ok, string|? err
function API:add_project(opts) return pcall(self.state.add_project, self.state, opts) end

---@param opts projects.DeleteProjectOpts
---@return boolean ok, string|? err
function API:delete_project(opts) return pcall(self.state.delete_project, self.state, opts) end

---@param opts projects.EnterProjectDirectoryOpts|?
---@return boolean ok, string|? err
function API:enter_project_directory(opts) return errors.TODO("API.enter_project_directory", self, opts) end

---@param opts projects.GetRecentProjectsOpts|?
---@return boolean ok, string|? err
function API:get_recent_projects(opts) return errors.TODO("API.get_recent_projects", self, opts) end

return API
