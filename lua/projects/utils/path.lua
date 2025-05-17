local errors = require("projects.errors")
local fmt = require("projects.utils.fmt")

---@class projects.Path
---@field path_str string
---@field resolved boolean
local Path = {
  __tostring = function(self) return fmt.class_string(self, "projects.Path", "path_str", "resolved") end,
  __div = function(self, other) return self:new(other) end,
  ---@private
  ---@type table<string, uv.fs_stat.result>
  _STATUS_CACHE = {},
}

--- Returns true if obj was created with Path.new().
---
---@overload fun(obj: unknown): boolean
---@overload fun(obj: projects.Path): true
function Path.is_path_obj(obj)
  if getmetatable(obj) == Path then ---@cast obj projects.Path
    return true
  end
  return false
end

--- Wrapper around |vim.fs.joinpath|.
---
---@param base projects.Path|string The base path (absolute or relative)
---@param ... projects.Path|string|nil Zero or more relative paths. Ignores `nil` values.
---@return projects.Path joined_path
function Path.new(base, ...)
  if select("#", ...) == 0 and Path.is_path_obj(base) then ---@cast base projects.Path
    return base
  end
  local path_parts = vim.tbl_map(function(p) return Path.is_path_obj(p) and p.path_str or p end, { base, ... })
  local ok, result = pcall(vim.fs.joinpath, unpack(path_parts))
  assert(ok, fmt.call_error(tostring(result), "Path.new", base, ...))
  local self = setmetatable({}, Path)
  self.path_str = result
  self.resolved = false
  return self
end

--- Wrapper around |nvim_buf_get_name|.
---
---@param buffer_id? integer Use 0 for current buffer (defaults to 0)
function Path.of_buffer(buffer_id)
  local ok, result = pcall(vim.api.nvim_buf_get_name, buffer_id or 0)
  assert(ok, fmt.call_error(tostring(result), "Path.of_buffer", buffer_id))
  return Path.new(result)
end

--- Wrapper around |stdpath|.
---
---@overload fun(what: "cache" | "config" | "data" | "log" | "run" | "state", ...: projects.Path|string): projects.Path
---@overload fun(what: "config_dirs" | "data_dirs"): projects.Path[]
function Path.stdpath(what, ...)
  local ok, result = pcall(vim.fn.stdpath, what)
  assert(ok, fmt.call_error(tostring(result), "Path.stdpath", what, ...))
  return type(result) == "table" and vim.iter(result):map(Path.new):totable() or Path.new(result, ...)
end

--- Wrapper around |io.open|.
---
---@param mode openmode
---@param file_consumer fun(path: file*)
function Path:with_file(mode, file_consumer)
  local file, open_err = io.open(self.path_str, mode)
  assert(file, fmt.call_error(open_err, "Path.with_file", self, mode, file_consumer))
  local call_ok, call_err = pcall(file_consumer, file)
  local close_ok, close_err, close_err_code = file:close()
  local root_cause = errors.join(call_err, close_err and string.format("%s(%d)", close_err, close_err_code))
  assert(call_ok and close_ok, fmt.call_error(root_cause, "Path.with_file", self, mode, file_consumer))
end

--- Wrapper around |fs_mkdir|.
---
---@param mode? integer octal `chmod(1)` mode. Default value is 448 (`0700` in octal), i.e. only user has full access.
---                     See: https://quickref.me/chmod.html.
function Path:make_directory(mode)
  local ok, err = pcall(vim.uv.fs_mkdir, self.path_str, mode or 448)
  assert(ok, fmt.call_error(err, "Path.make_directory", self, mode))
end

--- Wrapper around |fs_realpath|.
---
--- NOTE: This mutates `self`!
---
---@param force_sys_call? boolean Always make system calls when true, even if the path has already been resolved.
---@return projects.Path
function Path:resolve(force_sys_call)
  if not self.resolved or force_sys_call then
    self.resolved = false
    local realpath, err, err_name = vim.uv.fs_realpath(self.path_str)
    assert(realpath, fmt.call_error(string.format("%s: %s", err_name, err), "Path.resolve", self))
    self.path_str, self.resolved = realpath, true
  end
  return self
end

--- Wrapper around |fs_stat|.
---
---@param force_sys_call? boolean Always make system calls when true, even if the status has already been resolved.
---@return uv.fs_stat.result
function Path:status(force_sys_call)
  assert(self.resolved, fmt.call_error("Path.resolve() needs to be called first", "Path.status", self))
  if not Path._STATUS_CACHE[self.path_str] or force_sys_call then
    Path._STATUS_CACHE[self.path_str] = nil
    local stat, err, err_name = vim.uv.fs_stat(self.path_str)
    assert(stat, fmt.call_error(string.format("%s: %s", err_name, err), "Path.status", self))
    Path._STATUS_CACHE[self.path_str] = stat
  end
  return Path._STATUS_CACHE[self.path_str]
end

--- Wrapper around |vim.fn.isdirectory|.
---
---@return boolean
function Path:is_directory() return vim.fn.isdirectory(self.path_str) == 1 end

--- Wrapper around |vim.fs.dirname|.
---
---@return projects.Path|?
function Path:parent()
  local dirname = vim.fs.dirname(self.path_str)
  return dirname and Path.new(dirname)
end

--- Wrapper around |vim.fs.root|.
---
---@param marker
---| string A marker to search for.
---| string[] A list of markers to search for.
---| fun(name: string, path: string): boolean A function that returns true when matched.
---@return projects.Path|?
function Path:find_root(marker)
  local root = vim.fs.root(self.path_str, marker)
  return root and Path.new(root)
end

--- Returns true if both paths point to the same file in memory.
---
---@param arg1 projects.Path|string
---@param arg2 projects.Path|string
---@param force_sys_call? boolean Always make system calls when true, even if the paths have already been resolved.
---@return boolean
function Path.is_same(arg1, arg2, force_sys_call)
  local path1, path2 = Path.new(arg1), Path.new(arg2)
  if path1.path_str == path2.path_str and (path1.resolved or path2.resolved) then return true end
  local stat1, stat2 = path1:status(force_sys_call), path2:status(force_sys_call and path2.path_str ~= path1.path_str)
  return stat1.dev == stat2.dev and stat1.ino == stat2.ino
end

return Path
