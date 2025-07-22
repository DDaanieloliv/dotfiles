require("config.lazy")
-- vim.cmd([[colorscheme tokyonight-night]])


-- O resto do seu init.lua pode permanecer igual

-- Setup lazy.nvim


-- require("lazy").setup({
--   spec = {
--     -- add your plugins here
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about colorscheme. ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "folke/tokyonight.nvim",
--       lazy = false,
--       priority = 1000,
--       opts = {},
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about Autopairs.   ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "windwp/nvim-autopairs", -- Autopairs
--       event = "InsertEnter",
--       config = true,
--     },
--
--     -- #################################
--     -- ##                             ##
--     -- ## Plugin about Commentstring. ##
--     -- ##                             ##
--     -- #################################
--
--     {
--       "JoosepAlviste/nvim-ts-context-commentstring",
--       dependencies = "nvim-treesitter/nvim-treesitter",
--       lazy = true,
--     },
--
--     {
--       "numToStr/Comment.nvim",
--       dependencies = {
--         "JoosepAlviste/nvim-ts-context-commentstring",
--       },
--       config = function()
--         require("Comment").setup({
--           pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
--         })
--       end,
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about telescope.   ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "nvim-telescope/telescope.nvim",
--       tag = "0.1.8",
--       -- or                              , branch = '0.1.x',
--       dependencies = { "nvim-lua/plenary.nvim" },
--     },
--
--     {
--       "nvim-telescope/telescope-file-browser.nvim",
--       dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
--     },
--
--     {
--       "nvim-telescope/telescope-ui-select.nvim",
--       config = function()
--         -- This is your opts table
--         require("telescope").setup({
--           extensions = {
--             ["ui-select"] = {
--               require("telescope.themes").get_dropdown({
--                 -- even more opts
--               }),
--
--               -- pseudo code / specification for writing custom displays, like the one
--               -- for "codeactions"
--               -- specific_opts = {
--               --   [kind] = {
--               --     make_indexed = function(items) -> indexed_items, width,
--               --     make_displayer = function(widths) -> displayer
--               --     make_display = function(displayer) -> function(e)
--               --     make_ordinal = function(e) -> string
--               --   },
--               --   -- for example to disable the custom builtin "codeactions" display
--               --      do the following
--               --   codeactions = false,
--               -- }
--             },
--           },
--         })
--         -- To get ui-select loaded and working with telescope, you need to call
--         -- load_extension, somewhere after setup function:
--         require("telescope").load_extension("ui-select")
--       end,
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about Harpoon.     ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "theprimeagen/harpoon",
--       branch = "harpoon2",
--       dependencies = { "nvim-lua/plenary.nvim" },
--
--       config = function()
--         local harpoon = require("harpoon")
--
--         harpoon.setup({
--           menu = {
--             width = 60,
--             height = 20,
--           },
--         })
--
--         -- função auxiliar para normalizar caminhos de arquivos
--         local function normalize_path(path)
--           return vim.fn.fnamemodify(path, ":p")
--         end
--
--         -- verifica se um arquivo está no harpoon
--         local function is_in_harpoon(bufname)
--           local normalized_current = normalize_path(bufname)
--           local list = harpoon:list()
--
--           if not list or not list.items then
--             return false
--           end
--
--           for _, item in ipairs(list.items) do
--             if item and item.value then
--               local normalized_item = normalize_path(item.value)
--               if normalized_item == normalized_current then
--                 return true
--               end
--             end
--           end
--           return false
--         end
--
--         -- adiciona automaticamente buffers válidos ao harpoon (versão controlada)
--         vim.api.nvim_create_autocmd("bufenter", {
--           callback = function()
--             local bufname = vim.api.nvim_buf_get_name(0)
--             -- só adiciona se:
--             -- 1. for um arquivo real (não buffer especial)
--             -- 2. já não estiver no harpoon
--             -- 3. existir no sistema de arquivos
--             if
--                 bufname ~= ""
--                 and vim.bo.buftype == ""
--                 and not is_in_harpoon(bufname)
--                 and vim.fn.filereadable(bufname) == 1
--             then
--               harpoon:list():add()
--             end
--           end,
--         })
--
--         -- remove um arquivo do harpoon pelo seu caminho
--         local function remove_from_harpoon(bufname)
--           local normalized_target = normalize_path(bufname)
--           local list = harpoon:list()
--
--           if not list or not list.items then
--             return false
--           end
--
--           local found_index = nil
--
--           -- Primeiro encontra o índice exato do item a remover
--           for i, item in ipairs(list.items) do
--             if item and item.value then
--               if normalize_path(item.value) == normalized_target then
--                 found_index = i
--                 break
--               end
--             end
--           end
--
--           -- Se encontrou, remove apenas esse item específico
--           if found_index then
--             table.remove(list.items, found_index)
--             return true
--           end
--
--           return false
--         end
--
--         -- compacta a lista do harpoon removendo posições vazias
--         local function compact_harpoon_list()
--           local list = harpoon:list()
--           if not list or not list.items then
--             return
--           end
--
--           local new_items = {}
--           for _, item in ipairs(list.items) do
--             if item and item.value then
--               table.insert(new_items, item)
--             end
--           end
--           list.items = new_items
--         end
--
--         -- adiciona arquivo atual ao harpoon
--         vim.keymap.set("n", "<leader>a", function()
--           harpoon:list():add()
--           vim.notify(
--             "added to harpoon: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0)),
--             vim.log.levels.info
--           )
--         end, { desc = "adicionar arquivo ao harpoon" })
--
--         -- mostra menu do harpoon
--         vim.keymap.set("n", "<leader>m", function()
--           compact_harpoon_list()
--           harpoon.ui:toggle_quick_menu(harpoon:list())
--         end, { desc = "menu harpoon" })
--
--         -- remove arquivo atual do harpoon
--         vim.keymap.set("n", "<leader>d", function()
--           local current_file = vim.api.nvim_buf_get_name(0)
--           if current_file == "" or vim.bo.buftype ~= "" then
--             vim.notify("no valid file to remove", vim.log.levels.warn)
--             return
--           end
--
--           if remove_from_harpoon(current_file) then
--             vim.notify(
--               "removed from harpoon: " .. vim.fn.fnamemodify(current_file, ":t"),
--               vim.log.levels.info
--             )
--           else
--             vim.notify(
--               "file not in harpoon: " .. vim.fn.fnamemodify(current_file, ":t"),
--               vim.log.levels.warn
--             )
--           end
--         end, { desc = "remover arquivo atual do harpoon" })
--
--         -- Remove do Harpoon e deleta o buffer atual (versão corrigida)
--         vim.keymap.set("n", "<leader>q", function()
--           local bufname = vim.api.nvim_buf_get_name(0)
--           local bufnum = vim.fn.bufnr()
--
--           -- 1. Remove APENAS o arquivo atual do Harpoon
--           if remove_from_harpoon(bufname) then
--             vim.notify("Removed from Harpoon: " .. vim.fn.fnamemodify(bufname, ":t"), vim.log.levels.INFO)
--           end
--
--           -- 2. Verifica modificações não salvas
--           if vim.bo.modified then
--             local choice = vim.fn.confirm(
--               "Salvar alterações em " .. vim.fn.fnamemodify(bufname, ":t") .. "?",
--               "&Sim\n&Não\n&Cancelar",
--               1
--             )
--             if choice == 1 then -- Sim
--               vim.cmd("write")
--             elseif choice == 3 then -- Cancelar
--               return
--             end
--           end
--
--           -- 3. Fecha o buffer
--           local ok, err = pcall(vim.cmd, "silent! bd! " .. bufnum)
--           if not ok then
--             vim.notify("Erro ao fechar buffer: " .. tostring(err), vim.log.levels.ERROR)
--           else
--             vim.notify("Buffer deleted: " .. vim.fn.fnamemodify(bufname, ":~:."), vim.log.levels.INFO)
--           end
--         end, { desc = "Remover do Harpoon e deletar buffer atual" })
--
--         -- Mapeamentos para acessar itens do Harpoon (Alt+1 a Alt+9)
--         for i = 1, 9 do
--           vim.keymap.set("n", "<A-" .. i .. ">", function()
--             compact_harpoon_list()
--             local list = harpoon:list()
--
--             if not list or not list.items or #list.items < i then
--               vim.notify("No file at position " .. i, vim.log.levels.WARN)
--               return
--             end
--
--             local item = list.items[i]
--             if not item or not item.value then
--               vim.notify("Invalid file at position " .. i, vim.log.levels.ERROR)
--               return
--             end
--
--             local current_file = vim.api.nvim_buf_get_name(0)
--             if normalize_path(current_file) == normalize_path(item.value) then
--               vim.notify("Already in: " .. vim.fn.fnamemodify(item.value, ":t"), vim.log.levels.INFO)
--               return
--             end
--
--             -- Tenta abrir o arquivo
--             local ok, err = pcall(vim.cmd, "edit " .. vim.fn.fnameescape(item.value))
--             if not ok then
--               vim.notify("Error opening file: " .. tostring(err), vim.log.levels.ERROR)
--             end
--           end, { desc = "Abrir item " .. i .. " do Harpoon" })
--         end
--
--         -- Autocomando para remover arquivos deletados do Harpoon
--         vim.api.nvim_create_autocmd("BufDelete", {
--           callback = function(args)
--             local bufname = vim.api.nvim_buf_get_name(args.buf)
--             if bufname ~= "" then
--               remove_from_harpoon(bufname)
--             end
--           end,
--         })
--
--         -- Desativa a adição automática de buffers ao Harpoon
--         -- (Remova o autocomando BufEnter que adiciona automaticamente)
--       end,
--     },
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about UndoTree.    ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "mbbill/undotree",
--       config = function()
--         vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
--       end,
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about TreeSitter.  ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "nvim-treesitter/nvim-treesitter",
--       build = ":TSUpdate",
--       cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
--       dependencies = {
--         "nvim-treesitter/playground", -- Adicione como dependência
--       },
--       opts = {
--         highlight = { enable = true },
--         indent = { enable = true },
--
--         ensure_installed = {
--           "c",
--           "lua",
--           "vim",
--           "vimdoc",
--           "query",
--           "markdown",
--           "markdown_inline",
--           "java",
--           "javascript",
--           "typescript",
--           "html",
--           "angular",
--         },
--
--         incremental_selection = {
--           enable = true,
--           keymaps = {
--             init_selection = "<C-space>",
--             node_incremental = "<C-space>",
--             node_decremental = "<bs>",
--           },
--         },
--         textobjects = {
--           move = {
--             enable = true,
--             goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
--             goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
--             goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
--             goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
--           },
--         },
--       },
--       config = function(_, opts)
--         require("nvim-treesitter.configs").setup(opts)
--       end,
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about lspconfig.   ##
--     -- ##                           ##
--     -- ###############################
--
--     -- Configuração do Mason (gerenciador de LSPs, linters, formatters)
--     {
--       "mason-org/mason.nvim",
--       config = function()
--         require("mason").setup()
--       end,
--     },
--     {
--       "mason-org/mason-lspconfig.nvim",
--       config = function()
--         require("mason-lspconfig").setup({
--           ensure_installed = { "lua_ls", "jdtls", "ts_ls", "angularls" },
--           -- automatic_installation = true, -- Instala automaticamente LSPs faltantes
--         })
--       end,
--     },
--     {
--       "neovim/nvim-lspconfig",
--       config = function()
--         local lspconfig = require("lspconfig")
--         local util = require("lspconfig.util") -- Adicione esta linha
--
--         lspconfig.lua_ls.setup({})
--         lspconfig.ast_grep.setup({})
--
--         lspconfig.jdtls.setup({
--
--           cmd = {
--             vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"),
--           },
--
--           root_dir = vim.fs.dirname(
--             vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]
--           ),
--         })
--
--         lspconfig.angularls.setup({
--
--           cmd = {
--             vim.fn.expand("~/.local/share/nvim/mason/bin/ngserver"),
--             "--stdio",
--             "--tsProbeLocations",
--             vim.fn.getcwd() .. "/node_modules",
--             "--ngProbeLocations",
--             vim.fn.getcwd() .. "/node_modules",
--           },
--           root_dir = util.root_pattern("angular.json"),
--           on_new_config = function(new_config, new_root_dir)
--             local function get_probe_dir(root_dir)
--               local project_root =
--                   vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
--               return project_root and (project_root .. "/node_modules") or ""
--             end
--
--             local function get_angular_core_version(root_dir)
--               local project_root =
--                   vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
--               if not project_root then
--                 return ""
--               end
--
--               local package_json = project_root .. "/package.json"
--               if not vim.uv.fs_stat(package_json) then
--                 return ""
--               end
--
--               local contents = io.open(package_json):read("*a")
--               local json = vim.json.decode(contents)
--               if not json.dependencies then
--                 return ""
--               end
--
--               local angular_core_version = json.dependencies["@angular/core"]
--               return angular_core_version and angular_core_version:match("%d+%.%d+%.%d+") or ""
--             end
--
--             local probe_dir = get_probe_dir(new_root_dir)
--             local angular_version = get_angular_core_version(new_root_dir)
--
--             new_config.cmd = {
--               vim.fn.expand("~/.local/share/nvim/mason/bin/ngserver"),
--               "--stdio",
--               "--tsProbeLocations",
--               probe_dir,
--               "--ngProbeLocations",
--               probe_dir,
--               "--angularCoreVersion",
--               angular_version,
--             }
--           end,
--         })
--
--         lspconfig.ts_ls.setup({
--           -- root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
--           -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
--           -- settings = {
--           -- 	typescript = {
--           -- 		format = {
--           -- 			indentSize = 2,
--           -- 			convertTabsToSpaces = true,
--           -- 			tabSize = 2,
--           -- 		},
--           -- 	},
--           -- },
--         })
--
--         vim.diagnostic.config({
--           virtual_text = {
--             prefix = "●", -- Símbolo personalizado
--             spacing = 2,
--           },
--           -- Melhoria visual para sinais no gutter
--           signs = {
--             text = {
--               [vim.diagnostic.severity.ERROR] = " ",
--               [vim.diagnostic.severity.WARN] = " ",
--               [vim.diagnostic.severity.HINT] = " ",
--               [vim.diagnostic.severity.INFO] = " ",
--             },
--           },
--           underline = true,
--           update_in_insert = false,
--           severity_sort = true,
--           float = {
--             border = "rounded", -- Borda bonita para hover
--             source = "always",
--           },
--         })
--       end,
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about Neotree.     ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "nvim-neo-tree/neo-tree.nvim",
--       branch = "v3.x",
--       dependencies = {
--         "nvim-lua/plenary.nvim",
--         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
--         "MunifTanjim/nui.nvim",
--         -- Optional image support for file preview: See `# Preview Mode` for more information.
--         -- {"3rd/image.nvim", opts = {}},
--         -- OR use snacks.nvim's image module:
--         -- "folke/snacks.nvim",
--       },
--       lazy = false, -- neo-tree will lazily load itself
--       ---@module "neo-tree"
--       ---@type neotree.Config?
--       opts = {
--         filesystem = {
--           filtered_items = {
--             visible = true,    -- mostra arquivos ocultos
--             hide_dotfiles = false, -- mostra arquivos que começam com "."
--             hide_gitignored = false, -- mostra arquivos ignorados pelo git
--           },
--         },
--         -- add options here
--       },
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about none-ls.     ##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "nvimtools/none-ls.nvim",
--       dependencies = {
--         "nvimtools/none-ls-extras.nvim", -- <- adiciona Isso
--       },
--       config = function()
--         local null_ls = require("null-ls")
--
--         null_ls.setup({
--           sources = {
--             null_ls.builtins.formatting.stylua,
--
--             null_ls.builtins.completion.spell,
--             -- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
--           },
--         })
--         vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
--       end,
--     },
--
--     -- ###############################
--     -- ##                           ##
--     -- ## Plugin about Completicion.##
--     -- ##                           ##
--     -- ###############################
--
--     {
--       "hrsh7th/nvim-cmp",
--       dependencies = {
--         "hrsh7th/cmp-nvim-lsp",
--         "L3MON4D3/LuaSnip",
--         "saadparwaiz1/cmp_luasnip",
--       },
--       config = function()
--         local cmp = require("cmp")
--         cmp.setup({
--           snippet = {
--             expand = function(args)
--               require("luasnip").lsp_expand(args.body)
--             end,
--           },
--           mapping = cmp.mapping.preset.insert({
--             ["<C-Space>"] = cmp.mapping.complete(),
--             ["<CR>"] = cmp.mapping.confirm({ select = true }),
--           }),
--           sources = cmp.config.sources({
--             { name = "nvim_lsp" },
--             { name = "luasnip" },
--           }),
--         })
--       end,
--     },
--   },
--
--   rocks = {
--     hererocks = false, -- Desativa hererocks
--     enabled = false, -- Desativa completamente luarocks
--   },
--
--   -- Configure any other settings here. See the documentation for more details.
--   -- colorscheme that will be used when installing plugins.
--   install = { colorscheme = { "habamax" } },
--   -- automatically check for plugin updates
--   checker = { enabled = true },
-- })

