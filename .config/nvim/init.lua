require("config.lazy")

-- vim.lsp.enable('pyright')

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
vim.opt.tabstop = 2       -- Número de espaços que um <Tab> representa
vim.opt.shiftwidth = 2    -- Número de espaços para indentação automática
vim.opt.softtabstop = 2
vim.opt.expandtab = false -- Converte tabs em espaços
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
-- vim.keymap.set("n", "<leader>ls", function()
--     local buffers = {}
--     for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--         if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
--             table.insert(buffers, {
--                 buf = buf, -- Número real do buffer (não será exibido)
--                 name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"),
--             })
--         end
--     end
--
--     vim.ui.select(buffers, {
--         prompt = "Selecione um buffer:",
--         format_item = function(item)
--             -- Adiciona um número sequencial baseado na posição na lista
--             local index = 0
--             for i, b in ipairs(buffers) do
--                 if b.buf == item.buf then
--                     index = i
--                     break
--                 end
--             end
--             return string.format("[%d] %s", index, item.name) -- Número fictício (1, 2, 3...)
--         end,
--     }, function(choice)
--         if choice then
--             vim.cmd("buffer " .. choice.buf)
--         end
--     end)
-- end, { desc = "Listar buffers (nativo)" })

vim.keymap.set("n", "<leader>ls", function()
    local buffers = {}
    local ignored_patterns = {
        "neo%-tree", -- Padrão para buffers do NeoTree (com escaping para o hífen)
        "Telescope",
        "term://",
        "^no name",
    }

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local buf_filetype = vim.api.nvim_buf_get_option(buf, "filetype")

        -- Verifica se o buffer deve ser ignorado
        local is_ignored = false
        for _, pattern in ipairs(ignored_patterns) do
            if buf_name:match(pattern) or buf_filetype:match(pattern) then
                is_ignored = true
                break
            end
        end

        -- Filtro adicional para NeoTree (caso o padrão não capture todos os casos)
        if not is_ignored then
            if buf_filetype == "neo-tree" or buf_name:match("neo%-tree") then
                is_ignored = true
            end
        end

        -- Adiciona apenas buffers válidos e não ignorados
        if not is_ignored and vim.api.nvim_buf_is_loaded(buf) and buf_name ~= "" then
            table.insert(buffers, {
                buf = buf,
                name = vim.fn.fnamemodify(buf_name, ":t"), -- Nome do arquivo sem o caminho
            })
        end
    end

    -- Exibe a lista de buffers com numeração sequencial
    vim.ui.select(buffers, {
        prompt = "Selecione um buffer:",
        format_item = function(item)
            local index = 0
            for i, b in ipairs(buffers) do
                if b.buf == item.buf then
                    index = i
                    break
                end
            end
            return string.format("[%d] %s", index, item.name)
        end,
    }, function(choice)
        if choice then
            vim.cmd("buffer " .. choice.buf)
        end
    end)
end, { desc = "Listar buffers (filtro robusto para NeoTree)" })



local cache_file = vim.fn.expand("~/.nvim_buffers_cache.lua") -- Arquivo para persistir os dados

-- Tabela para armazenar buffers por diretório (em memória)
local buffer_cache = {}

-- Carrega o cache do arquivo (se existir)
local function load_cache()
    if vim.fn.filereadable(cache_file) == 1 then
        buffer_cache = vim.fn.luaeval("dofile('" .. cache_file .. "')") or {}
    end
end

-- Salva o cache no arquivo
local function save_cache()
    local file = io.open(cache_file, "w")
    if file then
        file:write("return " .. vim.inspect(buffer_cache))
        file:close()
    end
end

