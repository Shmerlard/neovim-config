return {
    -- Commenting
    {
        'numToStr/Comment.nvim',
        opts = { mappings = false }
    },

    -- Auto Pairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {}
    },

    -- Surrounding
    -- https://github.com/kylechui/nvim-surround
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        opts = { keymaps = {} }
    },

    -- Multicursor
    {
        "mg979/vim-visual-multi",
        init = function()
            vim.g.VM_theme = "purplegray"
            vim.g.VM_mouse_mappings = 1
            -- vim.schedule(function()
            vim.g.VM_maps = {
                ["I BS"] = "",
                ["Goto Next"] = "]v",
                ["Goto Prev"] = "[v",
                ["I CtrlB"] = "<M-b>",
                ["I CtrlF"] = "<M-f>",
                ["I Return"] = "<S-CR>",
                ["I Down Arrow"] = "",
                ["I Up Arrow"] = "",
            }
            -- end)
        end,
    },
    -- {
    --     'mg979/vim-visual-multi',
    --     branch = 'master',
    --     init = function()
    --         vim.g.VM_mouse_mappings = 1
    --         vim.g.VM_maps = {
    --             ['Find Under'] = '<C-n>',
    --
    --         }
    --     end,
    -- },

    -- dial
    {
        "monaqa/dial.nvim",
        config = function()
            local augend = require('dial.augend')
            local default_augends = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.date.alias["%d/%m/%Y"],
                augend.constant.alias.bool,

                augend.decimal_fraction.new { signed = false, point_char = ".", },

                augend.constant.new { elements = { "&&", "||" }, word = false, cyclic = true, },
                augend.constant.new { elements = { "==", "!=" }, word = false, cyclic = true, },
                augend.constant.new { elements = { "True", "False" }, word = false, cyclic = true, },

                augend.user.new {
                    find = require("dial.augend.common").find_pattern("%d+"),
                    add = function(text, addend, cursor)
                        local n = tonumber(text)
                        n = math.floor(n * (2 ^ addend))
                        text = tostring(n)
                        cursor = #text
                        return { text = text, cursor = cursor }
                    end
                }
            }

            local vhdl_augends = vim.list_extend({
                    augend.constant.new { elements = { "in", "out" }, word = false, cyclic = true, },
                },
                vim.deepcopy(default_augends)
            )

            require("dial.config").augends:on_filetype({
                vhdl = vhdl_augends
            })

            require("dial.config").augends:register_group {
                default = default_augends
            }
        end
    },

    -- unicode
    {
        'chrisbra/unicode.vim',
        init = function()
            vim.g.Unicode_no_default_mappings = true
        end
    },
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({ 
                app = {"vivaldi-stable", "--new-window", "--user-data-dir='/home/elad/.vivaldi-clean'"}})
                -- app = {"vivaldi-stable", "--new-window"}})
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
    --[[ {
        "obsidian-nvim/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        ---@module 'obsidian'
        ---@type obsidian.config
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/Desktop/test/obisidian_test/",
                },
            },

            -- see below for full list of options 👇
        },
    } ]]
}
