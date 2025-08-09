return {
    -- tree sitter
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        opts = {
            ensure_installed      = { 'arduino', 'lua', 'c', 'bash', 'markdown', 'vim', 'rasi', 'cpp', 'python', 'vimdoc', 'query' },
            auto_install          = true,
            highlight             = { enable = true },
            indent                = { enable = true, disable = { "c", "cpp" } },
            incremental_selection = {
                enable = true,
                keymaps = require("config.keymaps").TreesitterKeys.inc_sel
            },
            -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
            textobjects           = {
                select = {
                    enable = true,
                    lookahead = true,

                    -- See Treesitter_keymap
                    -- See M.TreesitterKeys

                    keymaps = require("config.keymaps").TreesitterKeys.text_obj.select,
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        -- ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    include_surrounding_whitespace = false,
                },
                swap = require("config.keymaps").TreesitterKeys.text_obj.swap,

            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- { "neovim/nvim-lspconfig", },

    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     -- lazy = true,
    --     dependencies = { "mason.nvim" },
    --     config = function()
    --         require("mason-lspconfig").setup({
    --             automatic_enable = false, -- removes multiple lsp servers
    --         })
    --     end
    -- },

    -- mason
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end
    },

    -- Lazydev
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Blink.cmp
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        },
        version = '1.*',
        event = "InsertEnter",
        keys = {
            {
                '<C-o>c',
                function()
                    vim.g.blink_cmp = not vim.g.blink_cmp
                    if vim.g.blink_cmp then
                        print("Blink.cmp is enabled")
                    else
                        print("Blink.cmp is disabled")
                    end
                end,
                desc = 'Toggle completions'
            }
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'none', },

            enabled = function()
                return vim.g.blink_cmp ~= false
            end,

            appearance = { nerd_font_variant = 'mono' },

            sources = {
                default = { "lazydev", "lsp", "path", "snippets" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            completion = { documentation = { auto_show = false } },
            snippets = { preset = 'luasnip' },
            signature = { enabled = true },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },

    -- luasnip
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_lua").lazy_load({
                paths = { "~/dotfiles/nvim/lua/snippets" }
            })
        end
    },
}
