require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "roslyn" }
vim.lsp.enable(servers)

