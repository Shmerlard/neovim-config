local sys_config = require('config.sys_config')

-- Reload Keymaps
vim.api.nvim_create_user_command('ReloadKeymaps', function()
    -- dofile(sys_config.get_path("keymaps.lua"))
    package.loaded["config.keymaps"] = nil
    require("config.keymaps").DefaultKeys()
    print("🔄 Keymaps Reloaded!")
end, {})

-- Reload User Commands
vim.api.nvim_create_user_command('ReloadUserCommands', function()
    dofile(sys_config.get_path("nvim_commands.lua"))
    print("🔄 Commands Reloaded!")
end, {})

-- Reload auto commands
vim.api.nvim_create_user_command('ReloadAutoCommands', function()
    dofile(sys_config.get_path("nvim_autocmd.lua"))
    print("🔄 Autocmd Reloaded!")
end, {})

-- Tabs Collapse
vim.api.nvim_create_user_command('TabsCollapse', function()
    vim.cmd('retab')
    print("Tabs -> spaces")
end, {})

-- Load Last Session
vim.api.nvim_create_user_command('LoadLastSession', function()
    -- pcall(vim.cmd, "Neotree close")
    vim.cmd("enew")

    local ok, err = pcall(function() require('persistence').load({ last = true }) end)
    if ok then
        print("Session Loaded")
    else
        print("Error Loading Session: " .. err)
    end
end, {})

-- Toggle CMP
vim.api.nvim_create_user_command('ToggleCMP', function()
    local ok, cmp = pcall(require, 'cmp')
    if not ok then
        print("nvim-cmp not found")
        return
    end

    local cmp_config = cmp.get_config()
    if cmp_config.enabled then
        require('cmp').setup.buffer { enabled = false }
        print("CMP Disabled")
    else
        require('cmp').setup.buffer { enabled = true }
        print("CMP Enabled")
    end
end, {})


-- Close Fold Level
vim.api.nvim_create_user_command("CloseFoldLevel", function(opts)
    local level = tonumber(opts.args) or 1
    require("config.key_func").CloseFoldLevel(level)
end, {
    nargs = "?",
    desc = "Close folds at a specific level (default = 1)",
})

-- clear registers
vim.api.nvim_create_user_command("ClearRegisters", function()
    for r in ('abcdefghijklmnopqrstuvwxyz0123456789'):gmatch('.') do
        vim.fn.setreg(r, '')
    end
    print("Registers a-z and 0-9 cleared.")
end, {})


--------------
local json = vim.fn.json_encode
local decode = vim.fn.json_decode
local notify = vim.notify
local fn = vim.fn

local function normalize(path)
    -- Convert backslashes to forward slashes on Windows for consistency
    return path:gsub("\\", "/")
end

local project_file = normalize(fn.stdpath("data") .. "/snacks/projects.json")

vim.api.nvim_create_user_command("AddProject", function(opts)
    local path = normalize(fn.getcwd())
    local name = opts.args ~= "" and opts.args or fn.fnamemodify(path, ":t")

    -- Ensure file exists
    if fn.filereadable(project_file) == 0 then
        fn.mkdir(fn.fnamemodify(project_file, ":h"), "p") -- ensure directory exists
        fn.writefile({ "[]" }, project_file)
    end

    local data = fn.readfile(project_file)
    local projects = decode(table.concat(data, "\n")) or {}

    for _, proj in ipairs(projects) do
        if normalize(proj.path) == path then
            notify("Project already exists: " .. path, vim.log.levels.INFO)
            return
        end
    end

    table.insert(projects, { name = name, path = path })
    fn.writefile({ json(projects) }, project_file)
    notify("Added project: " .. name .. " (" .. path .. ")", vim.log.levels.INFO)
end, {
    nargs = "?",
    desc = "Add Project",
})


vim.api.nvim_create_user_command("PickProject", function()
    local project_file = vim.fn.stdpath("data") .. "/snacks/projects.json"
    if vim.fn.filereadable(project_file) == 0 then
        vim.notify("No projects file found", vim.log.levels.WARN)
        return
    end

    local data = vim.fn.readfile(project_file)
    local raw_projects = vim.fn.json_decode(table.concat(data, "\n")) or {}

    local items = {}
    for _, p in ipairs(raw_projects) do
        table.insert(items, { name = p.name, path = p.path })
    end

    require("snacks").picker({
        items = items,
        format = function(item)
            return {
                { item.name }, -- display name (e.g. "Neovim")
                { " - " .. item.path, "Comment" },
            }
        end,
        auto_close = true,
        confirm = function(picker, item)
            vim.cmd("cd " .. item.path)
            vim.notify("Changed directory to: " .. item.path, vim.log.levels.INFO)
            picker:close()
        end,
        layout = { preset = "vscode" },
        icons = {
            ui = {
                selected = "",
                unselected = " "

            }
        },
    })
end, {})

-- Copy file path to plus register
vim.api.nvim_create_user_command("CopyFilePath", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    print("Copied: " .. vim.fn.expand("%:p"))
end, {})

-- close hidden buffers
vim.api.nvim_create_user_command("CloseUnusedBuffers", function()
    -- Track all buffers visible in any tab
    local visible = {}
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            local buf = vim.api.nvim_win_get_buf(win)
            visible[buf] = true
        end
    end

    -- Delete all other loaded and listed buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf)
            and vim.bo[buf].buflisted
            and not visible[buf] then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end, {})

-- edit snippets for this buffer
vim.api.nvim_create_user_command("EditSnippets",
    function(opts)
        local ft = vim.bo.filetype
        local snippet_path = vim.fn.stdpath('config') .. '/lua/snippets/' .. ft .. '.lua'
        local open_cmd = opts.args ~= "" and opts.args or "edit"

        if vim.fn.filereadable(snippet_path) == 1 then
            vim.cmd(string.format("%s %s", open_cmd, snippet_path))
        else
            vim.notify('No snippet file found for filetype: ' .. ft, vim.log.levels.WARN)
        end
    end, {
    nargs = "?",
    complete = function(_, _, _)
        return { "edit", "split", "vsplit", "tabedit" }
    end
})

-- luajump for snippets
vim.api.nvim_create_user_command("SnipJump", function ()
    require('luasnip').jump(1)
end,{})

-- toggle window size lock
vim.api.nvim_create_user_command("ToggleWinLock", function()
    local win = vim.api.nvim_get_current_win()
    local fixwidth = vim.wo.winfixwidth
    local fixheight = vim.wo.winfixheight
    vim.wo.winfixwidth = not fixwidth
    vim.wo.winfixheight = not fixheight
    print("winfixwidth: " .. tostring(not fixwidth) .. ", winfixheight: " .. tostring(not fixheight))
end, {})

vim.api.nvim_create_user_command("ToggleUnderscoreWord", function()
    local kw = vim.bo.iskeyword
    if kw:find("_") then
        vim.opt_local.iskeyword:remove("_")
        print("Removed '_' from iskeyword")
    else
        vim.opt_local.iskeyword:append("_")
        print("Added '_' to iskeyword")
    end
end, {})
