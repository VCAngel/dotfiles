return {
    -- messages, cmdline and the popupmenu
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            return {
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
            }
        end,
        dependencies = {
            "folke/snacks.nvim",
        },
    },

    -- buffer line
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        after = "catppuccin",
        event = "VeryLazy",
        keys = {
            { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
            { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
        },
        config = function()
            require("bufferline").setup({
                highlights = require("catppuccin.special.bufferline").get_theme(),
                options = {
                    mode = "tabs",
                    always_show_bufferline = false,
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    show_tab_indicators = true,
                    separator_style = "slope",
                    themable = true,
                },
            })
        end,
    },

    -- Display keystrokes
    {
        "NStefan002/screenkey.nvim",
        after = "catppuccin",
        event = "VeryLazy",
        lazy = false,
        opts = {},
    },

    -- Discord rich presence
    {
        "andweeb/presence.nvim",
        event = "VeryLazy",
        config = function()
            require("presence"):setup({
                auto_update = true,
                neovim_image_text = "nvim my beloved (´｡• ω •｡`) ♡",
                main_image = "neovim",
                log_level = nil,
                debounce_timeout = 10,
                enable_line_number = false,
                blacklist = {},
                buttons = true,
                file_assets = {},
                show_time = true,
                -- displayed texts
                workspace_text = "▪ [ vibing | %s ]", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
                editing_text = "└> :edit %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
                file_explorer_text = "└> :Explore %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
                git_commit_text = "└[ committing ]", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
                plugin_manager_text = "└[ tunin' nvim ]", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
                reading_text = "└> :view %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
                line_number_text = "└[ %s/%s ]", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
            })
        end,
    },
}
