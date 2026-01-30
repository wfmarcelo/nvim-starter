local dapui = require "dapui"
local dap = require "dap"

--- open ui immediately when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
-- https://emojipedia.org/en/stickers/search?q=circle
vim.fn.sign_define("DapBreakpoint", {
  text = "⚪",
  texthl = "DapBreakpointSymbol",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})

vim.fn.sign_define("DapStopped", {
  text = "🔴",
  texthl = "yellow",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "⭕",
  texthl = "DapStoppedSymbol",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
-- default configuration
dapui.setup {
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  element_mappings = {},
  expand_lines = true,
  force_buffers = true,
  controls = {
    enabled = true,
    element = "repl", -- Added missing 'element'
    icons = { -- Added missing 'icons'
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  }, -- no extra play/step buttons
 floating = {
    border = "rounded",
    max_height = nil,
    max_width = nil,
    mappings = { close = { "q", "<Esc>" } }, -- Added missing 'mappings'
  },
  -- Set dapui window
  render = {
    max_type_length = 60,
    max_value_lines = 200,
    indent = 1, -- Added missing 'indent'
  },
  -- Only one layout: just the "scopes" (variables) list at the bottom
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.75 }, -- 100% of this panel is scopes
        { id = "repl", size = 0.25 }, -- 100% of this panel is scopes
      },
      size = 15, -- height in lines (adjust to taste)
      position = "bottom", -- "left", "right", "top", "bottom"
    },
  },
}
