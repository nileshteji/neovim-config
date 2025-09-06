-- Configure Gruvbox
require('gruvbox').setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = true,
})

-- Keep Rose Pine setup for fallback
require('rose-pine').setup({
    disable_background = true
})

function ColorMyPencils(color)
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)

	-- Keep transparent background
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- Set Gruvbox as default
ColorMyPencils("gruvbox")
