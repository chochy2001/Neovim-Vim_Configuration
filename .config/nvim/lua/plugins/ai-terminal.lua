-- AI coding assistants inside Neovim (no leaving the terminal).
-- These `keys` merge with the toggleterm.nvim spec from terminal.lua, so the
-- first press loads toggleterm (running its setup) and then opens the CLI.
-- Every assistant checks its binary at press time and shows an install hint
-- when missing, so nothing errors on machines without a given CLI.
return {
    {
        "akinsho/toggleterm.nvim",
        keys = {
            { "<leader>aa", function() require("ai-terminals").toggle("opencode") end, desc = "AI: opencode" },
            { "<leader>ax", function() require("ai-terminals").toggle("codex") end, desc = "AI: codex" },
            { "<leader>ac", function() require("ai-terminals").toggle("claude") end, desc = "AI: claude" },
            { "<leader>ag", function() require("ai-terminals").toggle("gemini") end, desc = "AI: gemini" },
            { "<leader>ak", function() require("ai-terminals").toggle("grok") end, desc = "AI: grok" },
            { "<leader>ap", function() require("ai-terminals").toggle("copilot") end, desc = "AI: copilot CLI" },
            -- Visual: pick any agent for the occasion, type the instruction,
            -- and the selection is sent to it (prompt also kept in clipboard)
            {
                "<leader>as",
                function() require("ai-terminals").send_visual_pick() end,
                mode = { "v", "x" },
                desc = "AI: send selection (pick agent)",
            },
        },
    },
}
