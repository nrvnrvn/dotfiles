return {
  {
    "whitestarrain/md-section-number.nvim",
    ft = "markdown",
    opts = {
      min_level = 2,
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdown-toc"] = {
          prepend_args = {
            "--bullets",
            "-",
          },
        },
      },
    },
  },
}
