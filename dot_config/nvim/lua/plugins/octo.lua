return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    -- 'nvim-telescope/telescope.nvim',
    -- OR 'folke/snacks.nvim',
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      picker = "fzf-lua",
    })
  end,
}
