local config_v1 = require("project-v1.config")
local uv = vim.loop
local M = {}

M.datapath = vim.fn.stdpath("data") -- directory
M.projectpath = M.datapath .. "/project" -- directory
M.historyfile = M.projectpath .. "/project_history" -- file

function M.init()
  M.datapath = require("project-v1.config").options.datapath
  M.projectpath = M.datapath .. "/project" -- directory
  M.historyfile = M.projectpath .. "/project_history" -- file
end

function M.create_scaffolding(callback)
  if callback ~= nil then -- async
    uv.fs_mkdir(M.projectpath, 448, callback)
  else -- sync
    uv.fs_mkdir(M.projectpath, 448)
  end
end

function M.is_excluded(dir)
  for _, dir_pattern in ipairs(config_v1.options.exclude_dirs) do
    if dir:match(dir_pattern) ~= nil then return true end
  end

  return false
end

function M.exists(path) return vim.fn.empty(vim.fn.glob(path)) == 0 end

return M
