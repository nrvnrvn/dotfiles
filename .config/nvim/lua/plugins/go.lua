return {
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
}
