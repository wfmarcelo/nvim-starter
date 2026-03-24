local M = {}

-- Initial default model
M.current_model = "ollama/qwen2.5-coder:7b"
M.gemini_api_key = nil

function M.setup()
  -- Disable litellm retries to avoid extra requests on 503 errors
  vim.env.LITELLM_MAX_RETRIES = "0"

  -- If it's a Gemini model, ensure the key is in the environment
  if M.current_model:match "^gemini/" then
    local env_key = vim.env.GEMINI_API_KEY
    
    if M.gemini_api_key then
      vim.env.GEMINI_API_KEY = M.gemini_api_key
    elseif env_key and env_key ~= "" then
      M.gemini_api_key = env_key
    else
      M.ask_gemini_key(function()
        M.setup()
      end)
      return
    end
  end

  require("nvim_aider").setup {
    args = {
      "--model",
      M.current_model,
      "--no-auto-commits",
      "--pretty",
      "--stream",
      -- Performance optimizations for large repos and CPU
      "--map-tokens",
      "256",
      "--no-attribute-author",
      "--no-attribute-committer",
    },
    win = {
      style = "nvim_aider",
      position = "right",
    },
  }
end

-- Helper to ask for Gemini API Key
function M.ask_gemini_key(callback)
  vim.ui.input({ prompt = "Enter your GEMINI_API_KEY: ", secret = true }, function(input)
    if input and input ~= "" then
      M.gemini_api_key = input
      vim.env.GEMINI_API_KEY = input
      if callback then
        callback()
      end
    else
      vim.notify("Gemini API Key is required for this model.", vim.log.levels.ERROR)
    end
  end)
end

-- Function to change the model
function M.change_model()
  local models = {
    -- Nomes EXTRAÍDOS DIRETAMENTE do seu CURL (models/ removido)
    "gemini/gemini-3.1-flash-lite-preview", -- O de 500 RPD
    "gemini/gemini-3-flash-preview", -- O de 20 RPD
    "gemini/gemini-2.5-flash", -- O estável de 20 RPD
    "gemini/gemini-2.0-flash", -- Verifique se este funciona (Unlimited?)
    "gemini/gemini-flash-lite-latest",
    "OTHER (Type custom model name)",
  }

  -- Try to get Ollama models
  local handle = io.popen "ollama list | awk '{if(NR>1) print $1}'"
  if handle then
    local result = handle:read "*a"
    handle:close()
    for model in result:gmatch "[^\r\n]+" do
      table.insert(models, "ollama/" .. model)
    end
  end

  -- Use picker to select
  vim.ui.select(models, {
    prompt = "Select Aider Model (VERIFIED NAMES):",
    format_item = function(item)
      if item:match "3.1-flash-lite-preview" then return "󰚩 " .. item .. " (500 RPD - USE ESTE)" end
      if item:match "3-flash-preview" then return "  " .. item .. " (20 RPD)" end
      if item:match "^gemini/" then return "  " .. item end
      if item:match "^ollama/" then return "󱚣 " .. item end
      return "✎  " .. item
    end,
  }, function(choice)
    if not choice then return end

    if choice == "OTHER (Type custom model name)" then
      vim.ui.input({ prompt = "Enter model name (from your curl list): " }, function(input)
        if input and input ~= "" then
          M.apply_model(input)
        end
      end)
    else
      -- Limpa a descrição extra da string de escolha
      local actual_model = choice:match("^([^ ]+)")
      M.apply_model(actual_model)
    end
  end)
end

function M.apply_model(choice)
  M.current_model = choice
  local has_key = (M.gemini_api_key ~= nil) or (vim.env.GEMINI_API_KEY ~= nil and vim.env.GEMINI_API_KEY ~= "")
  
  if choice:match "^gemini/" and not has_key then
    M.ask_gemini_key(function()
      M.setup()
      vim.notify("Aider configured to: " .. choice, vim.log.levels.INFO)
    end)
  else
    M.setup()
    vim.notify("Aider configured to: " .. choice, vim.log.levels.INFO)
  end
  vim.notify("Restart Aider (<leader>aR) to apply the new model.", vim.log.levels.WARN)
end

return M
