return {
  "ibhagwan/fzf-lua",
  opts = function()
    local fzf = require("fzf-lua")
    local config = fzf.config
    local actions = fzf.actions

    config.defaults.actions.files["ctrl-t"] = actions.file_tabedit
    config.defaults.winopts = vim.tbl_deep_extend("force", config.defaults.winopts or {}, {
      preview = {
        layout = "vertical",
        vertical = "down:60%",
      },
    })
  end,
}
