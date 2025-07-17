-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here

		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},

		{
			'nvim-telescope/telescope.nvim', tag = '0.1.8',
			-- or                              , branch = '0.1.x',
			dependencies = { 'nvim-lua/plenary.nvim' }
		},

		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		},

		{
			"ThePrimeagen/harpoon"
		},

		{
			"mbbill/undotree"
		},


		-- #################################################
		-- ##                                             ##
		-- ## Setting TreeSitter for Syntax highlightint. ##
		-- ##                                             ##
		-- #################################################

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
			dependencies = {
				"nvim-treesitter/playground", -- Adicione como dependência
			},
			opts = {
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = {
					"bash", "c", "diff", "html", "javascript", "jsdoc", "json", "jsonc",
					"lua", "luadoc", "luap", "markdown", "markdown_inline", "python",
					"query", "regex", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml", 
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						node_decremental = "<bs>",
					},
				},
				textobjects = {
					move = {
						enable = true,
						goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
						goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
						goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
						goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
					},
				},
			},
			config = function(_, opts)
				require("nvim-treesitter.configs").setup(opts)
			end,
		}


	},
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})


vim.o.relativenumber = true

vim.opt.nu = true

vim.cmd[[colorscheme tokyonight-night]]

vim.g.have_nerd_font = true

vim.o.number = false

vim.o.mouse = 'a'

vim.o.ignorecase = true
vim.o.smartcase = true


-- #######################
-- ##                   ##
-- ## Adding keymaps !  ## 
-- ##                   ##
-- #######################

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


-- #####################################
-- ##                                 ##
-- ## Adding keymaps for telescope !  ## 
-- ##                                 ##
-- #####################################

local builtin = require('telescope.builtin')
require("telescope").load_extension("file_browser")


vim.keymap.set('n', '<leader>p', function()
	builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = 'Buscar arquivos na pasta do arquivo atual' })


vim.keymap.set('n', '<leader>bs', function()
  local path = vim.fn.expand('%:p:h:h') -- sobe duas pastas
  require('telescope.builtin').grep_string({
    search = vim.fn.input("Grep > "),
    cwd = path,
  })
end, { desc = "Grep na pasta 2 níveis acima" })

vim.keymap.set("n", "<leader>b", function()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"),
    select_buffer = true,
  })
end, { desc = "Abrir navegador de arquivos" })

vim.keymap.set("n", "<leader>bh", function()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"),
    select_buffer = true,
    hidden = true,    -- Mostra arquivos ocultos
    no_ignore = true, -- Ignora arquivos não-ocultos (mostra SÓ os ocultos)
  })
end, { desc = "Abrir navegador de arquivos (somente ocultos)" })

-- ######################################
-- ##                                  ##
-- ## Setting clipboard configuration. ##
-- ##                                  ##
-- ###################################### 
vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy --foreground --type text/plain",
    ["*"] = "wl-copy --foreground --type text/plain",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
  cache_enabled = 1,
}



-- ###########################
-- ##                       ##
-- ## Things about Harpoon. ##
-- ##                       ##
-- ########################### 

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>m", ui.toggle_quick_menu)

vim.keymap.set("n", "<A-1>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<A-2>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<A-3>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<A-4>", function() ui.nav_file(4) end)
vim.keymap.set("n", "<A-5>", function() ui.nav_file(5) end)
vim.keymap.set("n", "<A-6>", function() ui.nav_file(6) end)
vim.keymap.set("n", "<A-7>", function() ui.nav_file(7) end)
vim.keymap.set("n", "<A-8>", function() ui.nav_file(8) end)



-- ############################
-- ##                        ##
-- ## Things about UndoTree. ##
-- ##                        ##
-- ############################ 

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)


