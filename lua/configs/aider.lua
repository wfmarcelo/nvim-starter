local M = {}

-- Initial default model
M.current_model = "ollama/qwen2.5-coder:7b"

function M.setup()
  require("nvim_aider").setup {
    args = {
      "--model",
      M.current_model,
      "--no-auto-commits",
      "--pretty",
      "--stream",
    },
    win = {
      style = "nvim_aider",
      position = "right",
    },
  }
end

-- Function to change the model
function M.change_model()
  -- Try to get the list of Ollama models
  local handle = io.popen "ollama list | awk '{if(NR>1) print $1}'"
  if not handle then
    vim.notify("Could not list Ollama models", vim.log.levels.ERROR)
    return
  end

  local result = handle:read "*a"
  handle:close()

  local models = {}
  for model in result:gmatch "[^\r\n]+" do
    table.insert(models, "ollama/" .. model)
  end

  -- If no Ollama models are found, offer a basic manual list or inform the user
  if #models == 0 then
    models = { "gpt-4o", "gpt-4-turbo", "claude-3-5-sonnet-20240620" }
    vim.notify("No Ollama models found. Showing common cloud models instead.", vim.log.levels.WARN)
  end

  -- Use vim.ui.select (which usually uses Snacks or Telescope if configured)
  vim.ui.select(models, {
    prompt = "Select Aider Model:",
    format_item = function(item)
      return "󱚣 " .. item
    end,
  }, function(choice)
    if choice then
      M.current_model = choice
      -- Reconfigure aider with the new model
      M.setup()
      vim.notify("Aider configured to: " .. choice, vim.log.levels.INFO)
      
      -- Notify that Aider needs to be restarted if already running
      vim.notify("Restart Aider (<leader>aR) to apply the new model.", vim.log.levels.WARN)
    end
  end)
end

return M
