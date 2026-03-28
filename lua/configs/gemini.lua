local M = {}

M.models = {
  "gemini/gemini-3.1-flash-lite-preview",
  "gemini/gemini-3-flash-preview",
  "gemini/gemini-2.5-flash",
  "gemini/gemini-2.0-flash",
  "gemini/gemini-flash-lite-latest",
}

M.current_model = M.models[1]

function M.change_model()
  vim.ui.select(M.models, {
    prompt = "Select Gemini Model:",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice)
    if choice then
      M.current_model = choice
      vim.notify("Gemini model changed to: " .. choice, vim.log.levels.INFO)
      -- Definimos como variável global para o gemini-cli.nvim possivelmente ler
      vim.g.gemini_model = choice
    end
  end)
end

function M.setup()
  -- Configuração inicial
end

return M
