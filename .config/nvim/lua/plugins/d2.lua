return {
  "terrastruct/d2-vim",
  ft = { "d2" },
  dependencies = {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          d2 = { "d2" },
        },
      },
    },
  },
}
