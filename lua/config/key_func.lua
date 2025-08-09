-- key_func.lua

local M = {}

local session_dir = vim.fn.stdpath("data") .. "/sessions"
vim.fn.mkdir(session_dir, "p") -- ensure folder exists

vim.api.nvim_set_hl(0, "SpecialModeMessage", { fg = "#ffffff", bg = "#ff0000", bold = true })

local function mode_message(opts)
    vim.api.nvim_echo({ { opts , "SpecialModeMessage" }, }, false, {})
end


-- Safe Require
function M.Safe_Require(name)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.notify(name .. " not loaded", vim.log.levels.WARN)
    return nil
  end
  return mod
end

------------- RESIZE MODE ---------------
local resize_keys = {
    h = '<C-w>>' , l = '<C-w><' , j = '<C-w>-' , k = '<C-w>+',
    H = '5<C-w>>', L = '5<C-w><', J = '5<C-w>-', K = '5<C-w>+',
}

function M.EnterResizeMode()
    -- print("Resize Mode: Use h/j/k/l. Press <Esc> to exit.")
    mode_message("Resize Mode: Use h/j/k/l. Press <Esc> to exit.")

    for key, cmd in pairs(resize_keys) do
        vim.keymap.set('n', key, cmd, { noremap = true, silent = true, buffer = 0 })
    end

    vim.keymap.set('n', '<Esc>', function()
        M.ResetResizeMode()
    end, { noremap = true, silent = true, buffer = 0 })
end

function M.ResetResizeMode()
    for key, _ in pairs(resize_keys) do
        pcall(vim.keymap.del, 'n', key, { buffer = 0 })
    end
    pcall(vim.keymap.del, 'n', '<Esc>', { buffer = 0 })

    vim.wo.winfixheight = true
    vim.wo.winfixwidth = true

    print("Exited Resize Mode")
end


------ Swap Mode    ---------------
local swap_keys = {
    k = function() vim.cmd("TSTextobjectSwapPrevious      @element") end,
    j = function() vim.cmd("TSTextobjectSwapNext          @element") end,
    h = function() vim.cmd("TSTextobjectGotoPreviousStart @element") end,
    l = function() vim.cmd("TSTextobjectGotoNextStart     @element") end,
}

function M.EnterSwapMode()
    mode_message("Swap Mode: Use h/l to swap @element. <Esc> to exit.")
    for key, fn in pairs(swap_keys) do
        vim.keymap.set('n', key, fn, { noremap = true, silent = true, buffer = 0 })
    end
    vim.keymap.set('n', '<Esc>', M.ResetSwapMode, { noremap = true, silent = true, buffer = 0 })
end

function M.ResetSwapMode()
    for key, _ in pairs(swap_keys) do
        pcall(vim.keymap.del, 'n', key, { buffer = 0 })
    end
    pcall(vim.keymap.del, 'n', '<Esc>', { buffer = 0 })

    print("Exited Swap Mode")
end


-- swap windows
function M.swap_with_selection()
    local window_picker = require('window-picker')
    local target_win = window_picker.pick_window({ include_current_win = false })
    if target_win then
        local cur_win = vim.api.nvim_get_current_win()
        local cur_buf = vim.api.nvim_win_get_buf(cur_win)
        local target_buf = vim.api.nvim_win_get_buf(target_win)

        vim.api.nvim_win_set_buf(cur_win, target_buf)
        vim.api.nvim_win_set_buf(target_win, cur_buf)
    end
end

function M.CustomTabTitle()
    local s = ""
    for i = 1, vim.fn.tabpagenr('$') do
        local winnr = vim.fn.tabpagewinnr(i)
        local buflist = vim.fn.tabpagebuflist(i)
        local bufnr = buflist[winnr]
        local name = vim.fn.bufname(bufnr)
        local ft = vim.bo[bufnr].filetype  -- get filetype of buffer

        local display_name
        if ft == "neo-tree" then
            display_name = "NeoTree" -- your custom name here
        else
            local fname = vim.fn.fnamemodify(name, ":t")
            display_name = fname ~= "" and fname or "[No Name]"
        end

        local ext = vim.fn.fnamemodify(name, ":e")
        local icon = require('nvim-web-devicons').get_icon(display_name, ext, { default = true }) or "󰈚"

        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end
        s = s .. " " .. icon .. " " .. i .. ":" .. display_name .. " "
    end
    s = s .. "%#TabLineFill#"
    return s
end

function M.get_locked_state()
    local winid = vim.api.nvim_get_current_win()
    local winopts = vim.wo[winid]
    if winopts.winfixwidth or winopts.winfixheight then
        return ""
    end
    return ""
end

function M.CloseFoldLevel(level)
    level = level or 2
    vim.cmd("normal! zR") -- open all folds first
    local last_line = vim.fn.line("$")
    for lnum = 1, last_line do
        if vim.fn.foldlevel(lnum) == level and vim.fn.foldclosed(lnum) == -1 then
            -- Only close if this line starts a fold
            local fold_start = vim.fn.foldlevel(lnum) > 0 and vim.fn.foldclosed(lnum) == -1
            if fold_start and vim.fn.foldlevel(lnum - 1) < level then
                vim.cmd(lnum .. "foldclose")
            end
        end
    end
end


return M
