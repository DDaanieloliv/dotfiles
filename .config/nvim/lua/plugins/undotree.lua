return {

  -- ###############################
  -- ##                           ##
  -- ## Plugin about UndoTree.    ##
  -- ##                           ##
  -- ###############################

  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  }


}
