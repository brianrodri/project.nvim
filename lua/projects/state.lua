local errors = require("projects.errors")
local fmt = require("projects.utils.fmt")

---@class projects.State
---@field opts projects.UserConfig
local State = {}

---@return string
function State:__tostring() return fmt.class_string(self, "projects.State", "state_path", "history_path") end

---@param opts? projects.UserConfig
---@return projects.State
function State.load_or_init(opts) return errors.TODO("State.load_or_init", opts) end

function State:sync_projects() return errors.TODO("State.sync_projects", self) end

---@param opts projects.AddProjectOpts
function State:add_project(opts) return errors.TODO("State.add_project", self, opts) end

---@param opts projects.DeleteProjectOpts
function State:delete_project(opts) return errors.TODO("State.delete_project", self, opts) end

return State
