return {
  "MagicDuck/grug-far.nvim",
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "ast-grep",
        },
      },
    },
  },
}
