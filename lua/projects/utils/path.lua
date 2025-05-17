local errors = require("projects.errors")
local fmt = require("projects.utils.fmt")

---@class projects.Path
---@field path string
---@field resolved boolean
local Path = {
  __tostring = function(self) return fmt.class_string(self, "projects.Path", "path", "resolved") end,

  ---@private
  ---@type table<string, uv.fs_stat.result>
  global_status_cache = {},
}

--- Returns true if obj was created with Path.new().
---
---@param obj any
function Path.is_path_obj(obj)
  if getmetatable(obj) ~= Path then return false end
  ---@cast obj projects.Path
  return true
end

--- Wrapper around |vim.fs.joinpath|.
---
--- NOTE: This function is the "constructor" of this class!
---
---@param base projects.Path|string     The base path (absolute or relative).
---@param ... projects.Path|string|nil  Zero or more relative paths. Ignores `nil` values.
---@return projects.Path joined_path    The concatenated path.
function Path.join(base, ...)
  if select("#", ...) == 0 and Path.is_path_obj(base) then ---@cast base projects.Path
    return base
  end
  local path_parts = vim.tbl_map(function(p) return Path.is_path_obj(p) and p.path or p end, { base, ... })
  local ok, result = pcall(vim.fs.joinpath, unpack(path_parts))
  assert(ok, fmt.call_error(result, "Path.new", base, ...))
  local self = setmetatable({}, Path)
  self.path = result
  self.resolved = false
  return self
end

--- Wrapper around |nvim_buf_get_name|.
---
---@param buffer_id? integer  Use 0 for current buffer (defaults to 0).
function Path.of_buffer(buffer_id)
  local ok, result = pcall(vim.api.nvim_buf_get_name, buffer_id or 0)
  assert(ok, fmt.call_error(result, "Path.of_buffer", buffer_id))
  return Path.join(result)
end

--- Wrapper around |stdpath|.
---
---@param what
---| "cache"        Cache directory: arbitrary temporary storage for plugins, etc.
---| "config"       User configuration directory. |init.vim| is stored here.
---| "config_dirs"  Other configuration directories.
---| "data"         User data directory.
---| "data_dirs"    Other data directories.
---| "log"          Logs directory (for use by plugins too).
---| "run"          Run directory: temporary, local storage for sockets, named pipes, etc.
---| "state"        Session state directory: storage for file drafts, swap, undo, |shada|.
---
---@overload fun(what: "cache" | "config" | "data" | "log" | "run" | "state", ...: projects.Path|string): projects.Path
---@overload fun(what: "config_dirs" | "data_dirs"): projects.Path[]
function Path.stdpath(what, ...)
  local ok, result = pcall(vim.fn.stdpath, what)
  assert(ok, fmt.call_error(result, "Path.stdpath", what, ...))
  return type(result) == "table" and vim.iter(result):map(Path.join):totable() or Path.join(result, ...)
end

--- Wrapper around |io.open| to ensure that |file:close()| is always called.
---
---@param mode openmode
---@param file_consumer fun(path: file*)
function Path:with_file(mode, file_consumer)
  local file, open_err = io.open(self.path, mode)
  assert(file, fmt.call_error(open_err, "Path.with_file", self.path, mode, file_consumer))
  local call_ok, call_err = pcall(file_consumer, file)
  local close_ok, close_err, close_err_code = file:close()
  local root_cause = errors.join(call_err, close_err and string.format("%s(%d)", close_err, close_err_code))
  assert(call_ok and close_ok, fmt.call_error(root_cause, "Path.with_file", self.path, mode, file_consumer))
end

--- Wrapper around |fs_mkdir|.
---
---@param mode? integer  octal `chmod(1)` mode. Default value is 448 (`0700` in octal), i.e. only user has full access.
---                      See: https://quickref.me/chmod.html.
function Path:make_directory(mode)
  local ok, err = pcall(vim.uv.fs_mkdir, self.path, mode or 448)
  assert(ok, fmt.call_error(err, "Path.make_directory", self.path, mode))
end

--- Wrapper around |fs_realpath|.
---
--- NOTE: This mutates `self`!
---
---@param force_sys_call? boolean  Always make system calls when true, even if the path has already been resolved.
---@return projects.Path
function Path:resolve(force_sys_call)
  if not self.resolved or force_sys_call then
    self.resolved = false
    local realpath, err, err_name = vim.uv.fs_realpath(self.path)
    assert(realpath, fmt.call_error(string.format("%s: %s", err_name, err), "Path.resolve", self.path))
    self.path, self.resolved = realpath, true
  end
  return self
end

--- Wrapper around |fs_stat|.
---
---@param force_sys_call? boolean  Always make system calls when true, even if the status has already been resolved.
---@return uv.fs_stat.result
function Path:status(force_sys_call)
  assert(self.resolved, fmt.call_error("Path.resolve() needs to be called first", "Path.status", self.path))
  if not Path.global_status_cache[self.path] or force_sys_call then
    Path.global_status_cache[self.path] = nil
    local stat, err, err_name = vim.uv.fs_stat(self.path)
    assert(stat, fmt.call_error(string.format("%s: %s", err_name, err), "Path.status", self.path))
    Path.global_status_cache[self.path] = stat
  end
  return Path.global_status_cache[self.path]
end

--- Wrapper around |vim.fn.isdirectory|.
---
---@return boolean
function Path:is_directory() return vim.fn.isdirectory(self.path) == 1 end

--- Wrapper around |vim.fs.dirname|.
---
---@return projects.Path|?
function Path:parent()
  local dirname = vim.fs.dirname(self.path)
  return dirname and Path.join(dirname)
end

--- Wrapper around |vim.fs.root|.
---
---@param marker
---| string                             A marker to search for.
---| string[]                           A list of markers to search for.
---| fun(path: projects.Path): boolean  A function that returns true if matched.
---@return projects.Path|?
function Path:find_root(marker)
  local root = vim.fs.root(self.path, function(_, path) return marker(Path.join(path)) end)
  return root and Path.join(root)
end

--- Returns true if both paths point to the same file in memory.
---
---@param arg1 projects.Path|string
---@param arg2 projects.Path|string
---@param force_sys_call? boolean    Always make system calls when true, even if the paths have already been resolved.
---@return boolean
function Path.is_same(arg1, arg2, force_sys_call)
  local path1, path2 = Path.join(arg1), Path.join(arg2)
  if path1.path == path2.path and (path1.resolved or path2.resolved) then return true end
  local stat1, stat2 = path1:status(force_sys_call), path2:status(force_sys_call and path2.path ~= path1.path)
  return stat1.dev == stat2.dev and stat1.ino == stat2.ino
end

return Path
