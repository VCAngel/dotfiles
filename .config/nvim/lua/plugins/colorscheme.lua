return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = function(_, opts)
            -- workaround for `bufferline` intergration
            local bufferline = require("catppuccin.special.bufferline")
            bufferline.get = bufferline.get or bufferline.get_theme

            return {
                flavour = "mocha",
                transparent_background = true,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.2,
                },
                styles = {
                    comments = { "italic" },
                    keywords = { "bold" },
                },
                color_overrides = {},
                lsp_styles = {
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,

                    -- editor.lua
                    flash = true,
                    telescope = {
                        enabled = true,
                    },

                    -- lsp.lua
                    mason = true,

                    -- treesitter.lua
                    treesitter = true,

                    -- ui.lua
                    notify = true,
                    dashboard = true,
                },
            }
        end,
    },

    -- WIP: currently cooking
    -- wallust|pywal|imagemagick colorscheme generator
    --[[ 
    {
        "VCAngel/chameleon.nvim",
        name = "chameleon",
        priority = 1000,
    },
    ]]
}
