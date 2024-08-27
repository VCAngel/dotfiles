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
            "rcarriga/nvim-notify",
        },
    },

    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 5000,
            background_colour = "#ffffff",
            render = "wrapped-compact",
        },
    },

    -- buffer line
    {
        "akinsho/bufferline.nvim",
        after = "catppuccin",
        event = "VeryLazy",
        keys = {
            { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
            { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
        },
        opts = {
            options = {
                mode = "tabs",
                -- separator_style = "slant",
                show_buffer_close_icons = false,
                show_close_icon = false,
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get(),
        },
    },

    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            plugins = {
                gitsigns = true,
                tmux = true,
                kitty = { enabled = false, font = "+2" },
            },
        },
        keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    },

    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function(_, opts)
            local logo = [[
                                                  __ 
 _ _ _     _                      _           _  |  |
| | | |___| |___ ___ _____ ___   | |_ ___ ___| |_|  |
| | | | -_| |  _| . |     | -_|  | . | .'|  _| '_|__|
|_____|___|_|___|___|_|_|_|___|  |___|__,|___|_,_|__|
                                                     

██╗   ██╗ ██████╗ █████╗ ███╗   ██╗ ██████╗ ███████╗██╗     
██║   ██║██╔════╝██╔══██╗████╗  ██║██╔════╝ ██╔════╝██║     
██║   ██║██║     ███████║██╔██╗ ██║██║  ███╗█████╗  ██║     
╚██╗ ██╔╝██║     ██╔══██║██║╚██╗██║██║   ██║██╔══╝  ██║     
 ╚████╔╝ ╚██████╗██║  ██║██║ ╚████║╚██████╔╝███████╗███████╗
  ╚═══╝   ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝
                                                            
      ]]

            logo = string.rep("\n", 8) .. logo .. "\n\n"
            opts.config.header = vim.split(logo, "\n")
        end,
    },
}
