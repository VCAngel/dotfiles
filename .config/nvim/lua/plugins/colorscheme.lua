return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = function()
      return {
        flavour = "mocha",
        transparent_background = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.1,
        },
        styles = {
          comments = { "italic" },
          keywords = { "bold" },
        },
        color_overrides = {},
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
          noice = true,
          notify = true,
          mini = {
            enabled = true,
          },
          dashboard = true,
        },
      }
    end,
  },

  -- LazyVim
  {
    "LazyVim/LazyVim",
    opts = function()
      return {
        colorscheme = "catppuccin",
      }
    end,
  },
}
