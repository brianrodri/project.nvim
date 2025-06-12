------------------------------------------------------------------------------------------------------------------------
-- Plugin Options
------------------------------------------------------------------------------------------------------------------------

--- A comprehensive set of fields used to configure the plugin's behavior.
---
---@class projects.Config
---@field data_dir projects.Path  The directory used to persist state between Neovim sessions.

--- A relaxed config interface intended for users.
---
---@class projects.SetupOpts: projects.Config
---@field data_dir (fun(): string)|string|?

------------------------------------------------------------------------------------------------------------------------
-- Plugin State
------------------------------------------------------------------------------------------------------------------------

---@class ProjectsState
---@field projects string[]     All projects registered by the user. Paths stay in insertion order.
---@field most_recent string|?  The most recent project entered by the user.

------------------------------------------------------------------------------------------------------------------------
-- API Options
------------------------------------------------------------------------------------------------------------------------

---@class projects.AddProjectOpts

---@class projects.DeleteProjectOpts

---@class projects.GetRecentProjectsOpts<T>
---@field cwd string|?

---@class projects.EnterProjectRootOpts
---@field cwd string|?
---@field prefer_nested_children boolean|?