-- #############################
-- ##                         ##
-- ## About NeoVim options !  ##
-- ##                         ##
-- #############################


-- Basic settings
vim.o.relativenumber = true
vim.o.number = true -- Isso DESATIVA completamente os números de linha
vim.g.have_nerd_font = true
vim.opt.clipboard = "unnamedplus"
-- vim.o.mouse = 'a'

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.swapfile = false

-- Identation
vim.opt.tabstop = 2      -- Número de espaços que um <Tab> representa
vim.opt.shiftwidth = 2   -- Número de espaços para indentação automática
vim.opt.softtabstop = 2
vim.opt.expandtab = true -- Converte tabs em espaços
-- vim.opt.smartident = true
-- vim.opt.autoident = true

-- Search settings
vim.cmd("set ignorecase smartcase")
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = false
-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true

-- neotree
vim.keymap.set("n", "<leader>nn", ":Neotree toggle<CR>", { desc = "Abrir Neo-tree" })
-- 'H' Toggle to hidden files.

-- Have fun with buffers.
vim.keymap.set("n", "<leader>ls", function()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
      table.insert(buffers, {
        buf = buf,
        name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"),
      })
    end
  end
  vim.ui.select(buffers, {
    prompt = "Selecione um buffer:",
    format_item = function(item)
      return string.format("[%d] %s", item.buf, item.name)
    end,
  }, function(choice)
    if choice then
      vim.cmd("buffer " .. choice.buf)
    end
  end)
end, { desc = "Listar buffers (nativo)" })

