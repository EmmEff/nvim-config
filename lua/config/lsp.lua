-- LSP servers. All require the corresponding binary on PATH.

-- Requires `gopls`.
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})
vim.lsp.enable("gopls")

-- Requires `rust-analyzer`.
vim.lsp.config("rust_analyzer", {
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
vim.lsp.enable("rust_analyzer")

-- Requires `yaml-language-server`.
vim.lsp.enable("yamlls")

-- Neovim 0.11+ already provides gd, K, grn, gra, grr, gri, grt and gO,
-- so only the custom mappings are added here.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(ev)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end

    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cI", vim.lsp.buf.incoming_calls, "Incoming calls")
  end,
})
