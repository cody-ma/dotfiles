vim.g.mapleader = ","
-- material, mix, original
vim.g.gruvbox_material_foreground = "original"
-- hard, medium, soft
vim.g.gruvbox_material_background = "medium"
vim.g.autoformat = true
vim.g.snacks_animate = false

vim.opt.relativenumber = false
vim.opt.swapfile = false

-- fold options
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- always replace all
vim.opt.gdefault = true

-- git blame configuration
vim.g.gitblame_message_template = "  <author>, <date> • <summary>"
vim.g.gitblame_date_format = "%r"

-- window title
vim.opt.title = true
vim.opt.titlestring = "%t"
