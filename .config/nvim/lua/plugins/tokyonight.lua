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
	-- 	end,
	-- },


	{
		"uloco/bluloco.nvim",
		lazy = false,
		priority = 1000,
		dependencies = { "rktjmp/lush.nvim" },
		config = function()
			vim.cmd([[colorscheme bluloco-dark]])
		end,
	},
}
