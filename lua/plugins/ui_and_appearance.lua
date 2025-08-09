return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require('catppuccin').setup({
                no_italic = false,
                styles = {
                    keywords = {"italic"}
                }
            })
            -- vim.cmd.colorscheme "catppuccin"
        end
    },

    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd.colorscheme("kanagawa-wave")
            -- vim.cmd.colorscheme("kanagawa-dragon")
        end
    },
    {
        "olimorris/onedarkpro.nvim",
        priority = 999, -- Ensure it loads first
    },

    -- shows the line at the buttom
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        nvim_logo = function()
            return [[  ]]
        end,
        opts = {
            options = {
                icons_enabled = true,
                theme = 'iceberg_dark',
                section_separators = { left = '', right = '' },
                component_separators = { left = '/', right = '\\' },
                disabled_filetypes = {
                    statusline = { "neo-tree" },
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 1000,
                    winbar = 1000,
                },
            },

            sections = {
                lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
                lualine_b = { 'filename' },
                lualine_c = {  },
                lualine_x = { require("config.key_func").get_locked_state, 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },

            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                -- lualine_x = { 'location' },
                lualine_x = {},
                lualine_y = { require("config.key_func").get_locked_state},
                lualine_z = { function() return [[ ]] end },
            },

            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        },
    },

    -- view indentations lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            scope = { enabled = false },
            exclude = {
                filetypes = { "dashboard" },
            }

        },
    },

    -- ufo folding
    -- https://github.com/kevinhwang91/nvim-ufo
    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' },
        opts = {
            provider_selector = function(bufnr, filetype, buftype)
                return { 'treesitter', 'indent' }
            end
        }
    },

    -- shows the possible keys
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        opts = {
            preset = "helix",
            keys = {
                scroll_up = "<S-Tab>",
                scroll_down = "<Tab>"
            },
            sort = { "group" },
        },
        keys = {}
    },

    -- scroll smoothly
    {
        "karb94/neoscroll.nvim",
        opts = {},
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
            dashboard = {
                enabled = true,
                width = 40,
                sections = {
                    { section = "header" },
                    {
                        section = "terminal",
                        pane = 2,
                        cmd = "echo ",
                        height = 5,
                        padding = 1,
                    },
                    { section = "keys", gap = 1, padding = 1 },
                    { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 1, padding = 1 },
                    {
                        pane    = 2,
                        icon    = " ",
                        title   = "Projects",
                        section = "projects",
                        limit   = 10,
                        indent  = 1,
                        padding = 1,
                        dirs    = function()
                            local path = vim.fn.stdpath("data") .. "/snacks/projects.json"
                            if vim.fn.filereadable(path) == 0 then return {} end
                            local lines = vim.fn.readfile(path)
                            local entries = vim.fn.json_decode(table.concat(lines, "\n")) or {}
                            local dirs = {}
                            for _, item in ipairs(entries) do
                                table.insert(dirs, item.path)
                            end
                            return dirs
                        end,
                    },

                    {
                        pane = 2,
                        icon = " ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    { section = "startup" },
                },
            },
            explorer = { enabled = false },
            picker = { enabled = false, },
            indent = { enabled = false },
            input = { enabled = false },
            notifier = { enabled = false },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            bigfile = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
}
