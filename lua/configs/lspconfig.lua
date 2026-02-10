require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "roslyn" }
vim.lsp.enable(servers)

vim.filetype.add({
  extension = {
    cshtml = "razor",
    razor = "razor",
  },
})