-- Split behavior
vim.opt.wrap = false -- Não quebra linhas
vim.opt.linebreak = true -- Quebra em palavras quando wrap for ativado
vim.opt.showbreak = "↪ " -- Símbolo para quebras
vim.opt.sidescroll = 5 -- Scroll horizontal suave
vim.opt.listchars:append({
  extends = "›", -- Indicador de continuação à direita
  precedes = "‹", -- Indicador de continuação à esquerda
})

vim.keymap.set("n", "zl", "5zl", { desc = "Scroll horizontal para esquerda" })
vim.keymap.set("n", "zh", "5zh", { desc = "Scroll horizontal para direita" })
vim.keymap.set("n", "zL", "zL", { desc = "Scroll horizontal amplo para esquerda" })
vim.keymap.set("n", "zH", "zH", { desc = "Scroll horizontal amplo para direita" })

vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- Window appearance
vim.opt.winblend = 10        -- Transparência em janelas flutuantes
vim.opt.pumblend = 10        -- Transparência no menu de autocompletar
vim.opt.termguicolors = true -- Habilita cores verdadeiras (24-bit)

vim.opt.fillchars:append({
  horiz = "━", -- Barra horizontal
  horizup = "┻", -- Canto superior
  horizdown = "┳", -- Canto inferior
  vert = "▌", -- Barra vertical
  vertleft = "┫", -- Canto esquerdo
  vertright = "┣", -- Canto direito
  verthoriz = "╋", -- Cruzamento
})

