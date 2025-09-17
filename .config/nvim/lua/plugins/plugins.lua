return {
  -- editor
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            "tree-sitter-cli",
          },
        },
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            "ast-grep",
          },
        },
      },
    },
  },

  -- colorscheme
  { "EdenEast/nightfox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nordfox",
    },
  },

  -- language customizations and extra plugins
  -- d2
  {
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
  },

  -- go
  {
    "nvim-neotest/neotest",
    dependencies = {
      {
        "fredrikaverpil/neotest-golang",
        dependencies = {
          {
            "andythigpen/nvim-coverage", -- Added dependency
            opts = {
              auto_reload = true,
            },
          },
        },
      },
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          -- Here we can set options for neotest-golang, e.g.
          go_test_args = {
            "-v",
            "-race",
            "-count=1",
            "-timeout=60s",
            "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
          },
          dap_go_enabled = true, -- requires leoluz/nvim-dap-go
        },
      },
    },
  },

  -- html
  {
    "stevearc/conform.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            "prettier",
          },
        },
      },
    },
    opts = {
      formatters_by_ft = {
        html = { "prettier" },
      },
    },
  },

  -- markdown
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

  -- trim whitespace
  {
    "cappyzawa/trim.nvim",
    opts = {},
  },
}
