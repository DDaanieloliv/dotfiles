return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Carrega extensões
			telescope.load_extension("file_browser")
			telescope.load_extension("ui-select")

			local function telescope_mega_finder()
				local pickers = require("telescope.builtin")
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				local opts = {} -- opções comuns (opcional)

				-- Menu de opções
				local choices = {
					{
						"  Buscar Comandos (:comandos)",
						function()
							pickers.commands(opts)
						end,
					},
					{
						"󰞋  Ajuda (:help)",
						function()
							pickers.help_tags(opts)
						end,
					},
					{
						"  API do Neovim",
						function()
							pickers.builtin({ include_extensions = true })
						end,
					},
					{
						"  Arquivos Recentes",
						function()
							pickers.oldfiles(opts)
						end,
					},
					{
						"  Buscar Palavra no Projeto",
						function()
							pickers.live_grep(opts)
						end,
					},
					{ "󰈆  Sair", nil },
				}

				-- Abre o menu no Telescope
				require("telescope.pickers")
						.new(opts, {
							prompt_title = " Modo de Busca",
							finder = require("telescope.finders").new_table({
								results = choices,
								entry_maker = function(entry)
									return {
										value = entry,
										display = entry[1],
										ordinal = entry[1],
									}
								end,
							}),
							sorter = require("telescope.config").values.generic_sorter(opts),
							attach_mappings = function(prompt_bufnr, map)
								-- Ao pressionar <Enter>, executa a função correspondente
								actions.select_default:replace(function()
									local selection = action_state.get_selected_entry()
									if selection.value[2] then
										actions.close(prompt_bufnr)
										selection.value[2]() -- Executa a função
									else
										actions.close(prompt_bufnr) -- Sai se for "󰈆 Sair"
									end
								end)
								return true
							end,
						})
						:find()
			end

			vim.keymap.set("n", "<leader>ff", telescope_mega_finder, { desc = "[F]ind [F]iles/Commands/Help" })

			-- Mapeamentos
			vim.keymap.set("n", "<leader>pp", function()
				builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
			end, { desc = "Buscar arquivos na pasta atual" })

			-- vim.keymap.set("n", "<leader>bh", function()
			--   telescope.extensions.file_browser.file_browser({
			--     path = vim.fn.expand("%:p:h"),
			--     hidden = true,
			--     no_ignore = true
			--   })
			-- end, { desc = "Abrir navegador de arquivos" })

			vim.keymap.set("n", "<leader>pf", function()
				local cwd = vim.fn.getcwd()
				print("Buscando em: " .. cwd) -- Mostra o path no console (opcional)
				builtin.find_files({
					cwd = cwd,
					hidden = true,
					prompt_title = "Arquivos em: " .. vim.fn.pathshorten(cwd),
					-- prompt_title = "Arquivos em: " .. cwd, -- Mostra no prompt do Telescope
					path_display = { "truncate" }, -- Encurta os paths longos
					layout_config = {
						width = 0.95,           -- Ajusta a largura da janela
						preview_width = 0.6,    -- Ajusta a largura da pré-visualização
					},
				})
			end, { desc = "Buscar arquivos no diretório atual (cd)" })

			vim.keymap.set("n", "<leader>bs", function()
				local path = vim.fn.expand("%:p:h:h") -- sobe duas pastas
				require("telescope.builtin").grep_string({
					search = vim.fn.input("Grep > "),
					cwd = path,
					path_display = { "truncate" }, -- Encurta paths longos
					layout_config = {
						width = 0.95,
						preview_width = 0.6,
					},
				})
			end, { desc = "Grep na pasta 2 níveis acima" })

			vim.keymap.set("n", "<leader>bh", function()
				telescope.extensions.file_browser.file_browser({
					path = vim.fn.expand("%:p:h"),
					select_buffer = true,
					hidden = true, -- Mostra arquivos ocultos
					no_ignore = true, -- Ignora arquivos não-ocultos (mostra SÓ os ocultos)
				})
			end, { desc = "Abrir navegador de arquivos (somente ocultos)" })
		end,
	},
}
