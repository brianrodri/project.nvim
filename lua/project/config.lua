local M = {}

---@class ProjectOptions
M.defaults = {
  manual_mode = false,
  detection_methods = { "lsp", "pattern" },
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
  ignore_lsp = {},
  exclude_dirs = {},
  show_hidden = false,
  silent_chdir = true,
  scope_chdir = "global",
  datapath = vim.fn.stdpath("data"),
}

---@type ProjectOptions
M.options = {}

M.setup = function(options)
  M.options = vim.tbl_deep_extend("force", M.defaults, options or {})

  local glob = require("project.utils.globtopattern")
  local home = vim.fn.expand("~")
  M.options.exclude_dirs = vim.tbl_map(function(pattern)
    if vim.startswith(pattern, "~/") then pattern = home .. "/" .. pattern:sub(3, #pattern) end
    return glob.globtopattern(pattern)
  end, M.options.exclude_dirs)

  -- luacheck: no global
  vim.opt.autochdir = false -- implicitly unset autochdir

  require("project.utils.path").init()
  require("project.project").init()
end

return M
