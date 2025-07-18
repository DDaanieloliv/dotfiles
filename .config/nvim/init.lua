

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

    -- Substitua sua configuração atual do Harpoon por:
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("harpoon").setup({})
      end
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


-- #############################
-- ##                         ##
-- ## About NeoVim options !  ##
-- ##                         ##
-- #############################

vim.cmd [[colorscheme tokyonight-night]]

-- Basic settings
vim.o.relativenumber = true
vim.o.number = true -- Isso DESATIVA completamente os números de linha
vim.g.have_nerd_font = true
-- vim.o.mouse = 'a'
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Identation
vim.opt.tabstop = 2      -- Número de espaços que um <Tab> representa
vim.opt.shiftwidth = 2   -- Número de espaços para indentação automática
vim.opt.softtabstop = 2
vim.opt.expandtab = true -- Converte tabs em espaços
-- vim.opt.smartident = true
-- vim.opt.autoident = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true


-- Split behavior
vim.opt.wrap = false               -- Não quebra linhas
vim.opt.linebreak = true           -- Quebra em palavras quando wrap for ativado
vim.opt.showbreak = '↪ '           -- Símbolo para quebras
vim.opt.sidescroll = 5             -- Scroll horizontal suave
vim.opt.listchars:append({
  extends = '›',                   -- Indicador de continuação à direita
  precedes = '‹',                  -- Indicador de continuação à esquerda
})

vim.keymap.set('n', 'zl', '5zl', { desc = 'Scroll horizontal para esquerda' })
vim.keymap.set('n', 'zh', '5zh', { desc = 'Scroll horizontal para direita' })
vim.keymap.set('n', 'zL', 'zL', { desc = 'Scroll horizontal amplo para esquerda' })
vim.keymap.set('n', 'zH', 'zH', { desc = 'Scroll horizontal amplo para direita' })

vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right




-- Window appearance
vim.opt.winblend = 10        -- Transparência em janelas flutuantes
vim.opt.pumblend = 10        -- Transparência no menu de autocompletar
vim.opt.termguicolors = true -- Habilita cores verdadeiras (24-bit)

vim.opt.fillchars:append({
  horiz = '━', -- Barra horizontal
  horizup = '┻', -- Canto superior
  horizdown = '┳', -- Canto inferior
  vert = '┃', -- Barra vertical
  vertleft = '┫', -- Canto esquerdo
  vertright = '┣', -- Canto direito
  verthoriz = '╋', -- Cruzamento
})

-- vim.opt.winbar = "%=%m %f"  -- Opcional: melhora a barra superior da janela

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
  precedes = "⟨"
}

-- Ajustes específicos para tokyonight
vim.cmd [[
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

]]

-- Smooth scrolling
vim.opt.smoothscroll = true

-- Better diff view
vim.opt.diffopt:append("vertical") -- Diff em vertical
vim.opt.fillchars:append({
  diff = "╱",
  eob = " " -- Remove ~ no final do buffer
})

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
    vim.api.nvim_set_current_line(line.." ")
  else
    vim.api.nvim_set_current_line(line:sub(1,pos[2]+1).." "..line:sub(pos[2]+2))
  end
  vim.api.nvim_win_set_cursor(0, {pos[1], pos[2]+1})
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

-- -- Disable line numbers in terminal
-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = augroup,
--   callback = function()
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--     vim.opt_local.signcolumn = "no"
--   end,
-- })





-- ######################################
-- ##                                  ##
-- ## FloatingTerminal configuration ! ##
-- ##                                  ##
-- ######################################

local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
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
    vim.api.nvim_buf_set_option(terminal_state.buf, 'bufhidden', 'hide')
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set transparency for the floating window
  vim.api.nvim_win_set_option(terminal_state.win, 'winblend', 0)

  -- Set transparent background for the window
  vim.api.nvim_win_set_option(terminal_state.win, 'winhighlight',
    'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder')

  -- Define highlight groups for transparency
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })

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
    once = true
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
vim.keymap.set("n", "<leader>ft", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
  if terminal_state.is_open then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })






-- #################################
-- ##                             ##
-- ## TabLineFill Configuration ! ##
-- ##                             ##
-- #################################

-- Tab display settings
vim.opt.showtabline = 1 -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
vim.opt.tabline = ''    -- Use default tabline (empty string uses built-in)



-- Transparent tabline appearance
vim.cmd([[
  hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE
]])



