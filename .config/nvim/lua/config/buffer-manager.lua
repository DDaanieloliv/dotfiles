local M = {}

-- Função auxiliar para substituir nvim_buf_get_option
local function get_buf_option(bufnr, option)
	return vim.api.nvim_get_option_value(option, { buf = bufnr })
end

-- Função para encontrar buffer pelo caminho
local function find_buffer_by_path(path)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_name(buf) == path then
			return buf
		end
	end
	return nil
end

-- Verifica se o buffer atual é um '[No Name]' que pode ser reutilizado
-- local function is_reusable_unnamed_buffer()
-- 	local buf_name = vim.api.nvim_buf_get_name(0)
-- 	local buftype = get_buf_option(0, "buftype")
-- 	return buf_name == "" and buftype == ""
-- end
local function is_reusable_unnamed_buffer()
    return false
end


-- Configurações
local cache_dir = vim.fn.stdpath("data") .. "/buffer_cache"
local cache_file = cache_dir .. "/buffers.lua"

-- Função para verificar se um buffer é válido
-- local function is_valid_buffer(buf)
-- 	local buf_name = vim.api.nvim_buf_get_name(buf)
-- 	local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
-- 	local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
--
-- 	return buf_name ~= "" and buftype == "" and filetype ~= "" and vim.fn.filereadable(buf_name) == 1
-- end
local function is_valid_buffer(buf)
	local buf_name = vim.api.nvim_buf_get_name(buf)
	local buftype = get_buf_option(buf, "buftype")
	local filetype = get_buf_option(buf, "filetype")
	return buf_name ~= "" and buftype == "" and filetype ~= "" and vim.fn.filereadable(buf_name) == 1
end


-- Inicializa o sistema de cache
function M.setup()
	if vim.fn.isdirectory(cache_dir) == 0 then
		vim.fn.mkdir(cache_dir, "p")
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
	local file = io.open(cache_file, "w")
	if file then
		file:write("return " .. vim.inspect(cache))
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

	if not is_valid_buffer(0) then
		return
	end

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
			name = vim.fn.fnamemodify(buf_name, ":t"),
			path = buf_name,
		})
		M.save_cache(cache)
	end
end

-- Remove o buffer atual do cache
function M.remove_current_buffer_from_cache(force)
	local current_path = M.get_current_path()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local cache = M.load_cache()

	if not cache[current_path] then
		return
	end

	for i, item in ipairs(cache[current_path]) do
		if item.path == buf_name then
			-- Se for o último buffer e não estiver no modo force, mostra aviso
			if #cache[current_path] == 1 and not force then
				vim.notify("Não é possível remover o último buffer do path atual!", vim.log.levels.WARN)
				return false
			end

			table.remove(cache[current_path], i)
			M.save_cache(cache)
			return true
		end
	end
	return false
end

-- Remove o último buffer adicionado do path atual
function M.remove_last_buffer_from_cache()
	local current_path = M.get_current_path()
	local current_buf_name = vim.api.nvim_buf_get_name(0)
	local cache = M.load_cache()

	if not cache[current_path] or #cache[current_path] == 0 then
		vim.notify("Nenhum buffer para remover neste path!", vim.log.levels.WARN)
		return
	end

	-- Verifica se o último buffer é o buffer atual
	local last_buffer = cache[current_path][#cache[current_path]]
	if last_buffer.path == current_buf_name then
		vim.notify("Remoção não sucedida devido o último buffer ser seu buffer atual", vim.log.levels.WARN)
		return
	end

	local buf_to_close = find_buffer_by_path(last_buffer.path)

	-- Remove do cache
	table.remove(cache[current_path])
	M.save_cache(cache)

	-- Fecha o buffer se estiver aberto e não for o atual
	if buf_to_close and buf_to_close ~= vim.api.nvim_get_current_buf() then
		vim.api.nvim_buf_delete(buf_to_close, { force = true })
		vim.notify("Último buffer removido do cache e fechado", vim.log.levels.INFO)
	else
		vim.notify("Último buffer removido do cache", vim.log.levels.INFO)
	end
end

-- Limpa todo o cache exceto o buffer atual
function M.clear_cache()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_path = M.get_current_path()
	local current_buf_name = vim.api.nvim_buf_get_name(current_buf)
	local cache = M.load_cache()

	-- Fecha e remove todos os buffers de outros paths
	for path, buffers in pairs(cache) do
		if path ~= current_path then
			for _, item in ipairs(buffers) do
				local buf = find_buffer_by_path(item.path)
				if buf and buf ~= current_buf then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end
	end

	-- Fecha e salva buffers do path atual (exceto o atual)
	if cache[current_path] then
		for _, item in ipairs(cache[current_path]) do
			local buf = find_buffer_by_path(item.path)
			if buf and buf ~= current_buf then
				-- Salva se tiver modificações
				-- if vim.api.nvim_buf_get_option(buf, "modified") then
				-- 	vim.api.nvim_buf_call(buf, function()
				-- 		vim.cmd("w")
				-- 	end)
				-- end
				if get_buf_option(buf, "modified") then
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("w")
					end)
				end

				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	end

	-- Cria novo cache contendo apenas o buffer atual (se válido)
	local new_cache = {}
	if current_buf_name ~= "" and is_valid_buffer(current_buf) then
		new_cache[current_path] = {
			{
				name = vim.fn.fnamemodify(current_buf_name, ":t"),
				path = current_buf_name,
			},
		}
	end

	-- Salva o novo cache
	M.save_cache(new_cache)

	vim.notify("Cache limpo! Apenas o buffer atual foi mantido.", vim.log.levels.INFO)
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
			is_open = find_buffer_by_path(item.path) ~= nil,
		})
	end

	-- Exibe lista numerada
	vim.ui.select(valid_buffers, {
		prompt = "Buffers:",
		format_item = function(item)
			return string.format("[%d] %s   %s", item.index, item.name, item.path)
		end,
	}, function(choice)
		-- if choice then
		-- 	local buf = find_buffer_by_path(choice.path)
		-- 	if buf then
		-- 		-- Buffer já existe: apenas muda para ele
		-- 		vim.cmd("buffer " .. buf)
		-- 	else
		-- 		-- Buffer não existe: cria e garante que seja listado
		-- 		vim.cmd("silent! badd " .. choice.path)     -- Adiciona à lista de buffers
		-- 		vim.cmd("buffer " .. vim.fn.bufnr(choice.path)) -- Muda para o buffer
		-- 	end
		-- end

		-- Dentro da função M.list_buffers(), modifique o trecho onde o buffer é aberto:
		if choice then
			if is_reusable_unnamed_buffer() then
				-- Reutiliza o buffer '[No Name]'
				vim.api.nvim_buf_set_name(0, choice.path)
				vim.cmd("edit " .. choice.path)
			else
				-- Abre normalmente
				vim.cmd("silent! badd " .. choice.path)
				vim.cmd("buffer " .. vim.fn.bufnr(choice.path))
			end
		end
	end)
