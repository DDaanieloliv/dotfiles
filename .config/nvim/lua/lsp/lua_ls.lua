return {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Para NixOS, adicione caminhos específicos se necessário
        }
      },
      diagnostics = {
        globals = { 'vim' },
        neededFileStatus = {
          ["codestyle-check"] = "Any"
        }
      },
      telemetry = { enable = false },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2"
        }
      }
    }
  }
}
