local options = {
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
  ensure_installed = {
    "lua-language-server",

    "xmlformatter",
    "csharpier",
    "prettier",

    "stylua",
    "bicep-lsp",
    "html-lsp",
    "css-lsp",
    "eslint-lsp",
    "typescript-language-server",
    "json-lsp",
    "rust-analyzer",

    "jq",
    "ruff",
    "sql-formatter",
    "netcoredbg",
    "ripgrep",
    "fd",

    -- !
    "roslyn",
    "razor",
  },
}

return options
