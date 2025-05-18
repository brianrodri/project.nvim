local Errs = require("projects.utils.errs")
local Fmts = require("projects.utils.fmts")
local Path = require("projects.utils.path")

local PERSISTED_STATE_PATH = "projects.nvim/persisted-state.json"

---@class projects.State
---@field state_path projects.Path
---@field resolved boolean
local State = {
  __tostring = function(self) return Fmts.class_string(self, "projects.State", "state_path", "resolved") end,
}

function State.init()
  local self = setmetatable({}, State)
  self.state_path = Path.stdpath("data"):join(PERSISTED_STATE_PATH)
  self.resolved = false
  return self
end

---@param opts? projects.UserConfig
function State:resolve(opts) Errs.TODO("State.resolve", self, opts) end

---@param opts projects.AddProjectOpts
function State:add_project(opts) Errs.TODO("State.add_project", self, opts) end

---@param opts projects.DeleteProjectOpts
function State:delete_project(opts) Errs.TODO("State.delete_project", self, opts) end

return State
