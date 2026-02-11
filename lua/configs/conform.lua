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
      -- Adiciona os argumentos para o executável
      prepend_args = { "-c", '{"language": "tsql", "keywordCase": "upper"}' },
    },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
