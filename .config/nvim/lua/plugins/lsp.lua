---@type LazySpec
return {
    ---@module 'blink.cmp'
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
        -- use a release tag to download pre-built binaries
        version = "v0.*",

        ---@type blink.cmp.Config
        opts = {
            enabled = function()
                return true
            end,
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = { preset = "enter" },
            appearance = {
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },
            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = { "lsp", "path", "luasnip", "buffer" },
                -- optionally disable cmdline completions
                -- cmdline = {},
            },

            -- experimental signature help support
            -- signature = { enabled = true }
        },
        -- allows extending the providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.default" },
    },

    -- mason lsps
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "angular-language-server",
                "stylua",
                "selene",
                "luacheck",
                "shellcheck",
                "shfmt",
                "tailwindcss-language-server",
                "deno",
                "css-lsp",
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function() end,
    },

    -- lsp config and servers
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig")
            -- Configure each server inside `opts`
            for server, config in pairs(opts.servers) do
                -- passing config.capabilities to blink.cmp merges with the capabilities in
                -- `opts[server].capabilities, if defined

                config.capabilities = require("blink.cmp").get_lsp_capabilities(
                    config.capabilities
                )
                config.capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                }
                lspconfig[server].setup(config)
            end
        end,
        opts = {
            inlay_hints = { enabled = true },
            ---@type  table<lspconfig.Config>
            servers = {
                cssls = {},
                tailwindcss = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(
                            ...
                        )
                    end,
                },
                ---@type lspconfig.Config
                denols = {
                    cmd = { "deno", "lsp" },
                    cmd_env = { NO_COLOR = true },
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "javascript.jsx",
                        "typescript",
                        "typescriptreact",
                        "typescript.tsx",
                    },
                    root_dir = require("lspconfig.util").root_pattern(
                        "deno.json",
                        "deno.jsonc"
                    ),
                    on_attach = function()
                        LazyVim.notify("Attached...", {
                            level = 2,
                            title = "denols",
                            stacklevel = 3,
                        })
                    end,
                    settings = {
                        deno = {
                            enable = true,
                            lint = true,
                            suggest = {
                                imports = {
                                    hosts = {
                                        ["https://deno.land"] = true,
                                        ["https://jsr.io"] = true,
                                        ["https://npmjs.com"] = true,
                                    },
                                },
                            },
                        },
                    },
                    single_file_support = false,
                },
                html = {},
                yamlls = {
                    settings = {
                        yaml = {
                            keyOrdering = false,
                        },
                    },
                },
                lua_ls = {
                    single_file_support = true,
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                workspaceWord = true,
                                callSnippet = "Both",
                            },
                            misc = {
                                parameters = {},
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                            },
                            doc = {
                                privateName = { "^_" },
                            },
                            type = {
                                castNumberToInteger = true,
                            },
                            diagnostics = {
                                disable = {
                                    "incomplete-signature-doc",
                                    "trailing-space",
                                },
                                groupSeverity = {
                                    strong = "Warning",
                                    strict = "Warning",
                                },
                                groupFileStatus = {
                                    ["ambiguity"] = "Opened",
                                    ["await"] = "Opened",
                                    ["codestyle"] = "None",
                                    ["duplicate"] = "Opened",
                                    ["global"] = "Opened",
                                    ["luadoc"] = "Opened",
                                    ["redefined"] = "Opened",
                                    ["strict"] = "Opened",
                                    ["strong"] = "Opened",
                                    ["type-check"] = "Opened",
                                    ["unbalanced"] = "Opened",
                                    ["unused"] = "Opened",
                                },
                                unusedLocalExclude = { "_*" },
                                globals = {
                                    "vim",
                                    "require",
                                    "use",
                                    "use_rocks",
                                    "use_batteries",
                                },
                            },
                            format = {
                                enable = true,
                                defaultConfig = {
                                    indent_style = "space",
                                    indent_size = "2",
                                    continuation_indent_size = "2",
                                },
                            },
                            runtime = { version = "LuaJIT" },
                        },
                    },
                },
                angularls = {},
            },
            setup = {
                denols = function(_, opts)
                    LazyVim.lsp.on_attach(function(client)
                        local util = require("lspconfig.util")
                        local root = client.root_dir
                        -- Only start if we're in a Deno project
                        if
                            not util.root_pattern("deno.json", "deno.jsonc")(
                                root
                            )
                        then
                            return
                        end

                        -- Stop any running tsserver instance
                        local active_clients = LazyVim.lsp.get_clients()
                        for _, ac in ipairs(active_clients) do
                            if ac.name == "tsserver" and ac.initialized then
                                ac.stop()
                            end
                        end
                    end, "denols")
                end,

                angularls = function()
                    LazyVim.lsp.on_attach(function(client)
                        --HACK: disable angular renaming capability due to duplicate rename popping up
                        client.server_capabilities.renameProvider = false
                        client.server_capabilities.documentFormattingProvider =
                            false
                    end, "angularls")
                end,
            },
        },
    },

    -- Typescript standalone LSP
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ---@type lspconfig.Config
        opts = {
            single_file_support = false,
            on_attach = function()
                LazyVim.notify("Attached...", {
                    level = 2,
                    title = "typescript-tools",
                    stacklevel = 3,
                })
            end,

            settings = {
                separate_diagnostic_server = true,
                tsserver_logs = "verbose",
                tsserver_plugins = {
                    "@angular/language-server",
                },
            },
        },
    },
}
