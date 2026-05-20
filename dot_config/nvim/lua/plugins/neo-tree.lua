return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>n",
      "<cmd>Neotree toggle=true<CR>",
      desc = "Toggle NeoTree",
    },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = false,
        show_hidden_count = true,
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_by_name = {
          ".gitignore",
        },
        never_show = {
          ".git",
        },
      },
    },
  },
}