-- Visual cues
vim.opt.showmode = true   -- Oculta o -- INSERT -- (já que temos statusline)
vim.opt.cursorline = true -- Destaque para linha atual
-- vim.opt.colorcolumn = "100"          -- Linha guia para limite de coluna
vim.opt.list = true       -- Mostra caracteres especiais
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟨",
}

-- Ajustes específicos para tokyonight
vim.cmd([[
  " highlight ColorColumn guibg=#3b4261
  " highlight CursorLine guibg=#3b4261
  " highlight! link CursorLineNr Normal
  highlight! link WinSeparator VertSplit
  highlight DiagnosticVirtualTextError guibg=none
  highlight DiagnosticVirtualTextWarn guibg=none


  highlight WinSeparator guifg=#7aa2f7 guibg=NONE gui=bold
  " Para versão noturna do tokyonight:
  highlight WinSeparator guifg=#3b4261 guibg=NONE

  " StatusLine principal (janela ativa)

  highlight StatusLine guibg=#afb3db guifg=#1d3975 gui=bold
  " StatusLine não ativo
  highlight StatusLineNC guibg=#16161e guifg=#3b4261
  " Separador
  highlight StatusLineSeparator guifg=#7aa2f7

]])

-- Smooth scrolling
vim.opt.smoothscroll = true

