-- Rendered Markdown inside the buffer: headings, lists, tables, code blocks,
-- checkboxes and quotes. The cursor line stays raw so it can be edited.
-- Uses the markdown and markdown_inline treesitter parsers (treesitter.lua).
return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        version = "*",
        ft = { "markdown", "copilot-chat" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>tm", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle: Markdown rendered/raw" },
        },
        opts = {
            file_types = { "markdown", "copilot-chat" },
            render_modes = { "n", "c", "t" },
            completions = { lsp = { enabled = false } },
            heading = { sign = false },
            code = { sign = false, width = "block", right_pad = 1 },
            -- Without a Nerd Font fall back to plain markers instead of "?" boxes.
            bullet = not require("icons").nerd_font and { icons = { "-", "*", "+" } } or {},
        },
    },
}
