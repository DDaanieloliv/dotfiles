return {

  -- #################################
  -- ##                             ##
  -- ## Plugin about Commentstring. ##
  -- ##                             ##
  -- #################################

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
  },

  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  }
}
