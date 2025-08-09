vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd("setlocal winfixheight")
    end,
})


-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


vim.api.nvim_create_autocmd("SessionLoadPost", {
    once=true,
    callback = function ()
        vim.defer_fn(function() print("SESSION LOADED") end, 10)
    end
})


vim.api.nvim_create_autocmd("FileType", {
    pattern = "neo-tree",
    callback = function()
        vim.cmd("setlocal winfixwidth") -- lock width instead of height for side view
    end,
})


-- auto save
vim.g.autosave_on_insert_leave = false
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if vim.g.autosave_on_insert_leave
      and vim.bo.modifiable
      and vim.bo.modified
      and vim.fn.getbufvar('%', '&buftype') == ""
    then
      vim.cmd("silent! write")
    end
  end,
})


vim.api.nvim_create_user_command("ToggleAutoSave", function()
  vim.g.autosave_on_insert_leave = not vim.g.autosave_on_insert_leave
  print("AutoSave on InsertLeave: " .. (vim.g.autosave_on_insert_leave and "ON" or "OFF"))
end, {})


vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        vim.wo.cursorline = true
    end,
})


vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
        vim.wo.cursorline = false
    end,
})
