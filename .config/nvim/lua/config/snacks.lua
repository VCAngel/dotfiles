local dashboardHeader = [[
 _ _ _     _                      _           _  |  |
| | | |___| |___ ___ _____ ___   | |_ ___ ___| |_|  |
| | | | -_| |  _| . |     | -_|  | . | .'|  _| '_|__|
|_____|___|_|___|___|_|_|_|___|  |___|__,|___|_,_|__|
                                                     
  ദി(˵ •̀ ᴗ - ˵ ) ✧
]]

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        ---@type snacks.animate.Config
        animate = {
            duration = 20, -- ms per step
            easing = "inQuad",
            fps = 30, -- frames per second. Global setting for all animations
        },
        bigfile = {
            enabled = true,
            notify = true, -- show notification when big file detected
            size = 1.5 * 1024 * 1024, -- 1.5MB
            ---@param ctx {buf: number, ft:string}
            setup = function(ctx)
                vim.cmd([[NoMatchParen]])
                Snacks.util.wo(0, {
                    foldmethod = "manual",
                    statuscolumn = "",
                    conceallevel = 0,
                })
                vim.b.snacks_animate = false
                vim.schedule(function()
                    vim.bo[ctx.buf].syntax = ctx.ft
                end)
            end,
        },
        indent = {
            enabled = true,
        },
        input = { enabled = true },
        notifier = {
            enabled = true,
            date_format = "%R %p",
            timeout = 5000,
            style = "compact",
        },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true, debounce = 500 },
        ---@type snacks.zen.Config
        zen = { enabled = true },
        ---@type snacks.dashboard.Config
        dashboard = {
            width = 64,
            preset = {
                header = dashboardHeader,
            },
            sections = {
                {
                    pane = 1,
                    {
                        section = "header",
                        padding = 1,
                    },
                    { section = "keys", gap = 1, padding = 1 },
                    {
                        icon = " ",
                        title = "Git Log",
                        section = "terminal",
                        enabled = vim.fn.isdirectory(".git") == 1,
                        cmd = "git log --pretty='%Cgreen(%ar)%Creset -%C(auto)%d%Creset %s' | head -n 10",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                    },
                    { section = "startup", padding = 4 },
                },
                {
                    pane = 2,
                    { text = "", height = 5, padding = 14 },
                    {
                        section = "terminal",
                        cmd = "fortune linux computers -n 128 -s | sed '/^[[:space:]]*--/d' | cowsay -f dedo | lolcat -a -s 256",
                        height = 16,
                        indent = 10,
                        ttl = 2,
                    },
                },
            },
            formats = {},
        },
        ---@type table<string, snacks.win.Config>
        styles = {
            zen = {
                enter = true,
                minimal = false,
                width = 128,
                wo = {
                    winhighlight = "Normal:SnacksZenNormal,NormalNC:SnacksZenNormalNC",
                },
                backdrop = {
                    transparent = false,
                },
                border = "rounded",
                zindex = 25,
            },
        },
    },
}
