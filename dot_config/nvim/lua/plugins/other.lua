return {
  "rgroli/other.nvim",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>a", "<Cmd>Other<CR>", {
      silent = true,
      desc = "Open other file picker",
    })

    require("other-nvim").setup({
      mappings = {
        -- builtin mappings
        "rails",
        -- custom mapping for spec to source file
        {
          pattern = "(.+)/spec/(.*)/(.*)/(.*)_spec.rb",
          target = {
            { context = "source", target = "%1/db/%3/%4.rb" },
            { context = "source", target = "%1/app/%3/%4.rb" },
            { context = "source", target = "%1/%3/%4.rb" },
          },
        },
        {
          pattern = "(.+)/spec/(.*)/(.*)_spec.rb",
          target = {
            { context = "source", target = "%1/db/%2/%3.rb" },
            { context = "source", target = "%1/app/%2/%3.rb" },
            { context = "source", target = "%1/lib/%2/%3.rb" },
          },
        },
        {
          pattern = "(.+)/spec/(.*)/(.*)_(.*)_spec.rb",
          target = {
            { context = "source", target = "%1/app/%4s/%3_%4.rb" },
          },
        },
        -- custom mapping for Python test files
        {
          pattern = "(.+)/tests/test_(.*).py",
          target = "%1/%2.py",
          context = "source",
        },
        {
          pattern = "(.+)/([^/]+).py",
          target = "%1/tests/test_%2.py",
          context = "test",
        },
        -- custom mapping for source.ts to source.spec.ts and vice versa
        {
          pattern = "(.*).spec.ts$",
          target = "%1.ts",
          context = "source",
        },
        {
          pattern = "(.*).ts$",
          target = "%1.spec.ts",
          context = "spec",
        },
        -- custom mapping for source.tsx to source.stories.tsx and vice versa
        -- {
        --   pattern = "(.*).stories.tsx$",
        --   target = "%1.tsx",
        --   context = "source",
        -- },
        -- {
        --   pattern = "(.*).tsx$",
        --   target = "%1.stories.tsx",
        --   context = "spec",
        -- },
        -- custom mapping for source.tsx to source.spec.tsx and vice versa
        {

          pattern = "(.*).spec.tsx$",
          target = "%1.tsx",
          context = "source",
        },
        {

          pattern = "(.*).tsx$",
          target = "%1.spec.tsx",
          context = "source",
        },
        -- custom mapping for source.stories.tsx to source.spec.tsx and vice versa
        {

          pattern = "(.*).spec.tsx$",
          target = "%1.stories.tsx",
          context = "source",
        },
        {

          pattern = "(.*).stories.tsx$",
          target = "%1.spec.tsx",
          context = "source",
        },
      },

      showMissingFiles = false,
      rememberBuffers = false,

      style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = "solid",

        -- Column seperator for the window
        seperator = "|",

        -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
        width = 0.7,

        -- min height in rows.
        -- when more columns are needed this value is extended automatically
        minHeight = 2,
      },
    })
  end,
}
