require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "roslyn_ls" }
vim.lsp.enable(servers)

vim.lsp.config("roslyn_ls", {
  filetypes = { "cs", "razor", "cshtml" },

  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
  },
})
