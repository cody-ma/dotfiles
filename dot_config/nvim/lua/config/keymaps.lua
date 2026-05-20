local map = vim.keymap

map.set("n", ";", ":")
map.set("n", ":", ";")
map.set("n", "0", "^")
map.set("i", "jj", "<Esc>")

map.set("n", "<leader>v", ":vsp ")
map.set("n", "<leader>cp", ":let @+=expand('%:.')<CR>")
map.set("n", "<C-p>", ":lua require('fzf-lua').files()<CR>")

vim.cmd([[
  cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
  cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
  cnoreabbrev <expr> WQ ((getcmdtype() is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
  cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
  cnoreabbrev <expr> ag ('Rg')
  cnoreabbrev <expr> rg ('Rg')
  cnoreabbrev <expr> AV ((getcmdtype() is# ':' && getcmdline() is# 'AV')?('OtherVSplit'):('AV'))
  cnoreabbrev <expr> AT ((getcmdtype() is# ':' && getcmdline() is# 'AT')?('OtherTabNew'):('AT'))
]])

vim.keymap.del("i", "<Tab>")