-- Better diff view
vim.opt.diffopt:append("vertical") -- Diff em vertical
vim.opt.fillchars:append({
  diff = "╱",
  eob = " ", -- Remove ~ no final do buffer
})

-- #############################
-- ##                         ##
-- ## About NeoVim keymaps !  ##
-- ##                         ##
-- #############################

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Adding sens to the 'J'
vim.keymap.set("n", "<A-j>", ":call append(line('.')-1, '')<CR>", { desc = "Add empty line above" })

-- Adding 'space' character to the current line
vim.keymap.set("n", "<S-a>", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  if pos[2] >= #line then
    vim.api.nvim_set_current_line(line .. " ")
  else
    vim.api.nvim_set_current_line(line:sub(1, pos[2] + 1) .. " " .. line:sub(pos[2] + 2))
  end
  vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
end)

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end)

-- ########################
-- ##                    ##
-- ## Basic autocommands ##
-- ##                    ##
-- ########################
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ######################################
-- ##                                  ##
-- ## FloatingTerminal configuration ! ##
-- ##                                  ##
-- ######################################

local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false,
}

local function FloatingTerminal()
  -- If terminal is already open, close it (toggle behavior)
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return
  end

  -- Create buffer if it doesn't exist or is invalid
  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)

    -- Set buffer options for better terminal experience
    vim.api.nvim_buf_set_option(terminal_state.buf, "bufhidden", "hide")
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Set transparency for the floating window
  vim.api.nvim_win_set_option(terminal_state.win, "winblend", 0)

  -- Set transparent background for the window
  vim.api.nvim_win_set_option(
    terminal_state.win,
    "winhighlight",
    "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
  )

  -- Define highlight groups for transparency
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

  -- Start terminal if not already running
  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end

  if not has_terminal then
    vim.fn.termopen(os.getenv("SHELL"))
  end

  terminal_state.is_open = true
  vim.cmd("startinsert")

  -- Set up auto-close on buffer leave
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    callback = function()
      if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
      end
    end,
    once = true,
  })
