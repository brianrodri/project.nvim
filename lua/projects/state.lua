local Errs = require("projects.utils.errs")
local Fmts = require("projects.utils.fmts")

---@class projects.State
local State = {}
State.__index = State
State.__tostring = function(self) return Fmts.class_string(self, "projects.State") end

---@return projects.State
function State.init() return setmetatable({}, State) end

---@return boolean
function State.is_state_obj(obj) return getmetatable(obj) == State end

---@param opts? projects.UserOpts
function State:resolve(opts) Errs.TODO("State.resolve", self, opts) end

---@param opts? projects.AddProjectOpts
function State:add_project(opts) Errs.TODO("State.add_project", self, opts) end

---@param opts? projects.DeleteProjectOpts
function State:delete_project(opts) Errs.TODO("State.delete_project", self, opts) end

return State
