-- Editor options. Loaded before plugins so nothing overrides them.
local opt = vim.opt

opt.termguicolors = true
opt.mouse = ""
opt.signcolumn = "yes"
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.scrolloff = 8
opt.updatetime = 250
opt.splitright = true
opt.splitbelow = true

vim.cmd.colorscheme("blue")

-- Filetype-specific indentation/display overrides.
local ft_opts = {
  yaml = { shiftwidth = 2, softtabstop = 2, expandtab = true },
  jsonnet = { shiftwidth = 2, softtabstop = 2, expandtab = true },
  c = { shiftwidth = 3, tabstop = 3, expandtab = false, number = true },
  go = { shiftwidth = 4, tabstop = 4, expandtab = false, number = true, colorcolumn = "80,120" },
  markdown = { shiftwidth = 4, tabstop = 4, expandtab = true },
  json = { shiftwidth = 4, tabstop = 4, expandtab = true },
  html = { shiftwidth = 2, tabstop = 2, expandtab = true },
  javascript = { shiftwidth = 2, tabstop = 2, expandtab = true },
  sh = { shiftwidth = 4, tabstop = 4, expandtab = true },
  rust = { shiftwidth = 4, tabstop = 4, number = true, colorcolumn = "80,99" },
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserFiletypeOptions", { clear = true }),
  pattern = vim.tbl_keys(ft_opts),
  callback = function(ev)
    for name, value in pairs(ft_opts[ev.match] or {}) do
      vim.opt_local[name] = value
    end
  end,
})

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
