------------------------------------------------------------------
--  _   ___     ___              ___        _   _
-- | \ | \ \   / (_)_ __ ___    / _ \ _ __ | |_(_) ___  _ __  ___
-- |  \| |\ \ / /| | '_ ` _ \  | | | | '_ \| __| |/ _ \| '_ \/ __|
-- | |\  | \ V / | | | | | | | | |_| | |_) | |_| | (_) | | | \__ \
-- |_| \_|  \_/  |_|_| |_| |_|  \___/| .__/ \__|_|\___/|_| |_|___/
--                                   |_|
------------------------------------------------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorlineopt = 'number'

vim.opt.mouse = 'a'

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.tabstop       = 4
vim.opt.expandtab     = true
vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4

vim.opt.undofile    = true

vim.opt.wrap        = false

vim.opt.ignorecase  = true
vim.opt.smartcase   = true

vim.opt.termguicolors = true

vim.opt.virtualedit = "block"
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.signcolumn = 'yes' -- Keep signcolumn on by default

vim.opt.foldcolumn = '0' -- '0' is not bad
vim.opt.foldlevel = 9999 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true



vim.opt.scrolloff = 5 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.hlsearch = true

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds", "terminal"}


local orig = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig(contents, syntax, opts, ...)
end

vim.diagnostic.config({
    virtual_text = { severity = { min = vim.diagnostic.severity.E } },
    underline = { severity = { min = vim.diagnostic.severity.E } },
    virtual_lines = false
})

vim.cmd [[autocmd BufEnter * setlocal formatoptions-=o]]        -- when 'o' on a commented line it wont create a new commented line

vim.opt.showtabline = 1                   -- Always show tabline

vim.g.blink_cmp = true

vim.opt.tabline = "%!v:lua.require('config.key_func').CustomTabTitle()"

