-- TODO: Define types.

---@class projects.UserConfig
---@field data_dir? string|fun(): string  Determines where the plugin stores its persistent state.
---
---@alias projects.UserConfig.Resolver fun(opts_value: any): any

---@class projects.ResolvedConfig: projects.UserConfig
---@field data_dir  projects.Path

---@alias projects.PathLike (string | projects.Path)

---@class projects.AddProjectOpts

---@class projects.DeleteProjectOpts

---@class projects.GetRecentProjectsOpts

---@class projects.EnterProjectDirectoryOpts

---@class projects.State
