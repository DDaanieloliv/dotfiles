return {

	-- ###############################
	-- ##                           ##
	-- ## Plugin about lspconfig.   ##
	-- ##                           ##
	-- ###############################

	-- Configuração do Mason (gerenciador de LSPs, linters, formatters)
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { --[[ "jdtls", ]]
					"ts_ls",
					"angularls",
				},
				-- automatic_installation = true, -- Instala automaticamente LSPs faltantes
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util") -- Adicione esta linha

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- vim.lsp.enable('harper_ls')

			-- lspconfig.lua_ls.setup({})
			lspconfig.lua_ls.setup({
				-- capabilities = capabilities,

				cmd = { "lua-language-server" }, -- Usa o binário do Nix

				on_init = function(client)
					local path = client.workspace_folders and client.workspace_folders[1].name or ""
					if not vim.startswith(path, vim.fn.stdpath("config")) then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
						runtime = {
							version = "LuaJIT",
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
								vim.fn.expand("~/.nix-profile/share/lua-language-server/libexec/lua-language-server"), -- Caminho Nix
							},
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								vim.fn.stdpath("config"),
							},
						},
						telemetry = { enable = false },
					})
				end,

				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			lspconfig.ts_ls.setup({
				-- 	capabilities = capabilities,
			})

			-- vim.lsp.enable("pyright")
			lspconfig.pyright.setup({
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_dir = util.root_pattern(
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git"
				),
				-- capabilities = capabilities, -- Integração com nvim-cmp
				-- on_attach = on_attach, -- Função de attach personalizada
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							-- Configurações adicionais podem ser incluídas aqui
							typeCheckingMode = "basic", -- "off", "basic", "strict"
							diagnosticSeverityOverrides = {
								reportUnusedVariable = "warning",
							},
						},
					},
				},
			})

			lspconfig.jdtls.setup({
				cmd = {
					"/home/daniel/.sdkman/candidates/java/current/bin/java",
					"-javaagent:/home/daniel/.local/share/java/lombok.jar",
					"-jar",
					"/home/daniel/.local/share/nvim/jdtls/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar",
					"-configuration",
					"/home/daniel/.local/share/nvim/jdtls/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux",
					"-data",

					vim.fn.stdpath("cache") .. "/jdtls-workspace",
				},
				root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),

				settings = {
					java = {
						configuration = {
							vmArgs = {
								"--jvm-arg=-javaagent:/home/daniel/.local/share/java/lombok.jar",
							},
						},
					},
				},
			})

			-- lspconfig.jdtls.setup({
			-- 	-- capabilities = capabilities,
			-- 	cmd = {
			-- 		vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"),
			-- 	},
			-- 	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),
			-- })

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●", -- Símbolo personalizado
					spacing = 2,
				},
				-- Melhoria visual para sinais no gutter
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded", -- Borda bonita para hover
					source = "always",
				},
			})
		end,
	},
}
