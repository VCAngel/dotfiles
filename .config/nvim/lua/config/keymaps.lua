-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/Decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "<A-BS>", "vbd")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Change window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Manage windows
keymap.set("n", "sq", ":close<Return>", opts)

-- Diagnostics
keymap.set("n", "<C-j>", function()
    vim.diagnostic.goto_next()
end, opts)
keymap.set("n", "<C-k>", function()
    vim.diagnostic.goto_prev()
end, opts)

-- Plugins
-- > fzf_lua
keymap.set(
    "n",
    "gd",
    "<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>",
    {
        desc = "[G]oto [D]efinition",
        unpack(opts),
    }
)

keymap.set(
    "n",
    "gr",
    "<cmd>FzfLua lsp_references     jump_to_single_result=true ignore_current_line=true<cr>",
    {
        desc = "[G]oto [R]eferences",
        nowait = true,
        unpack(opts),
    }
)

keymap.set(
    "n",
    "gI",
    "<cmd>FzfLua lsp_implementations     jump_to_single_result=true ignore_current_line=true<cr>",
    {
        desc = "[G]oto [I]mplementation",
        unpack(opts),
    }
)

keymap.set(
    "n",
    "gy",
    "<cmd>FzfLua lsp_typedefs     jump_to_single_result=true ignore_current_line=true<cr>",
    {
        desc = "[G]oto T[y]pe Definition",
        unpack(opts),
    }
)

-- > vtsls
keymap.set("n", "<leader>co", LazyVim.lsp.action["source.organizeImports"], {
    desc = "Organize Imports",
    unpack(opts),
})

keymap.set(
    "n",
    "<leader>cM",
    LazyVim.lsp.action["source.addMissingImports.ts"],
    {
        desc = "Add missing imports",
        unpack(opts),
    }
)

keymap.set("n", "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"], {
    desc = "Remove unused imports",
    unpack(opts),
})

keymap.set("n", "<leader>cD", LazyVim.lsp.action["source.fixAll.ts"], {
    desc = "Fix all diagnostic",
    unpack(opts),
})
