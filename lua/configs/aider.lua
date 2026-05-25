local M = {}

-- Initial default model and state
M.current_model = "gemini/gemini-3.1-flash-lite"
M.gemini_api_key = nil
M.lite_mode = false -- New: State for Lite Mode

-- Cache GPU detection
local has_gpu = nil
local function check_gpu()
  if has_gpu == nil then
    local handle = io.popen "command -v nvidia-smi > /dev/null 2>&1 && nvidia-smi -L 2>/dev/null"
    if handle then
      local result = handle:read "*a"
      handle:close()
      has_gpu = (result ~= "")
    else
      has_gpu = false
    end
  end
  return has_gpu
end

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

  local is_gpu = check_gpu()

  local args = {
    "--model",
    M.current_model,
    "--no-auto-commits",
    "--pretty",
    "--stream",
  }

  -- If it's a Gemini model, enable prompt caching
  if M.current_model:match "^gemini/" then
    table.insert(args, "--cache-prompts")
  end

  -- LITE MODE / GPU OPTIMIZATION LOGIC
  if M.lite_mode then
    -- Ultra-light: No repo map, no extra analysis
    table.insert(args, "--map-tokens")
    table.insert(args, "0")
    table.insert(args, "--no-suggest-shell-commands")
  elseif not is_gpu then
    -- Standard CPU optimization
    table.insert(args, "--map-tokens")
    table.insert(args, "256")
    table.insert(args, "--no-attribute-author")
    table.insert(args, "--no-attribute-committer")
  else
    -- High-performance settings for GPU
    table.insert(args, "--map-tokens")
    table.insert(args, "1024")
  end

  require("nvim_aider").setup {
    args = args,
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

-- Function to toggle Lite Mode
function M.toggle_lite_mode()
  M.lite_mode = not M.lite_mode
  local status = M.lite_mode and "ENABLED (Map Tokens: 0)" or "DISABLED"
  
  -- Apply changes
  M.setup()
  
  vim.notify("Aider Lite Mode: " .. status, vim.log.levels.INFO)
  vim.notify("Restart Aider (<leader>aR) to apply changes.", vim.log.levels.WARN)
end

-- Function to change the model
function M.change_model()
  local models = {
    "gemini/gemini-3.5-flash",
    "gemini/gemini-3.1-flash-lite",
    "gemini/gemini-2.5-flash",
    "gemini/gemini-2.5-flash",
    "gemini/gemini-2.0-flash",
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
    prompt = "Select Aider Model:",
    format_item = function(item)
      if item:match "3.1-flash-lite-preview" then return "󰚩 " .. item .. " (500 RPD - USE ESTE)" end
      if item:match "^gemini/" then return "  " .. item end
      if item:match "^ollama/" then return "󱚣 " .. item end
      return "✎  " .. item
    end,
  }, function(choice)
    if not choice then return end

    if choice == "OTHER (Type custom model name)" then
      vim.ui.input({ prompt = "Enter model name: " }, function(input)
        if input and input ~= "" then
          M.apply_model(input)
        end
      end)
    else
      local actual_model = choice:match("^([^ ]+)")
      M.apply_model(actual_model)
    end
  end)
end

function M.apply_model(choice)
  M.current_model = choice
  M.setup()
  vim.notify("Aider configured to: " .. choice, vim.log.levels.INFO)
  vim.notify("Restart Aider (<leader>aR) to apply the new model.", vim.log.levels.WARN)
end

return M
