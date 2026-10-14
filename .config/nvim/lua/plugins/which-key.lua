-- Custom keymaps, declared as which-key specs.
-- LazyVim's which-key spec uses `opts_extend = { "spec" }`, so everything here is appended to the LazyVim defaults (groups, descriptions, etc).

-- NOTE: which-key creates these mappings after LazyVim's default keymaps, so they still override them (e.g. <C-j>/<C-k>).
-- Default LazyVim keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

--- FzfLua LSP picker command that jumps straight to a single result
---@param picker string
local function fzf_lsp(picker)
    return "<cmd>FzfLua "
        .. picker
        .. " jump_to_single_result=true ignore_current_line=true<cr>"
end

---@type LazySpec
return {
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                -- Groups
                { "s", group = "split/window" },
                { "t", group = "tab" },

                -- Increment/Decrement
                { "+", "<C-a>", desc = "Increment" },
                { "-", "<C-x>", desc = "Decrement" },

                -- Delete a word backwards
                { "<A-BS>", "bd", desc = "Delete word backwards" },

                -- Select all
                { "<C-a>", "gg<S-v>G", desc = "Select all" },

                -- Jumplist
                { "<C-m>", "<C-i>", desc = "Jump forward" },

                -- Tabs
                { "te", ":tabedit", desc = "Tab edit" },
                { "tm", ":tabmove", desc = "Tab move" },
                { "<tab>", ":tabnext<Return>", desc = "Next tab" },
                { "<s-tab>", ":tabprev<Return>", desc = "Prev tab" },

                -- Split window
                { "ss", ":split<Return>", desc = "Split horizontal" },
                { "sv", ":vsplit<Return>", desc = "Split vertical" },

                -- Change window
                { "sh", "<C-w>h", desc = "Go to left window" },
                { "sk", "<C-w>k", desc = "Go to upper window" },
                { "sj", "<C-w>j", desc = "Go to lower window" },
                { "sl", "<C-w>l", desc = "Go to right window" },

                -- Manage windows
                { "sq", ":close<Return>", desc = "Close window" },

                -- Resize window
                { "<C-w><left>", "<C-w><", desc = "Decrease width" },
                { "<C-w><right>", "<C-w>>", desc = "Increase width" },
                { "<C-w><up>", "<C-w>+", desc = "Increase height" },
                { "<C-w><down>", "<C-w>-", desc = "Decrease height" },

                -- Diagnostics
                {
                    "<C-j>",
                    function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end,
                    desc = "Next diagnostic",
                },
                {
                    "<C-k>",
                    function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end,
                    desc = "Prev diagnostic",
                },

                -- Plugins
                -- > fzf_lua
                { "<leader>f<Enter>", "<cmd>FzfLua<cr>", desc = "FzfLua" },

                -- > goto-s
                {
                    "gd",
                    fzf_lsp("lsp_definitions"),
                    desc = "[G]oto [D]efinition",
                },
                {
                    "gr",
                    fzf_lsp("lsp_references"),
                    desc = "[G]oto [R]eferences",
                    nowait = true,
                },
                {
                    "gI",
                    fzf_lsp("lsp_implementations"),
                    desc = "[G]oto [I]mplementation",
                },
                {
                    "gy",
                    fzf_lsp("lsp_typedefs"),
                    desc = "[G]oto T[y]pe Definition",
                },

                -- > vtsls
                {
                    "<leader>co",
                    LazyVim.lsp.action["source.organizeImports"],
                    desc = "Organize Imports",
                },
                {
                    "<leader>cM",
                    LazyVim.lsp.action["source.addMissingImports.ts"],
                    desc = "Add missing imports",
                },
                {
                    "<leader>cu",
                    LazyVim.lsp.action["source.removeUnused.ts"],
                    desc = "Remove unused imports",
                },
                {
                    "<leader>cD",
                    LazyVim.lsp.action["source.fixAll.ts"],
                    desc = "Fix all diagnostic",
                },

                -- > outline
                { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
            },
        },
    },
}
