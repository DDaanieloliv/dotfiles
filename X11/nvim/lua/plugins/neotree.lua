return {

	-- ###############################
	-- ##                           ##
	-- ## Plugin about Neotree.     ##
	-- ##                           ##
	-- ###############################

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- Optional image support for file preview: See `# Preview Mode` for more information.
			-- {"3rd/image.nvim", opts = {}},
			-- OR use snacks.nvim's image module:
			-- "folke/snacks.nvim",
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {
			filesystem = {
				filtered_items = {
					visible = true, -- mostra arquivos ocultos
					hide_dotfiles = false, -- mostra arquivos que começam com "."
					hide_gitignored = false, -- mostra arquivos ignorados pelo git

					-- Ativa a visualização das abas
					window = {
						-- Something
					},
				},
				-- add options here
			},
		},
	},
}
