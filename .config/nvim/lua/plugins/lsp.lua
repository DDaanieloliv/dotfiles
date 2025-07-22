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
				ensure_installed = { "lua_ls", "jdtls", "ts_ls", "angularls" },
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

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.ast_grep.setup({})

			lspconfig.jdtls.setup({

				capabilities = capabilities,

				cmd = {
					vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"),
				},

				root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),
			})

			lspconfig.angularls.setup({

				cmd = {
					vim.fn.expand("~/.local/share/nvim/mason/bin/ngserver"),
					"--stdio",
					"--tsProbeLocations",
					vim.fn.getcwd() .. "/node_modules",
					"--ngProbeLocations",
					vim.fn.getcwd() .. "/node_modules",
				},
				root_dir = util.root_pattern("angular.json"),
				on_new_config = function(new_config, new_root_dir)
					local function get_probe_dir(root_dir)
						local project_root =
							vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
						return project_root and (project_root .. "/node_modules") or ""
					end

					local function get_angular_core_version(root_dir)
						local project_root =
							vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
						if not project_root then
							return ""
						end

						local package_json = project_root .. "/package.json"
						if not vim.uv.fs_stat(package_json) then
							return ""
						end

						local contents = io.open(package_json):read("*a")
						local json = vim.json.decode(contents)
						if not json.dependencies then
							return ""
						end

						local angular_core_version = json.dependencies["@angular/core"]
						return angular_core_version and angular_core_version:match("%d+%.%d+%.%d+") or ""
					end

					local probe_dir = get_probe_dir(new_root_dir)
					local angular_version = get_angular_core_version(new_root_dir)

					new_config.cmd = {
						vim.fn.expand("~/.local/share/nvim/mason/bin/ngserver"),
						"--stdio",
						"--tsProbeLocations",
						probe_dir,
						"--ngProbeLocations",
						probe_dir,
						"--angularCoreVersion",
						angular_version,
					}
				end,
			})

			lspconfig.ts_ls.setup({
				-- root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
				-- capabilities = require("cmp_nvim_lsp").default_capabilities(),
				-- settings = {
				-- 	typescript = {
				-- 		format = {
				-- 			indentSize = 2,
				-- 			convertTabsToSpaces = true,
				-- 			tabSize = 2,
				-- 		},
				-- 	},
				-- },
			})

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
