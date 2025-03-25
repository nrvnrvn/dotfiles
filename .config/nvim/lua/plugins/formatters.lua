return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ast-grep",
        "prettier",
        "shfmt",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        html = { "prettier" },
      },
    },
  },
}
