-- oxlint + oxfmt via conform.nvim (replaces prettier for JS/TS)
-- Both binaries are resolved from node_modules/.bin/ automatically.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      local js_ts = { "oxfmt", "oxlint" }
      opts.formatters_by_ft["javascript"] = js_ts
      opts.formatters_by_ft["javascriptreact"] = js_ts
      opts.formatters_by_ft["typescript"] = js_ts
      opts.formatters_by_ft["typescriptreact"] = js_ts

      -- Disable prettier so it doesn't run alongside oxfmt
      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = { condition = function() return false end }
      opts.formatters.prettierd = { condition = function() return false end }

      -- Help conform find oxfmt from node_modules by anchoring cwd to project root
      local util = require("conform.util")
      opts.formatters.oxfmt = {
        cwd = util.root_file({ ".oxfmtrc.json", "package.json" }),
      }
    end,
  },
}