end

-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end

-- Key mappings
vim.keymap.set(
  "n",
  "<leader>ft",
  FloatingTerminal,
  { noremap = true, silent = true, desc = "Toggle floating terminal" }
)
vim.keymap.set("t", "<Esc>", function()
  if terminal_state.is_open then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })

-- -- ###############################
-- -- ##                           ##
-- -- ## Things about telescope !  ##
-- -- ##                           ##
-- -- ###############################

-- local builtin = require("telescope.builtin")
-- require("telescope").load_extension("file_browser")

-- vim.keymap.set("n", "<leader>p", function()
--   builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
-- end, { desc = "Buscar arquivos na pasta do arquivo atual" })

-- vim.keymap.set("n", "<leader>bs", function()
--   local path = vim.fn.expand("%:p:h:h") -- sobe duas pastas
--   require("telescope.builtin").grep_string({
--     search = vim.fn.input("Grep > "),
--     cwd = path,
--   })
-- end, { desc = "Grep na pasta 2 níveis acima" })

-- vim.keymap.set("n", "<leader>bh", function()
--   require("telescope").extensions.file_browser.file_browser({
--     path = vim.fn.expand("%:p:h"),
--     select_buffer = true,
--     hidden = true,  -- Mostra arquivos ocultos
--     no_ignore = true, -- Ignora arquivos não-ocultos (mostra SÓ os ocultos)
--   })
-- end, { desc = "Abrir navegador de arquivos (somente ocultos)" })
