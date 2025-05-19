-- TODO: Define types.

---@class projects.UserConfig
---@field data_dir? string|fun(): string  Determines where the plugin stores its persistent state.

---@class projects.ResolvedConfig: projects.UserConfig
---@field data_dir  projects.Path

---@class projects.AddProjectOpts

---@class projects.DeleteProjectOpts

---@class projects.GetRecentProjectsOpts

---@class projects.EnterProjectDirectoryOpts

---@class projects.State
