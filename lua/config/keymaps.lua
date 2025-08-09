local def_opts = { noremap = true, silent = true }

local map = vim.keymap.set

local function map_opts(opts)
    return vim.tbl_extend("force", def_opts, opts or {})
end

local M = {}

M.DefaultKeys = function()
    local key_func = require('config.key_func')
    local sys_config = require('config.sys_config')

    local persist = require("persistence")
    local wk = require('which-key')
    local ls = require('luasnip')
    local neo_tree = key_func.Safe_Require("neo-tree")
    local tel = require('telescope.builtin')
    local dial = require("dial.map")
    ------------------------------------------------
    --             FILE AND PREFERENCES         ----
    ------------------------------------------------
    -- Open Settings
    map('n', '<C-o>k', ':tabnew ' .. sys_config.get_path('keymaps.lua') .. '<CR>',
        map_opts({ desc = '[O]ptions, [K]eymaps' }))
    map('n', '<C-o>s', ':tabnew ' .. sys_config.get_path('nvim_options.lua') .. '<CR>',
        map_opts({ desc = '[O]ptions, [S]ettings' }))
    -- map('n', '<C-o>b', ':tabnew ' .. sys_config.get_path() .. '<CR>',

    --     map_opts({ desc = '[O]ptions, [S]ettings' }))
    vim.keymap.set('n', '<C-o>b', ":EditSnippets tabedit<CR>", { desc = 'Edit snippets for current filetype' })

    ------------------------------------------------
    --                  EDITING                 ----
    ------------------------------------------------
    map('i', 'jk', '<Esc>', def_opts)

    map("i", "<C-BS>", "<C-w>", def_opts)


    -- fast jumping
    map("n", "J", "5j", { noremap = true })
    map("n", "K", "5k", { noremap = true })

    -- deletion
    map({ 'n', 'v' }, 'x', '"zx', def_opts)

    -- changing
    map("n", "c", '"zc', { noremap = true })

    -- swapping 2 text elements
    map("x", "<leader>mw", ":'<,'>SwapVisual<CR>", {})

    -- yanking
    map({ 'n', 'v' }, '<leader>ya', "mzggVGy`z:delmarks z<cr>", map_opts({ desc = "[Y]ank [A]ll" }))
    map("n", "<leader>yf", ":CopyFilePath<CR>", { desc = "[Y]ank [F]ilename" })

    -- pasting
    map("x", "p", [["zdP]], { desc = "Paste without yanking replaced text" })

    -- searching
    map({ 'n', 'v', 'i' }, "<C-f>", "/", def_opts)

    -- swap mode for swapping elements in an array or arguements
    map('n', '<leader>ms', key_func.EnterSwapMode, { desc = "Enter Swap Mode" })

    -- indenting
    map('v', '>', '>gv', def_opts)
    map('v', '<', '<gv', def_opts)

    -- for checking registers
    map("i", "<C-r>", "<CMD>Telescope registers<CR>", def_opts)

    -- Key mappings for increasing and decreasing
    map("n", "<C-a>", function()
        dial.manipulate("increment", "normal") end)
    map("n", "<C-x>", function()
        dial.manipulate("decrement", "normal") end)
    map("n", "g<C-a>", function()
        dial.manipulate("increment", "gnormal") end)
    map("n", "g<C-x>", function()
        dial.manipulate("decrement", "gnormal") end)
    map("v", "<C-a>", function()
        dial.manipulate("increment", "visual") end)
    map("v", "<C-x>", function()
        dial.manipulate("decrement", "visual") end)
    map("v", "g<C-a>", function()
        dial.manipulate("increment", "gvisual") end)
    map("v", "g<C-x>", function()
        dial.manipulate("decrement", "gvisual") end)

    -- Move selected line up and down
    map('n', '<A-Up>', ':m .-2<CR>==', def_opts)
    map('x', '<A-Up>', ":m '<-2<CR>gv=gv", def_opts)
    map('n', '<a-down>', ':m .+1<cr>==', def_opts)
    map('x', '<a-down>', ":m '>+1<cr>gv=gv", def_opts)

    -- surrounding :help nvim-surround.config.keymaps
    require("nvim-surround").setup({
        keymaps = {
            normal = "s",
            normal_cur = "ss",
            normal_line = "S",
            visual = "s",
            viusual_line = "S",

        }
    })
    pcall(vim.keymap.del, 'n', 'ys')
    pcall(vim.keymap.del, 'n', 'yss')
    pcall(vim.keymap.del, 'n', 'yS')
    pcall(vim.keymap.del, 'n', 'ySS')

    -- comment --
    map('n', '<leader>c', '<plug>(comment_toggle_linewise_current)', { desc = 'comment linewise' })
    map('v', '<leader>c', '<plug>(comment_toggle_linewise_visual)', { desc = 'comment linewise' })
    map('v', '<leader>C', '<plug>(comment_toggle_blockwise_visual)', { desc = 'comment block wise' })

    ------------------------------------------------
    --           Tabs and Navigation            ----
    ------------------------------------------------
    map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
    map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
    map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
    map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

    map('n', "<C-w>tn", ":tabnew<CR>", def_opts)

    map('n', "<C-w>w", ":ToggleWinLock<CR>", map_opts({desc = "Toggle Win size lock"}))
    -- tab navigation
    map({ 'n', 'i' }, "<A-k>", "<Esc>:tabnext<CR>", def_opts)
    map({ 'n', 'i' }, "<A-j>", "<Esc>:tabprevious<CR>", def_opts)

    -- splitting
    map('n', "<C-w>s", ":split<CR>")
    map('n', "<C-w>S", ":vsplit<CR>")

    -- go back and forward --
    map('n', 'gb', '<C-o>', { desc = 'Jump back' })
    map('n', 'gB', '<C-i>', { desc = 'Jump forward' })


    -- escape from terminal
    map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

    -- swap select windows
    map('n', '<C-w>x', function() key_func.swap_with_selection() end, map_opts({ desc = "Swap window with selected" }))

    ----------------- Sessions ---------------
    -- load the session for the current directory
    map("n", "<c-o>es", function()
        pcall(function() vim.cmd("Neotree Close") end)
        vim.cmd("enew")
        persist.load()
    end, { desc = "load session for current direcotry" })

    -- select a session to load
    map("n", "<C-o>eS", function() persist.select() end, { desc = "Select session to load" })

    -- load the last session
    map("n", "<C-o>el", "<CMD>LoadLastSession<CR>", { desc = "Load last session" })

    -- stop Persistence => session won't be saved on exit
    map("n", "<C-o>ed", function() persist.stop() end, { desc = "Stop persistence" })



    ------------------------------------------------
    --                  view                    ----
    ------------------------------------------------
    local keys = { "h", "j", "k", "l", "_", "|" }

    for _, key in ipairs(keys) do
        vim.keymap.set("n", "<C-w>" .. key, "<Nop>", { noremap = true })
    end

    -- close with <leader>q
    map('n', '<leader>Q', "<CMD>close<CR>", def_opts)
    -- resize mode
    map('n', '<C-w>r', function()
        key_func.EnterResizeMode()
    end, map_opts({ desc = 'Enter [R]esize Mode' }))




    -- undo tree
    map('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = 'Toggle Undo Tree' })

    -- open terminal
    map('n', '<leader>t', function()
        -- vim.cmd('botright split | terminal')
        vim.cmd('rightbelow split | terminal')
        vim.cmd('resize 10')
    end, { desc = 'Open terminal below current buffer' })

    -- wrapping --
    map('n', 'zw', ':set wrap!<cr>', { desc = 'toggle wrap mode' })

    -- :noh when esc
    map('n', "<Esc>", "<cmd>nohlsearch<CR>")

    -- ufo folding --
    map('n', 'zR', require('ufo').openAllFolds)
    map('n', 'zM', require('ufo').closeAllFolds)
    map('n', 'zg1', ":CloseFoldLevel 1<CR>", { desc = "Close only top-level folds" })
    map('n', 'zg2', ":CloseFoldLevel 2<CR>", { desc = "Close only top-level folds" })
    map('n', 'zg3', ":CloseFoldLevel 3<CR>", { desc = "Close only top-level folds" })
    map('n', 'zg4', ":CloseFoldLevel 4<CR>", { desc = "Close only top-level folds" })

    -- quicklist navigating --
    map('n', ']q', '<cmd>cnext<CR>', { desc = 'Quickfix Next' })
    map('n', '[q', '<cmd>cprev<CR>', { desc = 'Quickfix Previous' })
    map('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Quickfix Open' })
    map('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Quickfix Close' })

    -- map('i', '<C-]>, <')
    vim.keymap.set("i", "<C-n>", "<C-o>:lnext<CR>", { desc = "Next location (insert mode)" })
    vim.keymap.set("i", "<C-p>", "<C-o>:lprev<CR>", { desc = "Previous location (insert mode)" })


    --------------------------  neotree  --------------------------
    if neo_tree then
        map({ 'n', 'i' }, '<A-b>', '<CMD>Neotree toggle position=left<cr>', {silent=true, desc = 'toggle neotree to the side' })
        -- map({ 'n', 'i' }, '<C-b>', '<CMD>Neotree toggle float<cr>', { desc = 'toggle neotree' })
        local window_mappings = {
            ['<C-b>'] = { command = "close_window", nowait = true },
            ['<A-b>'] = { command = "close_window", nowait = true },
            ['l']     = { command = "open", nowait = true },
            ['h']     = { command = "close_node", nowait = true },
            ['<Esc>'] = { command = "close_window", nowait = true },
            ['S']     = { command = "vsplit_with_window_picker", nowait = true },
            ['s']     = { command = "split_with_window_picker", nowait = true },
        }

        local window = { mappings = window_mappings }
        local filesystem = { window = window }
        neo_tree.setup({ filesystem = filesystem, })
    end


    -------------- Telescope -------------------
    map('n', '<leader>sh', tel.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', tel.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sf', tel.find_files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>ss', tel.builtin, { desc = '[S]earch [S]elect Telescope' })
    map('n', '<leader>sw', tel.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', tel.live_grep, { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sd', tel.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sR', tel.resume, { desc = '[S]earch [R]esume' })
    map('n', '<leader>s.', tel.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    map('n', '<leader>sm', tel.marks, { desc = '[S]earch [M]arks' })
    map('n', '<leader>sc', tel.current_buffer_fuzzy_find, { desc = '[S]earch [C]current buffer' })
    map('n', '<leader>sS', tel.lsp_document_symbols, { desc = '[S]earch [S]ymbols' })

    map('n', '<leader>sr', ":GrugFar<CR>", { desc = "[S]earch [R]eplace" })
    map('v', '<leader>sr', ":GrugFarWithin<CR>", { desc = "[S]earch [R]eplace" })

    map('n', '<leader>sF', function()
        tel.lsp_document_symbols({
            symbols = { "Function", "Method" }
        })
    end, { desc = '[S]earch [F]unctions' })

    map('n', '<leader>sW', function()
        tel.grep_string({ search = vim.fn.expand("<cword>"), search_dirs = { vim.fn.expand("%:p") },
        })
    end, { desc = 'Search word under cursor in current buffer (exact)' })


    pcall(vim.keymap.del, 'n', 'grr')
    pcall(vim.keymap.del, 'n', 'gra')
    pcall(vim.keymap.del, 'n', 'grn')
    pcall(vim.keymap.del, 'n', 'gri')
    pcall(vim.keymap.del, 'n', 'grt')

    map('n', 'gr', ":Telescope lsp_references<CR>", { desc = '[G]o [R]eferences' })
    map('n', 'gd', ":Telescope lsp_definitions<CR>", { desc = '[G]o [D]efinitions' })

    ------------------------------------------------
    --                  LSP                     ----
    ------------------------------------------------

    -- renaming occurences
    -- vim.api.nvim_set_keymap('n', '<leader>ln', '<CMD>lua vim.lsp.buf.rename()<CR>',
    --     { noremap = true, silent = true, desc = '[R]ename occurance' })
    map('n', '<leader>ln', '<CMD>lua vim.lsp.buf.rename()<CR>', map_opts({desc = '[R]ename occurance'}) )

    map('n', '<leader>lh', '<CMD>lua vim.lsp.buf.hover()<CR>', { desc = "[L]sp [H]over" })
    map('n', '<leader>lp', "<CMD>lua vim.lsp.buf.format()<CR>", { desc = "[L]sp [P]rettify" })
    map('n', '<leader>lr', "<CMD>lua vim.lsp.buf.references()<CR>", { desc = "[L]sp [R]references" })

    ------------------  LSP Diagnostic  ---------------
    map('n', '<leader>ld', "<CMD>lua vim.diagnostic.setqflist()<CR>", { desc = "[L]sp [P]rettify" })
    -- map('n', '<leader>ld', "<CMD>Telescope diagnostics<CR>", {desc = "[L]sp [D]iagnostics"})
    map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'float diagnostics' })
    map('n', '<leader>E', function()
        pcall(vim.diagnostic.jump, { diagnostic = vim.diagnostic.get_next() })
    end, { desc = "goto next diagnostic" })


    vim.keymap.set('n', '-', function()
            local reveal_file = vim.fn.expand('%:p')
            if (reveal_file == '') then
                reveal_file = vim.fn.getcwd()
            else
                local f = io.open(reveal_file, "r")
                if (f) then
                    f.close(f)
                else
                    reveal_file = vim.fn.getcwd()
                end
            end
            require('neo-tree.command').execute({
                action = "focus",          -- OPTIONAL, this is the default value
                source = "filesystem",     -- OPTIONAL, this is the default value
                position = "left",         -- OPTIONAL, this is the default value
                reveal_file = reveal_file, -- path to file or folder to reveal
                reveal_force_cwd = true,   -- change cwd without asking if needed
            })
        end,
        { desc = "Open neo-tree at current file or working directory" }
    );

    ------------------- blink ----------------------
    require("blink.cmp.config").merge_with({
        keymap = {
            preset = 'none',
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'fallback' },
            ['<Tab>'] = { 'select_next', 'fallback' },

            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<S-CR>'] = { 'accept', 'fallback' },
            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },
    })

    ------------------  Lua snip   -------------------
    map({ "i" }, "<C-K>", function() ls.expand({}) end, { silent = true })
    map({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
    map({ "i", "s" }, "<C-H>", function() ls.jump(-1) end, { silent = true })
    -- map({ "i", "s" }, "<C-E>", function()
    --     if ls.choice_active() then
    --         ls.change_choice(1)
    --     end
    -- end, { silent = true })


    ------------------------------------------------
    --                 WHICH KEY CONFIG         ----
    ------------------------------------------------
    -- wk.register({
    --   ["<C-w>h"] = "which_key_ignore",
    --   ["<C-w>j"] = "which_key_ignore",
    --   ["<C-w>k"] = "which_key_ignore",
    --   ["<C-w>l"] = "which_key_ignore",
    --   ["<C-w>|"] = "which_key_ignore",
    --   ["<C-w>_"] = "which_key_ignore",
    -- }, { mode = "n" })
    -- require("which-key").register({
    --     { "<C-w>_", hidden = true },
    --     { "<C-w>h", hidden = true },
    --     { "<C-w>j", hidden = true },
    --     { "<C-w>k", hidden = true },
    --     { "<C-w>l", hidden = true },
    --     { "<C-w>|", hidden = true },
    -- })
    wk.add(
        {
            { "<C-w>_", hidden = true },
            { "<C-w>h", hidden = true },
            { "<C-w>j", hidden = true },
            { "<C-w>k", hidden = true },
            { "<C-w>l", hidden = true },
            { "<C-w>|", hidden = true },

            { "<C-o>",     group = "Options" },
            { "<C-o>e",    desc = "Session" },
            { "<leader>s", desc = "Search" },
            { "<leader>y", group = "Yanking" },
            { "<leader>l", group = "LSP" },
            { "<leader>U", group = "UNDEFINED YET" },

            { "<leader>b", group = "buffers", expand = function()
                return require("which-key.extras").expand.buf()
            end
            },
        })

    ------------------------------------------------
    --                  Old code                ----
    ------------------------------------------------
end

-- TAG: Treesitter_keymap
M.TreesitterKeys = {
    inc_sel = {
        init_selection = "<leader>v",    -- Start selection mode
        node_incremental = "v",          -- Expand selection up
        node_decremental = "V",          -- Shrink selection
        scope_incremental = "<C-Right>", -- Expand to scope
    },
    text_obj = {
        select = {
            ["af"] = "@function.outer", -- You can use the capture groups defined in textobjects.scm
            ["if"] = "@function.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
            ["ac"] = "@comment.outer",
            -- ["iC"] = "@comment.inner",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            -- You can also use captures from other query groups like `locals.scm`
            -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
        },
        swap = {
            enable        = true,
            swap_next     = {
                ["<leader>ma"] = "@parameter.inner",
                ["<leader>me"] = "@element",
            },
            swap_previous = {
                ["<leader>mA"] = "@parameter.inner", 
                ["<leader>mE"] = "@element",
            },
        }
    }

}

return M
