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
vim.opt.tabstop = 2 -- Número de espaços que um <Tab> representa
vim.opt.shiftwidth = 2 -- Número de espaços para indentação automática
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

-- vim.keymap.set("n", "<leader>ls", function()
-- 	local buffers = {}
-- 	local ignored_patterns = {
-- 		"neo%-tree", -- Padrão para buffers do NeoTree (com escaping para o hífen)
-- 		"Telescope",
-- 		"term://",
-- 		"^no name",
-- 	}
--
-- 	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
-- 		local buf_name = vim.api.nvim_buf_get_name(buf)
-- 		local buf_filetype = vim.api.nvim_buf_get_option(buf, "filetype")
--
-- 		-- Verifica se o buffer deve ser ignorado
-- 		local is_ignored = false
-- 		for _, pattern in ipairs(ignored_patterns) do
-- 			if buf_name:match(pattern) or buf_filetype:match(pattern) then
-- 				is_ignored = true
-- 				break
-- 			end
-- 		end
--
-- 		-- Filtro adicional para NeoTree (caso o padrão não capture todos os casos)
-- 		if not is_ignored then
-- 			if buf_filetype == "neo-tree" or buf_name:match("neo%-tree") then
-- 				is_ignored = true
-- 			end
-- 		end
--
-- 		-- Adiciona apenas buffers válidos e não ignorados
-- 		if not is_ignored and vim.api.nvim_buf_is_loaded(buf) and buf_name ~= "" then
-- 			table.insert(buffers, {
-- 				buf = buf,
-- 				name = vim.fn.fnamemodify(buf_name, ":t"), -- Nome do arquivo sem o caminho
-- 			})
-- 		end
-- 	end
--
-- 	-- Exibe a lista de buffers com numeração sequencial
-- 	vim.ui.select(buffers, {
-- 		prompt = "Selecione um buffer:",
-- 		format_item = function(item)
-- 			local index = 0
-- 			for i, b in ipairs(buffers) do
-- 				if b.buf == item.buf then
-- 					index = i
-- 					break
-- 				end
-- 			end
-- 			return string.format("[%d] %s", index, item.name)
-- 		end,
-- 	}, function(choice)
-- 		if choice then
-- 			vim.cmd("buffer " .. choice.buf)
-- 		end
-- 	end)
-- end, { desc = "Listar buffers (filtro robusto para NeoTree)" })


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
vim.opt.winblend = 10 -- Transparência em janelas flutuantes
vim.opt.pumblend = 10 -- Transparência no menu de autocompletar
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
vim.opt.showmode = true -- Oculta o -- INSERT -- (já que temos statusline)
vim.opt.cursorline = true -- Destaque para linha atual
-- vim.opt.colorcolumn = "100"          -- Linha guia para limite de coluna
vim.opt.list = true -- Mostra caracteres especiais
vim.opt.listchars = {
	tab = "→ ",
	trail = "·",
	nbsp = "␣",
	extends = "⟩",
	precedes = "⟨",
}

-- vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", {
	fg = "#ff9e64",
	bg = "none",
	bold = true,
})
-- Define a cor do highlight quando um texto é yanked (copiado)
vim.api.nvim_set_hl(0, "IncSearch", {
	bg = "#c98f5d",
	fg = "black", -- Cor do texto (opcional)
	bold = true, -- Negrito (opcional)
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
vim.keymap.set("v", "<S-t>", ">gv", { noremap = true, silent = true })

-- Remove TAB das linhas selecionadas (modo visual)
vim.keymap.set("v", "<S-x", "<gv", { noremap = true, silent = true })

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






local M = {}

-- Configurações
local cache_dir = vim.fn.stdpath('data') .. '/buffer_cache'
local cache_file = cache_dir .. '/buffers.lua'

-- Função para verificar se um buffer é válido
local function is_valid_buffer(buf)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
    
    return buf_name ~= "" 
        and buftype == "" 
        and filetype ~= ""
        and vim.fn.filereadable(buf_name) == 1
end

-- Inicializa o sistema de cache
function M.setup()
    if vim.fn.isdirectory(cache_dir) == 0 then
        vim.fn.mkdir(cache_dir, 'p')
    end

    if vim.fn.filereadable(cache_file) == 0 then
        M.save_cache({})
    end
end

-- Carrega o cache do arquivo
function M.load_cache()
    local ok, cache = pcall(dofile, cache_file)
    if ok and cache then
        return cache
    end
    return {}
end

-- Salva o cache no arquivo
function M.save_cache(cache)
    local file = io.open(cache_file, 'w')
    if file then
        file:write('return ' .. vim.inspect(cache))
        file:close()
    end
end

-- Obtém o path atual formatado
function M.get_current_path()
    return vim.fn.getcwd()
end

-- Adiciona um buffer ao cache do path atual
function M.add_buffer_to_cache()
    local current_path = M.get_current_path()
    local buf_name = vim.api.nvim_buf_get_name(0)
    
    if not is_valid_buffer(0) then return end
    
    local cache = M.load_cache()
    cache[current_path] = cache[current_path] or {}
    
    local exists = false
    for _, item in ipairs(cache[current_path]) do
        if item.path == buf_name then
            exists = true
            break
        end
    end
    
    if not exists then
        table.insert(cache[current_path], {
            name = vim.fn.fnamemodify(buf_name, ':t'),
            path = buf_name,
        })
        M.save_cache(cache)
    end
end

-- Remove o buffer atual do cache
function M.remove_current_buffer_from_cache()
    local current_path = M.get_current_path()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local cache = M.load_cache()
    
    if not cache[current_path] then return end
    
    for i, item in ipairs(cache[current_path]) do
        if item.path == buf_name then
            if #cache[current_path] == 1 then
                vim.notify("Não é possível remover o último buffer do path atual!", vim.log.levels.WARN)
                return
            end
            
            table.remove(cache[current_path], i)
            M.save_cache(cache)
            break
        end
    end
end

-- Remove o último buffer adicionado do path atual
function M.remove_last_buffer_from_cache()
    local current_path = M.get_current_path()
    local cache = M.load_cache()
    
    if not cache[current_path] or #cache[current_path] == 0 then
        vim.notify("Nenhum buffer para remover neste path!", vim.log.levels.WARN)
        return
    end
    
    local last_buffer = cache[current_path][#cache[current_path]].path
    local current_buffer = vim.api.nvim_buf_get_name(0)
    
    if last_buffer == current_buffer then
        vim.notify("Não é possível remover o buffer atual se for o último!", vim.log.levels.WARN)
        return
    end
    
    table.remove(cache[current_path])
    M.save_cache(cache)
end

-- Limpa todo o cache
function M.clear_cache()
    M.save_cache({})
    vim.notify("Cache de buffers limpo com sucesso!", vim.log.levels.INFO)
end

-- Lista buffers do cache do path atual
function M.list_buffers()
    local current_path = M.get_current_path()
    local cache = M.load_cache()
    local buffers = cache[current_path] or {}
    
    -- Filtra buffers que ainda existem
    local valid_buffers = {}
    for i, item in ipairs(buffers) do
        table.insert(valid_buffers, {
            index = i,
            name = item.name,
            path = item.path,
            is_open = vim.fn.bufexists(vim.fn.bufadd(item.path)) == 1
        })
    end
    
    -- Exibe lista numerada
    vim.ui.select(valid_buffers, {
        prompt = "Buffers:",
        format_item = function(item)
            local status = item.is_open and "✓" or " "
            return string.format("[%d] %s %s (%s)", item.index, status, item.name, item.path)
        end,
    }, function(choice)
        if choice then 
            if vim.fn.bufexists(vim.fn.bufadd(choice.path)) == 1 then
                vim.cmd("buffer " .. vim.fn.bufadd(choice.path))
            else
                vim.cmd("edit " .. choice.path)
            end
        end
    end)
end

-- Configura os keymaps
function M.setup_keymaps()
    vim.keymap.set('n', '<leader>ls', M.list_buffers, { desc = 'Listar buffers (com cache)' })
    
    vim.keymap.set('n', '<leader>q', function()
        M.remove_current_buffer_from_cache()
        vim.cmd('bd')
    end, { desc = 'Remover buffer do cache e fechar' })
    
    vim.keymap.set('n', '<leader>r', M.remove_last_buffer_from_cache, { desc = 'Remover último buffer do cache' })
    
    vim.keymap.set('n', '<leader>cc', M.clear_cache, { desc = 'Limpar todo o cache de buffers' })
    
    for i = 1, 9 do
        vim.keymap.set('n', '<A-'..i..'>', function()
            local current_path = M.get_current_path()
            local cache = M.load_cache()
            local buffers = cache[current_path] or {}
            
            if buffers[i] then
                if vim.fn.filereadable(buffers[i].path) == 1 then
                    if vim.fn.bufexists(vim.fn.bufadd(buffers[i].path)) == 1 then
                        vim.cmd("buffer " .. vim.fn.bufadd(buffers[i].path))
                    else
                        vim.cmd("edit " .. buffers[i].path)
                    end
                else
                    vim.notify('Arquivo não existe mais: '..buffers[i].path, vim.log.levels.WARN)
                end
            else
                vim.notify('Não há buffer na posição '..i, vim.log.levels.WARN)
            end
        end, { desc = 'Abrir buffer '..i..' do cache' })
    end
end

-- Autocomandos para gerenciamento automático
function M.setup_autocmds()
    -- Registrar buffer quando for aberto
    vim.api.nvim_create_autocmd('BufEnter', {
        callback = function(args)
            local buf = args.buf
            if is_valid_buffer(buf) then
                -- Verifica se foi um buffer aberto manualmente (não por plugin)
                local buf_name = vim.api.nvim_buf_get_name(buf)
                local is_plugin_buffer = false
                
                -- Lista de padrões de plugins para ignorar
                local ignore_patterns = {
                    "neo%-tree",
                    "telescope",
                    "NvimTree",
                    "packer",
                    "fugitive",
                    "term://",
                    "^no name",
                }
                
                for _, pattern in ipairs(ignore_patterns) do
                    if buf_name:match(pattern) then
                        is_plugin_buffer = true
                        break
                    end
                end
                
                if not is_plugin_buffer then
                    M.add_buffer_to_cache()
                end
            end
        end,
    })
    -- Atualizar cache quando mudar de diretório
    vim.api.nvim_create_autocmd('DirChanged', {
        callback = function()
            -- Limpa buffers inválidos ao mudar de diretório
            local cache = M.load_cache()
            local current_path = M.get_current_path()
            if cache[current_path] then
                local new_list = {}
                for _, item in ipairs(cache[current_path]) do
                    if vim.fn.filereadable(item.path) == 1 then
                        table.insert(new_list, item)
                    end
                end
                cache[current_path] = new_list
                M.save_cache(cache)
            end
        end,
    })
end

-- Inicializa o módulo
M.setup()
M.setup_keymaps()
M.setup_autocmds()

return M

