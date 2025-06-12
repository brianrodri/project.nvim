local Path = require("projects.models.path")
local formats = require("projects.utils.formats")

--- A comprehensive set of fields used to configure the plugin's behavior.
---
--- NOTE: Individual fields are defined in the |CONFIG RESOLVER DEFINITIONS| section.
---
---@class projects.Config
local DEFAULT_CONFIG = {}

--- Functions for resolving/validating individual config fields.
---
--- Each function receives user-provided options and returns a value for their corresponding field.
--- Otherwise, if the input is invalid or unresolvable, then an error message is thrown describing the issue(s).
---
---@class projects.Config.Resolvers
---@private
local CONFIG_RESOLVERS = {}

local M = {}

--- Returns a valid config from the user-provided options. Otherwise, throws an error message describing the issue(s).
---
---@param setup_opts projects.SetupOpts|?
---@return projects.Config
function M.from_setup_opts(setup_opts)
  local resolved_config = vim.deepcopy(DEFAULT_CONFIG, true)
  local resolve_errors = vim
    .iter(vim.tbl_keys(DEFAULT_CONFIG))
    :map(function(field_name)
      local ok, err = pcall(function() resolved_config[field_name] = CONFIG_RESOLVERS[field_name](setup_opts) end)
      if not ok then return formats.call_error(err, "resolve_field", field_name) end
    end)
    :totable()
  assert(#resolve_errors == 0, formats.call_error(formats.merge_lines(resolve_errors), "from_setup_opts", setup_opts))
  return resolved_config
end

------------------------------------------------------------------------------------------------------------------------
-- CONFIG RESOLVER DEFINITIONS
------------------------------------------------------------------------------------------------------------------------

--- The directory used to persist state between Neovim sessions.
DEFAULT_CONFIG.data_dir = Path.new(vim.fn.stdpath("data"), "projects-nvim")

---@param opts? projects.SetupOpts
CONFIG_RESOLVERS.data_dir = function(opts)
  local user_value = opts and opts.data_dir
  if not user_value then return end
  if type(user_value) == "function" or vim.is_callable(user_value) then user_value = user_value() end
  local data_dir = Path.new(user_value):normalize()
  assert(data_dir:mkdir(), "failed to access directory")
  return data_dir
end

return M
