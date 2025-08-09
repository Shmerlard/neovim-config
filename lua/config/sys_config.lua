local M = {}

-- Detect OS
local is_windows = vim.loop.os_uname().version:match("Windows")

-- Define base config path
local config_path = is_windows
    and "C:/Users/elade/AppData/Local/nvim/lua/config/"
    or vim.fn.expand('~/.config/nvim/lua/config/')

-- Normalize path (Neovim handles `~`, but Windows prefers full path)
M.get_path = function(file)
    return config_path .. file
end

return M
