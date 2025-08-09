return {

    -- tree navigator
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        lazy = true,

        ---@module "neo-tree"
        ---@type neotree.Config?
        opts = {
            window = {
                preserve_window_proportions = true,
                position = "float",
                auto_expand_width = true,
                -- auto_resize = false,
            }

        },
    },

    -- selects the window
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        opts = {
            hint = "floating-big-letter"
        }
    },

    -- nvim origami
    {
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        tag = 'v1.9',
        opts = {}, -- needed even when using default config


        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },

    -- marks
    -- https://github.com/chentoast/marks.nvim
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- cppman
    -- https://github.com/madskjeldgaard/cppman.nvim
    -- {
    --     "madskjeldgaard/cppman.nvim",
    --     dependencies = { "MunifTanjim/nui.nvim" },
    --     config = function()
    --         require('cppman').setup()
    --     end
    -- },
    -- {
    --     'chomosuke/typst-preview.nvim',
    --     lazy = false, -- or ft = 'typst'
    --     version = '1.*',
    --     opts = {}, -- lazy.nvim will implicitly calls `setup {}`
    -- }
}
