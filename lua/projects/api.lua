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

---@param opts projects.RegisterProjectOpts
---@return boolean ok, string|? err
function API:register_project(opts) return errors.TODO("register_project", self, opts) end

---@param opts projects.DeleteProjectOpts
---@return boolean ok, string|? err
function API:delete_project(opts) return errors.TODO("delete_project", self, opts) end

---@param opts projects.GetRecentProjectsOpts
---@return boolean ok, string|? err
function API:get_recent_projects(opts) return errors.TODO("get_recent_projects", self, opts) end

---@param opts projects.SetPwdOpts
---@return boolean ok, string|? err
function API:set_working_directory(opts) return errors.TODO("set_working_directory", self, opts) end

---@return projects.UserConfig
function API:get_options() return errors.TODO("get_options", self) end

return API
