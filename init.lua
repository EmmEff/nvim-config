-- Editor options must be set before plugins load.
require("config.options")

-- Disable netrw in favour of nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")

require("config.keymaps")
require("config.lsp")
require("config.lint")
require("config.autocmds")
