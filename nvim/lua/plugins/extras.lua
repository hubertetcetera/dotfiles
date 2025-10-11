return {
  -- multiple cursors
  { "mg979/vim-visual-multi" },

  -- predictive motion / code navigation
  {
    "tris203/precognition.nvim",
    config = function()
      require("precognition").setup()
    end,
  },
}
