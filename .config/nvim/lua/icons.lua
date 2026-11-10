-- Shared icons. Glyphs are built from code points with nr2char() instead of
-- being pasted as characters: Nerd Font glyphs live in the Private Use Area,
-- look blank in most editors and were silently stripped once, leaving blank
-- signs. A number cannot be stripped by accident.
--
-- Needs a Nerd Font in the terminal (README: "Iconos"). Without one, start
-- Neovim with NVIM_NERD_FONT=0 to get plain ASCII instead of "?" boxes.
local M = {}

local env = vim.env.NVIM_NERD_FONT
M.nerd_font = env ~= "0" and env ~= "false"
vim.g.have_nerd_font = M.nerd_font

local function glyph(code, fallback)
    return M.nerd_font and vim.fn.nr2char(code) or fallback
end

M.diagnostics = {
    error = glyph(0xF057, "E"), -- nf-fa-times_circle
    warn = glyph(0xF071, "W"), -- nf-fa-warning
    info = glyph(0xF05A, "I"), -- nf-fa-info_circle
    hint = glyph(0xF0EB, "H"), -- nf-fa-lightbulb_o
}
M.git_branch = glyph(0xE0A0, "git") -- powerline branch
M.readonly = glyph(0xF023, "RO") -- nf-fa-lock
M.lsp = glyph(0xF013, "LSP") -- nf-fa-cog
M.folder_closed = glyph(0xF07B, "+") -- nf-fa-folder
M.folder_open = glyph(0xF07C, "-") -- nf-fa-folder_open
M.fold_closed = glyph(0xF105, ">") -- nf-fa-angle_right
M.fold_open = glyph(0xF107, "v") -- nf-fa-angle_down

--- Sign text for vim.diagnostic.config(): one glyph plus a space.
function M.diagnostic_signs()
    local s = vim.diagnostic.severity
    local d = M.diagnostics
    return {
        [s.ERROR] = d.error .. " ",
        [s.WARN] = d.warn .. " ",
        [s.INFO] = d.info .. " ",
        [s.HINT] = d.hint .. " ",
    }
end

return M
