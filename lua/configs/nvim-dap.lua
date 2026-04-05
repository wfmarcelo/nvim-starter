local dap = require "dap"

local mason_path = vim.fn.stdpath "data" .. "/mason/packages/netcoredbg/netcoredbg"

local netcoredbg_adapter = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return coroutine.create(function(dap_run_co)
        print "Building project..."
        vim.fn.jobstart("dotnet build -c Debug", {
          on_exit = function(_, code)
            if code == 0 then
              print "Build successful! Starting debugger..."
              local dll_path = require("dap-dll-autopicker").build_dll_path()
              coroutine.resume(dap_run_co, dll_path)
            else
              print "Build failed!"
              coroutine.resume(dap_run_co, nil)
            end
          end,
        })
      end)
    end,
  },
  {
    type = "coreclr",
    name = "attach - netcoredbg",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}

-- Replicate C# configurations for Razor files
dap.configurations.razor = dap.configurations.cs
dap.configurations.cshtml = dap.configurations.cs
dap.configurations.aspnetcorerazor = dap.configurations.cs