end

-- Configura os keymaps
function M.setup_keymaps()
	vim.keymap.set("n", "<leader>ls", M.list_buffers, { desc = "Listar buffers (com cache)" })

	vim.keymap.set("n", "<leader>q", function()
		-- Obter informações do buffer atual
		local buf = vim.api.nvim_get_current_buf()
		local buf_name = vim.api.nvim_buf_get_name(buf)
		local buf_short_name = vim.fn.fnamemodify(buf_name, ":t")

		-- Salvar se houver modificações
		if vim.bo[buf].modified then
			vim.cmd("w")
		end

		-- Obter número do buffer no cache
		local current_path = M.get_current_path()
		local cache = M.load_cache()[current_path] or {}
		local buffer_num = 0

		for i, item in ipairs(cache) do
			if item.path == buf_name then
				buffer_num = i
				break
			end
		end

		-- Remover do cache (com force=true para permitir remover o último)
		local removed = M.remove_current_buffer_from_cache(true)

		-- Fechar buffer
		vim.cmd("bd!")

		-- Notificação
		if buffer_num > 0 then
			vim.notify(
				string.format("Buffer [%d] %s fechado com sucesso!", buffer_num, buf_short_name),
				vim.log.levels.INFO,
				{ title = "Buffer Manager", timeout = 2000 }
			)
		else
			vim.notify(string.format("Buffer %s fechado!", buf_short_name), vim.log.levels.INFO)
		end
	end, { desc = "Salvar, remover do cache e fechar buffer" })

	vim.keymap.set("n", "<leader>r", M.remove_last_buffer_from_cache, { desc = "Remover último buffer do cache" })

	vim.keymap.set("n", "<leader>cc", M.clear_cache, { desc = "Limpar todo o cache de buffers" })
end

for i = 1, 9 do
	vim.keymap.set("n", "<A-" .. i .. ">", function()
		local current_path = M.get_current_path()
		local cache = M.load_cache()
		local buffers = cache[current_path] or {}

		if buffers[i] then
			local buf_path = buffers[i].path

			-- Fecha o Telescope de forma segura
			pcall(function()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
					if ok and vim.api.nvim_buf_is_valid(buf) then
						-- local ft = vim.api.nvim_buf_get_option(buf, "filetype")
						local ft = get_buf_option(buf, "filetype")
						if ft == "TelescopePrompt" then
							pcall(vim.api.nvim_win_close, win, true)
						end
					end
				end
			end)

			if is_reusable_unnamed_buffer() then
				vim.api.nvim_buf_set_name(0, buf_path)
				vim.cmd("edit " .. vim.fn.fnameescape(buf_path))
			else
				-- Verifica se o buffer já existe
				local buf = find_buffer_by_path(buf_path)
				if not buf then
					vim.cmd("silent! badd " .. vim.fn.fnameescape(buf_path))
					buf = vim.fn.bufnr(buf_path)
				end

				-- Alterna para o buffer de forma segura
				if buf and vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_set_current_buf(buf)
				end
			end

			M.add_buffer_to_cache()
		else
			vim.notify("Não há buffer na posição " .. i, vim.log.levels.WARN)
		end
	end, { desc = "Abrir buffer " .. i .. " do cache" })
end

-- Autocomandos para gerenciamento automático
function M.setup_autocmds()
	-- Registrar buffer quando for aberto
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(args)
			local buf = args.buf
			if is_valid_buffer(buf) then
				-- Verifica se foi um buffer aberto manualmente (não por plugin)
				local buf_name = vim.api.nvim_buf_get_name(buf)
				local is_plugin_buffer = false

				-- Lista de padrões de plugins para ignorar
				local ignore_patterns = {
					"neo%-tree",
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
	vim.api.nvim_create_autocmd("DirChanged", {
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
