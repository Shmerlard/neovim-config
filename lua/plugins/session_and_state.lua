return {
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            -- add any custom options here
        }
    },

    {
        'mbbill/undotree'
    },
    -- {
    --     "NeogitOrg/neogit",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim", -- required
    --         -- "sindrets/diffview.nvim", -- optional - Diff integration
    --
    --         -- Only one of these is needed.
    --         "nvim-telescope/telescope.nvim", -- optional
    --     },
    -- },
    -- {
    --     "alex-popov-tech/store.nvim",
    --     dependencies = {
    --         "OXY2DEV/markview.nvim", -- optional, for pretty readme preview / help window
    --     },
    --     cmd = "Store",
    --     keys = {
    --     },
    --     opts = {
    --         -- optional configuration here
    --     },
    -- }
}