-- Alternative navigation (more intuitive)
vim.keymap.set('n', '<leader>	', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>q', ':tabclose<CR>', { desc = 'Close tab' })




-- Navegação entre tabs com tratamento de erros e feedback visual
for i = 1, 9 do
  vim.keymap.set('n', '<A-'..i..'>', function()
    local total_tabs = vim.fn.tabpagenr('$')
    
    if i <= total_tabs then
      vim.cmd(i..'tabnext')
      
      -- Feedback visual discreto (opcional)
      vim.defer_fn(function()
        vim.notify("Tab "..i.."/"..total_tabs, vim.log.levels.INFO, {
          title = "Navegação",
          timeout = 800,
          icon = ""
        })
      end, 50)
    else
      -- Mensagem amigável para tab inexistente
      vim.notify("Tab "..i.." não existe (máx: "..total_tabs..")", vim.log.levels.WARN, {
        title = "Navegação de Tabs",
        timeout = 2000,
        icon = "⚠️"
      })
      
      -- Pisca a tab atual como feedback
      local original_color = vim.api.nvim_get_hl_by_name('TabLineSel', true)
      vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#ff0000', fg = original_color.fg })
      vim.defer_fn(function()
        vim.api.nvim_set_hl(0, 'TabLineSel', original_color)
      end, 300)
    end
  end, { desc = 'Ir para Tab '..i })
end




-- Tab moving
vim.keymap.set('n', '<leader>tm', ':tabmove<CR>', { desc = 'Move tab' })
vim.keymap.set('n', '<leader>t>', ':tabmove +1<CR>', { desc = 'Move tab right' })
vim.keymap.set('n', '<leader>t<', ':tabmove -1<CR>', { desc = 'Move tab left' })




-- Function to open file in new tab
local function open_file_in_tab()
  vim.ui.input({ prompt = 'File to open in new tab: ', completion = 'file' }, function(input)
    if input and input ~= '' then
      vim.cmd('tabnew ' .. input)
    end
  end)
end



-- Function to duplicate current tab
local function duplicate_tab()
  local current_file = vim.fn.expand('%:p')
  if current_file ~= '' then
    vim.cmd('tabnew ' .. current_file)
  else
    vim.cmd('tabnew')
  end
end



-- Function to close tabs to the right
local function close_tabs_right()
  local current_tab = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr('$')

  for i = last_tab, current_tab + 1, -1 do
    vim.cmd(i .. 'tabclose')
  end
end



-- Function to close tabs to the left
local function close_tabs_left()
  local current_tab = vim.fn.tabpagenr()

  for i = current_tab - 1, 1, -1 do
    vim.cmd('1tabclose')
  end
end


-- Enhanced keybindings
vim.keymap.set('n', '<leader>tO', open_file_in_tab, { desc = 'Open file in new tab' })
vim.keymap.set('n', '<leader>td', duplicate_tab, { desc = 'Duplicate current tab' })
vim.keymap.set('n', '<leader>tr', close_tabs_right, { desc = 'Close tabs to the right' })
vim.keymap.set('n', '<leader>tL', close_tabs_left, { desc = 'Close tabs to the left' })


-- Function to close buffer but keep tab if it's the only buffer in tab
local function smart_close_buffer()
  local buffers_in_tab = #vim.fn.tabpagebuflist()
  if buffers_in_tab > 1 then
    vim.cmd('bdelete')
  else
    -- If it's the only buffer in tab, close the tab
    vim.cmd('tabclose')
  end
end
vim.keymap.set('n', '<leader>bd', smart_close_buffer, { desc = 'Smart close buffer/tab' })






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

local harpoon = require("harpoon")

-- Configuração básica
harpoon.setup({
  menu = {
    width = 60,
    height = 20,
  }
})

-- Atalhos ESSENCIAIS
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Adicionar arquivo" })
vim.keymap.set("n", "<leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Menu Harpoon" })

-- REMOVER ÚLTIMO ARQUIVO (solução definitiva)
vim.keymap.set("n", "<leader>r", function()
  local list = harpoon:list()
  if #list.items > 0 then
    list:remove_at(#list.items)
    vim.notify("Removido último arquivo: " .. list.items[#list.items].value, vim.log.levels.INFO)
  else
    vim.notify("Lista vazia!", vim.log.levels.WARN)
  end
end, { desc = "Remover último arquivo" })



-- REMOVER ARQUIVO ATUAL (opcional)
vim.keymap.set("n", "<leader>d", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  harpoon:list():remove(current_file)
end, { desc = "Remover arquivo atual" })





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
