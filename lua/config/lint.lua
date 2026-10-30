local lint = require("lint")

-- nvim-lint's built-in golangcilint linter handles both golangci-lint v1 and v2.
lint.linters_by_ft = {
  go = { "golangcilint" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
