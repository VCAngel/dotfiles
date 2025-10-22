local function getParentDir(buffer, markers) end

---@type LazySpec
return {
    ---@module 'blink.cmp'
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        dependencies = "rafamadriz/friendly-snippets",
        -- use a release tag to download pre-built binaries
        version = "*",

        ---@module 'blink.cmp'
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

            -- Show the documentation window automatically
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 3000 },
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
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
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependiencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
            "saghen/blink.cmp",
        },
        opts = {
            ensure_installed = {
                "lua_ls",
                "vtsls",
                "denols",
                "angularls",
                "bashls",
                "copilot",
                "cssls",
                "jsonls",
                "rust_analyzer",
                "stylua",
                "tailwindcss",
                "yamlls",
            },
        },
    },

    -- lsp config and servers
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        opts = {
            inlay_hints = { enabled = true },
            ---@type  table<vim.lsp.Config>
            servers = {
                cssls = {},
                ---@type vim.lsp.Config
                tailwindcss = {
                    root_dir = function(bufnr, on_dir)
                        local root = vim.fs.root(bufnr, {
                            "tailwind.config.js",
                            "tailwind.config.cjs",
                            "tailwind.config.mjs",
                            "tailwind.config.ts",
                            "postcss.config.js",
                            "postcss.config.cjs",
                            "postcss.config.mjs",
                            "postcss.config.ts",
                        })
                        if root then
                            on_dir(root)
                        end
                    end,
                },
                ---@type vim.lsp.Config
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
                    root_dir = function(bufnr, on_dir)
                        local root = vim.fs.root(bufnr, {
                            "deno.json",
                            "deno.jsonc",
                        })

                        if root then
                            on_dir(root)
                        end
                    end,
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
                    workspace_required = true,
                },

                ---@type vim.lsp.Config
                vtsls = {
                    on_attach = function(client)
                        LazyVim.notify("Attached...", {
                            level = 2,
                            title = "vtsls",
                            stacklevel = 3,
                        })
                    end,
                    cmd = { "vtsls", "--stdio" },
                    filetypes = {
                        "javascript",
                        "typescript",
                        "javascriptreact",
                        "typescriptreact",
                    },
                    root_dir = function(bufnr, on_dir)
                        local root = vim.fs.root(bufnr, {
                            "package.json",
                            "package.jsonc",
                        })

                        if root then
                            on_dir(root)
                        end
                    end,
                    workspace_required = true,
                },
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
                                library = {
                                    unpack(
                                        vim.api.nvim_get_runtime_file("", true)
                                    ),
                                },
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
                ---@type vim.lsp.Config
                angularls = {
                    filetypes = {
                        "html",
                        "typescript",
                    },
                    on_attach = function(client)
                        -- HACK: disable angular renaming capability due to duplicate rename popping up
                        client.server_capabilities.renameProvider = false
                        client.server_capabilities.documentFormattingProvider =
                            false

                        LazyVim.notify("Attached...", {
                            level = 2,
                            title = client.name,
                            stacklevel = 3,
                        })
                    end,
                    root_dir = function(bufnr, on_dir)
                        local root = vim.fs.root(bufnr, {
                            "angular.json",
                            "angular.jsonc",
                        })

                        if root then
                            on_dir(root)
                        end
                    end,
                    workspace_required = true,
                },
            },
        },
    },
}
