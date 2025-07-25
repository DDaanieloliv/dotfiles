return {

	-- ###############################
	-- ##                           ##
	-- ## Plugin about colorscheme. ##
	-- ##                           ##
	-- ###############################

	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd([[colorscheme tokyonight-night]])
	--
	-- 		-- vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	-- 		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	-- 		-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- 	end,
	-- },

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme catppuccin-macchiato]])

			-- vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		end,
	},

	-- {
	-- 	"uloco/bluloco.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	dependencies = { "rktjmp/lush.nvim" },
	-- 	config = function()
	-- 		vim.cmd([[colorscheme bluloco-dark]])
	--
	-- 		vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	-- 		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- 	end,
	-- },
}
