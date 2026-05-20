return {
  {
    "mason-org/mason.nvim",
    keys = {
      { "<leader>cm", false },
    },
    opts = {
      ensure_installed = {
        "bash-language-server",
        "deno",
        "diagnostic-languageserver",
        "dockerfile-language-server",
        "hadolint",
        "helm-ls",
        "json-lsp",
        "jsonnet-language-server",
        "lua-language-server",
        "marksman",
        "shellcheck",
        "shfmt",
        "sqlls",
        "stylua",
        "terraform-ls",
        "tflint",
        "typescript-language-server",
        "yaml-language-server",
      },
    },
  },
}
