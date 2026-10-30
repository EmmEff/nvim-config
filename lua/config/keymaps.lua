local builtin = require("telescope.builtin")
local map = vim.keymap.set

map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fl", builtin.lsp_document_symbols, { desc = "Document symbols" })
map("n", "<leader>fL", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>fr", builtin.lsp_references, { desc = "References" })

map("n", "<C-g>", require("nvim-tree.api").tree.toggle, { desc = "Toggle nvim-tree", silent = true })
map("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial" })
