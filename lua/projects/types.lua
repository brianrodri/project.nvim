-- TODO: Define types.

---@class projects.State

---@class projects.Config
---@field data_dir  projects.Path  Determines where the plugin stores its persistent state.

---@class projects.UserOpts: projects.Config
---@field data_dir? string|fun(): string

---@class projects.AddProjectOpts

---@class projects.DeleteProjectOpts

---@class projects.GetRecentProjectsOpts

---@class projects.EnterProjectDirectoryOpts
