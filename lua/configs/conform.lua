local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_format" },
    css = { "prettier" },
    html = { "prettier" },
    cs = { "csharpier" },
    sql = { "sql_formatter" },
    json = { "jq" },
  },
  formatters = {
    sql_formatter = {
      prepend_args = { "-c", '{"language": "tsql", "keywordCase": "UPPER"}' },
    },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options