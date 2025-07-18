-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
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

    -- ###############################
    -- ##                           ##
    -- ## Plugin about colorscheme. ##
    -- ##                           ##
    -- ###############################

    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },


    -- ###############################
    -- ##                           ##
    -- ## Plugin about Autopairs.   ##
    -- ##                           ##
    -- ###############################

    {
      "windwp/nvim-autopairs", -- Autopairs
      event = "InsertEnter",
      config = true,
    },

    -- #################################
    -- ##                             ##
    -- ## Plugin about Commentstring. ##
    -- ##                             ##
    -- #################################

    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      dependencies = "nvim-treesitter/nvim-treesitter",
      lazy = true, -- Carrega apenas quando necessário
    },

    -- Plugin principal de comentários
    {
      "numToStr/Comment.nvim",
      dependencies = { -- Só carrega depois do context-commentstring
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
      config = function()
        -- Configuração do plugin + keymaps
        require("Comment").setup({
          pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })
      end,
    },

    -- ###############################
    -- ##                           ##
    -- ## Plugin about telescope.   ##
    -- ##                           ##
    -- ###############################

    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      -- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },

    -- ###############################
    -- ##                           ##
    -- ## Plugin about Harpoon.     ##
    -- ##                           ##
    -- ###############################

    {
      "ThePrimeagen/harpoon"
    },

    -- ###############################
    -- ##                           ##
    -- ## Plugin about UndoTree.    ##
    -- ##                           ##
    -- ###############################

    {
      "mbbill/undotree"
    },

    -- ###############################
    -- ##                           ##
    -- ## Plugin about TreeSitter.  ##
    -- ##                           ##
    -- ###############################

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
    },

    -- ###############################
    -- ##                           ##
    -- ## Plugin about lspconfig.   ##
    -- ##                           ##
    -- ###############################

    {
      "neovim/nvim-lspconfig",
      priority = 1000,
      config = function()
        -- Configuração de diagnósticos
        vim.diagnostic.config({
          virtual_text = {
            prefix = '●', -- Símbolo personalizado
            spacing = 2,
          },
          -- Melhoria visual para sinais no gutter
          vim.diagnostic.config({
            signs = {
              text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.HINT] = " ",
                [vim.diagnostic.severity.INFO] = " ",
              }
            }
          }),
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          float = {
            border = 'rounded', -- Borda bonita para hover
            source = 'always',
          }
        })
        require("lspconfig").lua_ls.setup {}
      end,
    },

    -- ###############################
    -- ##                           ##
    -- ## Plugin about Completicion.##
    -- ##                           ##
    -- ###############################

    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
      },
      config = function()
        local cmp = require('cmp')
        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          })
        })
      end
    }

  },

  rocks = {
    hererocks = false, -- Desativa hererocks
    enabled = false    -- Desativa completamente luarocks
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Setting a nvim colorscheme.
vim.cmd [[colorscheme tokyonight-night]]

-- Setting vim options.
vim.o.relativenumber = true
vim.o.number = true -- Isso DESATIVA completamente os números de linha
vim.g.have_nerd_font = true
vim.o.mouse = 'a'
vim.opt.tabstop = 2      -- Número de espaços que um <Tab> representa
vim.opt.shiftwidth = 2   -- Número de espaços para indentação automática
vim.opt.expandtab = true -- Converte tabs em espaços
vim.o.ignorecase = true
vim.o.smartcase = true



-- #############################
-- ##                         ##
-- ## About NeoVim keymaps !  ##
-- ##                         ##
-- #############################

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set("n", "<leader>cc", "gcc", { desc = "Toggle comment (line)" })
vim.keymap.set("v", "<leader>c", "gc", { desc = "Comment the selection" })



-- ###############################
-- ##                           ##
-- ## Things about telescope !  ##
-- ##                           ##
-- ###############################

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


vim.keymap.set("n", "<leader>bh", function()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"),
    select_buffer = true,
    hidden = true,    -- Mostra arquivos ocultos
    no_ignore = true, -- Ignora arquivos não-ocultos (mostra SÓ os ocultos)
  })
end, { desc = "Abrir navegador de arquivos (somente ocultos)" })



-- ###########################################
-- ##                                       ##
-- ## Things about clipboard configuration. ##
-- ##                                       ##
-- ###########################################
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

vim.keymap.set("n", "<leader>d", function()
  local mark = require("harpoon.mark")
  mark.rm_file() -- Remove o arquivo atual da lista
end, { desc = "Remover arquivo atual do Harpoon" })

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




-- #######################
-- ##                   ##
-- ## Things about Lsp. ##
-- ##                   ##
-- #######################


local lsp = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Configuração de capabilities para autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Função de ativação
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
  vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
end

-- Configuração específica para Lua (NixOS)
lsp.lua_ls.setup({
  cmd = { 'lua-language-server' }, -- Caminho completo se necessário
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = {
          vim.env.VIMRUNTIME,
          -- Adicione caminhos específicos do NixOS aqui
        }
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true)
      },
      telemetry = { enable = false }
    }
  }
})


-- Mapeamento manual de formatação
vim.keymap.set('n', '<leader>f', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Formatar código' })

-- Verificação de status
vim.keymap.set('n', '<leader>vl', vim.cmd.LspInfo, { desc = 'Verificar status LSP' })
