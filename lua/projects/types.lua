-- TODO: Define types.

---@alias projects.PathLike (string | projects.Path)

---@class projects.UserConfig
---
--- Determines where the plugin stores its persistent state.
---@field data_dir? string|fun(): string

---@class projects.AddProjectOpts

---@class projects.DeleteProjectOpts

---@class projects.GetRecentProjectsOpts

---@class projects.EnterProjectDirectoryOpts

---@class projects.State
