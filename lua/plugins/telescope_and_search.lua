return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                mappings = {
                    n = {
                        ["x"] = { require("telescope.actions.layout").toggle_preview, type = "action", opts = { nowait = true } },
                        ["s"] = { require("telescope.actions").select_horizontal, type = "action", opts = { nowait = true } },
                        ["S"] = { require("telescope.actions").select_vertical, type = "action", opts = { nowait = true } },
                        ["t"] = { require("telescope.actions").select_tab, type = "action", opts = { nowait = true } },
                    }
                },
                layout_strategy = 'horizontal',
                winblend = 0,
                sorting_strategy = "ascending",
                -- multi_icon = " ",
                -- entry_prefix = "  ",
                -- selection_cater = "- ",
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

                layout_config = {
                    horizontal = {
                        height = 0.7,
                        width = 0.8,
                        prompt_position = 'top',
                        preview_width = 0.6,
                    }
                }
            }
        }

    },

    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extentions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown {} }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    },

    -- find and replace
    {
        'MagicDuck/grug-far.nvim',
        opts = {}
    },
}