-- Atualiza o cache com os buffers do diretório atual
local function update_cache()
    local cwd = vim.fn.getcwd() -- Diretório atual
    if not buffer_cache[cwd] then
        buffer_cache[cwd] = {}
    end

    -- Adiciona buffers válidos ao cache
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if vim.api.nvim_buf_is_loaded(buf) and buf_name ~= "" then
            local relative_path = vim.fn.fnamemodify(buf_name, ":~:.") -- Path relativo
            if not vim.tbl_contains(buffer_cache[cwd], relative_path) then
                table.insert(buffer_cache[cwd], relative_path)
            end
        end
    end

    save_cache() -- Persiste no arquivo
end

-- -- Lista buffers (incluindo os do cache)
-- vim.keymap.set("n", "<leader>ls", function()
--     local cwd = vim.fn.getcwd()
--     local cached_buffers = buffer_cache[cwd] or {}
--
--     -- Combina buffers abertos e cache
--     local all_buffers = {}
--     for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--         local buf_name = vim.api.nvim_buf_get_name(buf)
--         if vim.api.nvim_buf_is_loaded(buf) and buf_name ~= "" then
--             table.insert(all_buffers, {
--                 buf = buf,
--                 name = vim.fn.fnamemodify(buf_name, ":t"),
--                 path = buf_name,
--             })
--         end
--     end
--
--     -- Adiciona buffers do cache que não estão abertos
--     for _, path in ipairs(cached_buffers) do
--         local exists = false
--         for _, b in ipairs(all_buffers) do
--             if b.path == path then
--                 exists = true
--                 break
--             end
--         end
--         if not exists then
--             table.insert(all_buffers, {
--                 buf = nil, -- Indica que está no cache mas não aberto
--                 name = vim.fn.fnamemodify(path, ":t"),
--                 path = path,
--             })
--         end
--     end
--
--     -- Exibe a lista
--     vim.ui.select(all_buffers, {
--         prompt = "Selecione um buffer (✓ = aberto, ✗ = cache):",
--         format_item = function(item)
--             local status = item.buf and "✓" or "✗"
--             return string.format("[%s] %s (%s)", status, item.name, item.path)
--         end,
--     }, function(choice)
--         if choice then
--             if choice.buf then
--                 vim.cmd("buffer " .. choice.buf) -- Buffer já aberto
--             else
--                 vim.cmd("edit " .. choice.path) -- Abre do cache
--             end
--         end
--     end)
-- end, { desc = "Listar buffers (com cache por diretório)" })
--
-- -- Atualiza o cache ao sair do Neovim
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--     callback = function()
--         update_cache()
--     end,
-- })
--
-- -- Inicializa o cache
-- load_cache()


-- vim.keymap.set("n", "<leader>ls", function()
--     local buffers = {}
--     for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--         if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
--             table.insert(buffers, {
--                 buf = buf,
--                 name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"), -- Pega apenas o nome do arquivo
--             })
--         end
--     end
--     vim.ui.select(buffers, {
--         prompt = "Selecione um buffer:",
--         format_item = function(item)
--             return item.name -- Remove o "[%d]" e mostra apenas o nome
--         end,
--     }, function(choice)
--         if choice then
--             vim.cmd("buffer " .. choice.buf)
--         end
--     end)
-- end, { desc = "Listar buffers (nativo)" })


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



-- vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
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
  " highlight ColorColumn guibg=#3b4261
  highlight CursorLine guibg=#353842
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

-- Adiciona TAB nas linhas selecionadas (modo visual)
vim.keymap.set('v', '<S-t>', '>gv', { noremap = true, silent = true })

-- Remove TAB das linhas selecionadas (modo visual)
vim.keymap.set('v', '<S-x', '<gv', { noremap = true, silent = true })


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
		vim.api.nvim_buf_set_option(terminal_state.buf, "bufhidden", "hide") -- Diagnostic: Deprecated apparently.
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
	vim.api.nvim_win_set_option(terminal_state.win, "winblend", 0) -- Diagnostic: Deprecated apparently.

	-- Set transparent background for the window
	vim.api.nvim_win_set_option( -- Diagnostic: Deprecated apparently.
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
