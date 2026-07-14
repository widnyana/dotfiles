local M = {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
	main = "ibl",
	opts = {
		scope = {
			enabled = true,
			show_start = true,
		},
		exclude = {
			filetypes = {
				"coc-explorer",
				"dashboard",
				"floaterm",
				"alpha",
				"help",
				"packer",
				"NvimTree",
			},
		},
	},
}

return M
