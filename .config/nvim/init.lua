require("config.lazy")

local buffer_manager = require("config.buffer-manager")

-- Inicializa o módulo
buffer_manager.setup()
buffer_manager.setup_keymaps()
buffer_manager.setup_autocmds()

-- Basic settings
vim.o.relativenumber = true
vim.o.number = true
vim.g.have_nerd_font = true
vim.opt.clipboard = "unnamedplus"
-- vim.o.mouse = 'a'

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.swapfile = false

-- Identation
vim.opt.tabstop = 2       -- Número de espaços que um <Tab> representa
vim.opt.shiftwidth = 2    -- Número de espaços para indentação automática
vim.opt.softtabstop = 2
vim.opt.expandtab = false -- Converte tabs em espaços
-- vim.opt.smartident = true
-- vim.opt.autoident = true

-- Search settings
-- vim.cmd("set ignorecase smartcase")
vim.opt.ignorecase = true
-- vim.opt.smartcase = false
-- vim.opt.hlsearch = false
vim.opt.incsearch = true

-- neotree
vim.keymap.set("n", "<leader>nn", ":Neotree toggle<CR>", { desc = "Abrir Neo-tree" })
-- 'H' Toggle to hidden files.

-- Split behavior
vim.opt.wrap = false -- Não quebra linhas
vim.opt.linebreak = true -- Quebra em palavras quando wrap for ativado
vim.opt.showbreak = "↪ " -- Símbolo para quebras
vim.opt.sidescroll = 5 -- Scroll horizontal suave
-- vim.opt.listchars:append({
--   extends = "›", -- Indicador de continuação à direita
--   precedes = "‹", -- Indicador de continuação à esquerda
-- })

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

vim.api.nvim_set_hl(0, "CursorLineNr", {
	fg = "#ff9e64",
	bg = "none",
	bold = true,
})
-- Define a cor do highlight quando um texto é yanked (copiado)
vim.api.nvim_set_hl(0, "IncSearch", {
	bg = "#c98f5d",
	fg = "black",    -- Cor do texto (opcional)
	bold = true,     -- Negrito (opcional)
	underline = true, -- Sublinhado (opcional)
})

-- Ajustes específicos para tokyonight
vim.cmd([[
  " highlight CursorLine guibg=#353842
	highlight CursorLine guibg=none
  highlight! link WinSeparator VertSplit
  highlight DiagnosticVirtualTextError guibg=none
  highlight DiagnosticVirtualTextWarn guibg=none
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
-- ## About NeoVim keymaps!   ##
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


-- Adiciona TAB nas linhas selecionadas (modo visual)
vim.keymap.set("v", "<leader>a", ">gv", { noremap = true, silent = true })

-- Remove TAB das linhas selecionadas (modo visual)
vim.keymap.set("v", "<leader>x", "<gv", { noremap = true, silent = true })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Adding sens to the 'J'
vim.keymap.set("n", "<A-j>", ":call append(line('.')-1, '')<CR>", { desc = "Add empty line above" })

-- Abre lista de diagnósticos e permite copiar
vim.keymap.set("n", "<leader>ld", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen") -- Abre a janela quickfix
end, { desc = "Listar diagnósticos" })

-- Depois na janela quickfix, pressione 'yy' para copiar a mensagem selecionada

-- Adding 'space' character to the current line
vim.keymap.set("n", "<S-q>", function()
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
