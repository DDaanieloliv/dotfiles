return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim"
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown()
          }
        }
      })

      -- Carrega extensões
      telescope.load_extension("file_browser")
      telescope.load_extension("ui-select")

      -- Mapeamentos
      vim.keymap.set("n", "<leader>pp", function()
        builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
      end, { desc = "Buscar arquivos na pasta atual" })

      -- vim.keymap.set("n", "<leader>bh", function()
      --   telescope.extensions.file_browser.file_browser({
      --     path = vim.fn.expand("%:p:h"),
      --     hidden = true,
      --     no_ignore = true
      --   })
      -- end, { desc = "Abrir navegador de arquivos" })

      vim.keymap.set("n", "<leader>bs", function()
        local path = vim.fn.expand("%:p:h:h") -- sobe duas pastas
        require("telescope.builtin").grep_string({
          search = vim.fn.input("Grep > "),
          cwd = path,
        })
      end, { desc = "Grep na pasta 2 níveis acima" })

      vim.keymap.set("n", "<leader>bh", function()
        telescope.extensions.file_browser.file_browser({
          path = vim.fn.expand("%:p:h"),
          select_buffer = true,
          hidden = true,  -- Mostra arquivos ocultos
          no_ignore = true, -- Ignora arquivos não-ocultos (mostra SÓ os ocultos)
        })
      end, { desc = "Abrir navegador de arquivos (somente ocultos)" })



    end
  }
}
