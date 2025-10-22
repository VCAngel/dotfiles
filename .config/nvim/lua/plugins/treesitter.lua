return {
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "angular",
                "asm",
                "astro",
                "bash",
                "c",
                "c_sharp",
                "cmake",
                "cpp",
                "css",
                "dockerfile",
                "fish",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "go",
                "graphql",
                "html",
                "http",
                "java",
                "javascript",
                "json",
                "kotlin",
                "lua",
                "php",
                "python",
                "regex",
                "rust",
                "scss",
                "sql",
                "svelte",
                "tmux",
                "typescript",
                "vue",
            },

            -- matchup = {
            -- 	enable = true,
            -- },

            -- https://github.com/nvim-treesitter/playground#query-linter
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold" },
            },

            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = true, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
            },
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter")

            -- some quick sanity checks
            if not TS.get_installed then
                return LazyVim.error(
                    "Please use `:Lazy` and update `nvim-treesitter`"
                )
            elseif type(opts.ensure_installed) ~= "table" then
                return LazyVim.error(
                    "`nvim-treesitter` opts.ensure_installed must be a table"
                )
            end

            -- setup treesitter
            TS.setup(opts)
            LazyVim.treesitter.get_installed(true) -- initialize the installed langs

            -- install missing parsers
            local install = vim.tbl_filter(function(lang)
                return not LazyVim.treesitter.have(lang)
            end, opts.ensure_installed or {})
            if #install > 0 then
                LazyVim.treesitter.ensure_treesitter_cli(function()
                    TS.install(install, { summary = true }):await(function()
                        LazyVim.treesitter.get_installed(true) -- refresh the installed langs
                    end)
                end)
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup(
                    "lazyvim_treesitter",
                    { clear = true }
                ),
                callback = function(ev)
                    if not LazyVim.treesitter.have(ev.match) then
                        return
                    end

                    -- highlighting
                    if vim.tbl_get(opts, "highlight", "enable") ~= false then
                        pcall(vim.treesitter.start)
                    end

                    -- indents
                    if vim.tbl_get(opts, "indent", "enable") ~= false then
                        LazyVim.set_default(
                            "indentexpr",
                            "v:lua.LazyVim.treesitter.indentexpr()"
                        )
                    end

                    -- folds
                    if vim.tbl_get(opts, "folds", "enable") ~= false then
                        if LazyVim.set_default("foldmethod", "expr") then
                            LazyVim.set_default(
                                "foldexpr",
                                "v:lua.LazyVim.treesitter.foldexpr()"
                            )
                        end
                    end
                end,
            })
        end,
    },
}
