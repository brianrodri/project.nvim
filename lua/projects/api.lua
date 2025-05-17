local config = require("projects.config")
local errors = require("projects.errors")

---@class projects.API
---@field opts projects.UserConfig
local API = {
  ---@private
  ---@type projects.State|?
  persisted_state = nil,
}

---@param opts? projects.UserConfig
---@return projects.API
function API.setup(opts)
  local self = setmetatable({}, API)
  self.opts = config.resolve_opts(opts)
  return self
end

---@return projects.UserConfig
function API:get_options() return vim.deepcopy(self.opts) end

---@param opts projects.RegisterProjectOpts
---@return boolean ok, string|? err
function API:register_project(opts) return errors.TODO("API.register_project", self, opts) end

---@param opts projects.DeleteProjectOpts
---@return boolean ok, string|? err
function API:delete_project(opts) return errors.TODO("API.delete_project", self, opts) end

---@param opts projects.EnterProjectDirectoryOpts|?
---@return boolean ok, string|? err
function API:enter_project_directory(opts) return errors.TODO("API.enter_project_directory", self, opts) end

---@param opts projects.GetRecentProjectsOpts|?
---@return boolean ok, string|? err
function API:get_recent_projects(opts) return errors.TODO("API.get_recent_projects", self, opts) end

return API
