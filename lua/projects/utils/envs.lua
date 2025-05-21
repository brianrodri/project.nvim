local Envs = {}

--- Returns whether the Neovim instance is running on WSL (Windows).
function Envs.is_wsl() return vim.fn.has("wsl") == 1 end

return Envs
