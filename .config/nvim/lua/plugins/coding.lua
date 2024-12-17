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
                    require("refactoring").select_refactor({
                        show_success_message = true,
                    })
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
}
