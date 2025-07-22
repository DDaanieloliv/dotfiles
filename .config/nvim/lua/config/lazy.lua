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
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})


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

