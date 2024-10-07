return {
    -- Commenting plugin for nvim
    { "numToStr/Comment.nvim", opts = {} },

    -- Incremental rename
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        config = true,
    },

    -- Ultra fold plugin! Provider is LSP
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufRead",
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
            },
            {
                "K",
                function()
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
            },
        },
        config = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            require("ufo").setup()
        end,
    },

    -- Refactoring tool
    {
        "ThePrimeagen/refactoring.nvim", -- Gr8 streamer btw! :D
        keys = {
            {
                "<leader>r",
                function()
                    require("refactoring").select_refactor()
                end,
                mode = "v",
                noremap = true,
                silent = true,
                expr = false,
            },
        },
        opts = {},
    },

    -- Go forward/backward with square brackets
    {
        "echasnovski/mini.bracketed",
        event = "BufReadPost",
        config = function()
            local bracketed = require("mini.bracketed")
            bracketed.setup({
                file = { suffix = "" },
                window = { suffix = "" },
                quickfix = { suffix = "" },
                yank = { suffix = "" },
                treesitter = { suffix = "n" },
            })
        end,
    },

    -- Better increase/descrease
    {
        "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal,
                    augend.integer.alias.hex,
                    augend.date.alias["%Y/%m/%d"],
                    augend.constant.alias.bool,
                    augend.semver.alias.semver,
                    augend.constant.new({ elements = { "let", "const" } }),
                },
            })
        end,
    },

    {
        "hedyhli/outline.nvim",
        config = function()
            -- Example mapping to toggle outline
            vim.keymap.set(
                "n",
                "<leader>o",
                "<cmd>Outline<CR>",
                { desc = "Toggle Outline" }
            )

            require("outline").setup({
                -- Your setup opts here (leave empty to use defaults)
            })
        end,
    },

    {
        "nvim-cmp",
        dependencies = { "hrsh7th/cmp-emoji" },
        opts = function(_, opts)
            table.insert(opts.sources, { name = "emoji" })
            table.insert(opts.sources, { name = "cody" })
        end,
    },

    -- Dims inactive code portions
    {
        "folke/twilight.nvim",
        opts = {
            dimming = {
                alpha = 0.33,
                inactive = false,
            },
            treesitter = true,
        },
    },
}
