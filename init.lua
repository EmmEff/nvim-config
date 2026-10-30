require("config.lazy")

require'nvim-treesitter'.install {'rust', 'go', 'toml', 'yaml', 'terraform'}

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

vim.cmd("colorscheme blue")

vim.opt.mouse = ""

-- vim.opt.colorcolumn = "80,120"

-- Keymaps when LSP attaches
local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, silent = true, noremap = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    --vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    vim.keymap.set('n', '<C-]>',  vim.lsp.buf.definition, opts)
end

--- vim.lsp.enalble('bashls')

vim.lsp.enable('yamlls')

vim.lsp.config('yaml', {
	on_attach = on_attach,
})

vim.lsp.enable('gopls')

-- Setup Go LSP
vim.lsp.config('gopls', {
    on_attach = on_attach,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true, -- Example: Also enable constant value hints
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            -- analyses = { unusedparams = true },
            -- staticcheck = true,
	    -- buildFlags = { "-tags=e2e,integration" },
        },
    },
})

-- vim.lsp.config('rust_analyzer', {
--   on_attach = on_attach,
--   settings = {
--     ["rust-analyzer"] = {
--       cargo = { allFeatures = true },
--       checkOnSave = true,
--     },
--   },
-- })

vim.lsp.config("rust_analyzer", {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      workspace = {
        symbol = {
          search = {
            scope = "workspace", -- prevents dependency symbols
          },
        },
      },
      cargo = {
        allFeatures = false,
      },
      check = {
        allTargets = false,
      },
      checkOnSave = true,
    },
  },
})

vim.lsp.enable('rust_analyzer')

-- Auto-format Go on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

local create_autocmd = vim.api.nvim_create_autocmd

-- Helper to avoid repetition
local function set_ft_opts(ft, opts)
  create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      for opt, val in pairs(opts) do
        vim.opt_local[opt] = val
      end
    end,
  })
end

-- Now define your filetype-specific settings
set_ft_opts("yaml",       { shiftwidth = 2, softtabstop = 2, expandtab = true })
set_ft_opts("jsonnet",    { shiftwidth = 2, softtabstop = 2, expandtab = true })
set_ft_opts("c",          { shiftwidth = 3, tabstop = 3, expandtab = false, number = true })
set_ft_opts("go",         { shiftwidth = 4, tabstop = 4, expandtab = false, number = true, colorcolumn = "80,120" })
set_ft_opts("markdown",   { shiftwidth = 4, tabstop = 4, expandtab = true })
set_ft_opts("json",       { shiftwidth = 4, tabstop = 4, expandtab = true })
set_ft_opts("html",       { shiftwidth = 2, tabstop = 2, expandtab = true })
set_ft_opts("javascript", { shiftwidth = 2, tabstop = 2, expandtab = true })
set_ft_opts("sh",         { shiftwidth = 4, tabstop = 4, expandtab = true })
set_ft_opts("rust",       { shiftwidth = 4, tabstop = 4, number = true, colorcolumn = "80,99" })

require("lint").linters_by_ft = {
    go = { "golangcilint" },
}

require("lint").linters.golangcilint = {
    cmd = "golangci-lint",
    stdin = false,
    args = { "run", "--out-format", "json" },
    stream = "stdout",
    ignore_exitcode = true,
    parser = function(output)
      local ok, decoded = pcall(vim.json.decode, table.concat(output, "\n"))
      if not ok or not decoded.Issues then
        return {}
      end
      local diagnostics = {}
      for _, issue in ipairs(decoded.Issues) do
        table.insert(diagnostics, {
          lnum = issue.Pos.Line - 1,
          col = issue.Pos.Column - 1,
          message = issue.Text,
          source = issue.FromLinter,
          severity = vim.diagnostic.severity.WARN,
        })
      end
       return diagnostics
    end,
}

-- Run linter on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",  -- Could be "■", "▎", "x"
        spacing = 2,   -- Space between text and diagnostic
    },
    signs = true,      -- Show signs in gutter
    underline = true,  -- Underline the problem text
    update_in_insert = false, -- Don't update while typing
    severity_sort = true, -- Sort by severity
})


vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local last_pos = vim.fn.line([['"]])
        if last_pos > 0 and last_pos <= vim.fn.line("$") then
            vim.cmd('normal! g`"')
        end
    end,
})


local builtin = require("telescope.builtin")
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)     -- Find files
vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)      -- Search text in project
vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)        -- List open buffers
vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)      -- Search help tags
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, opts)    -- Show diagnostics
vim.keymap.set("n", "<leader>fl", builtin.lsp_document_symbols, opts) -- Symbols in current file
vim.keymap.set("n", "<leader>fL", builtin.lsp_dynamic_workspace_symbols, opts) -- Symbols in workspace

vim.keymap.set("n", "gI", vim.lsp.buf.incoming_calls, { desc = "LSP incoming calls" })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function()
    vim.cmd([[Trouble qflist open]])
  end,
})

local api = require("nvim-tree.api")

vim.keymap.set("n", "<C-g>", api.tree.toggle, {
  desc = "Toggle nvim-tree",
  silent = true,
})

require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- Add an autocmd in your init.lua to format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspFormatting", {}),
  pattern = "*.rs", -- Apply to Rust files
  callback = function()
    -- Check if an LSP client supporting formatting is attached
    if vim.lsp.buf.format then
      vim.lsp.buf.format({ async = false })
    end
  end,
})
