require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set

map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory in Oil" })

-- 1. Habit Builders
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- 2. Window Management (Essential for .NET Debugging)
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })

-- 3. SQL / Dadbod Autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    -- Map F5 to execute query in Normal, Insert, and Visual modes
    map("n", "<F5>", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute Query" })
    map("i", "<F5>", "<C-o><Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute Query" })
    map("v", "<F5>", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute Selection" })

    vim.opt_local.ignorecase = true
  end,
})

-- 1. nvim-dap (F-keys style for Visual Studio fans)
map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Debug: Start/Continue" })
map("n", "<C-F5>", function()
  require("dap").continue { terminate_on_interrupt = true }
end, { desc = "Run/Continue" })
map("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over" })
map("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })
map("n", "<F8>", function()
  require("dap").step_out()
end, { desc = "Debug: Step Out" })

-- 2. Debugger Utilities (Leader style)
map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "Debug: Open REPL" })
map("n", "<leader>dl", function()
  require("dap").run_last()
end, { desc = "Debug: Run Last" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })

-- 3. Neotest (Testing Workflow)
-- <F6> for quick "Debug Nearest Test" is a great addition
map("n", "<F6>", function()
  require("neotest").run.run { strategy = "dap" }
end, { desc = "Test: Debug Nearest" })

map("n", "<leader>rt", function()
  require("neotest").run.run()
end, { desc = "Test: Run Nearest" })
map("n", "<leader>rf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Test: Run File" })
map("n", "<leader>rs", function()
  require("neotest").summary.toggle()
end, { desc = "Test: Toggle Summary" })

-- PlantUML Preview
map("n", "<leader>pv", "<cmd>PlantumlOpen<cr>", { desc = "PlantUML Preview" })
map("n", "<leader>px", function()
  -- 1. Ensure current changes are saved
  vim.cmd "silent write"

  -- 2. Ask the user for the destination path
  local default_path = vim.fn.expand "%:p:r" .. ".png"

  vim.ui.input({
    prompt = "Save PNG to: ",
    default = default_path,
    completion = "file",
  }, function(input)
    if input == nil or input == "" then
      print "Export cancelled"
      return
    end

    -- 3. Run PlantUML to export to the chosen path
    -- We use 'shellescape' to handle spaces in the path safely
    local cmd = string.format("plantuml '%s' -o '%s'", vim.fn.expand "%:p", vim.fn.fnamemodify(input, ":h"))

    -- Rename if the filename chosen is different from the default
    local target_file = vim.fn.fnamemodify(input, ":t")

    vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        if code == 0 then
          print("Diagram saved to: " .. input)
        else
          print "Error saving diagram"
        end
      end,
    })
  end)
end, { desc = "PlantUML: Export to custom path" })
