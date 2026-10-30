local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Restore the last cursor position, except for commit messages.
autocmd("BufReadPost", {
  group = augroup("UserLastPosition", { clear = true }),
  callback = function()
    local mark = vim.fn.line([['"]])
    if mark > 1 and mark <= vim.fn.line("$") and vim.bo.filetype ~= "gitcommit" then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Show quickfix results in Trouble, but only when the list is not empty.
autocmd("QuickFixCmdPost", {
  group = augroup("UserQuickfix", { clear = true }),
  pattern = { "grep", "make" },
  callback = function()
    if #vim.fn.getqflist() > 0 then
      vim.cmd("Trouble qflist open")
    end
  end,
})
