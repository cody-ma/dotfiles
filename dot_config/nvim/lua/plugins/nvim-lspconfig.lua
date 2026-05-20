return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "gd",
        "<cmd>tab split | lua vim.lsp.buf.definition()<CR>",
        desc = "Goto definition in new tab",
      },
      {
        "gt",
        "<cmd>tab split | lua vim.lsp.buf.definition()<CR>",
        desc = "Goto definition in new tab",
      },
      {
        "ge",
        "<cmd>lua vim.lsp.buf.definition()<CR>",
        desc = "Goto definition in current window",
      },
      {
        "gv",
        "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>",
        desc = "Goto definition in vsplit",
      },
    },
    opts = {
      -- Useful for debugging formatter issues
      format_notify = false,
      inlay_hints = {
        enabled = false,
      },
      -- Disable autostart for all LSP servers
      setup = {
        ["*"] = function(server, opts)
          opts.autostart = false
          return false
        end,
        -- Completely skip these servers
        eslint = function()
          return true
        end,
        ts_ls = function()
          return true
        end,
        vtsls = function()
          return true
        end,
      },
      servers = {
        bashls = {
          autostart = false,
          filetypes = { "sh", "zsh" },
        },
        denols = { autostart = false },
        diagnosticls = { autostart = false },
        dockerls = { autostart = false },
        helm_ls = { autostart = false },
        lua_ls = {
          autostart = false,
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        marksman = { autostart = false },
        pyright = { autostart = false },
        ruby_lsp = {
          autostart = false,
          mason = false,
          cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
          filetypes = { "ruby", "eruby" },
          root_markers = { "Gemfile", ".git" },
          init_options = {
            formatter = "rubocop",
            linters = { "rubocop" },
          },
        },
        sqlls = { autostart = false },
        terraformls = { autostart = false },
        yamlls = { autostart = false },
      },
    },
  },
}
