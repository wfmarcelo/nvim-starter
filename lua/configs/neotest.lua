local neotest = require "neotest"

neotest.setup {
  adapters = {
    require "neotest-dotnet" {
      dap = { adapter_name = "netcoredbg" },
    },
  },
  log_level = vim.log.levels.WARN,
  consumers = {},
  icons = { passed = "✔", running = "↻", failed = "✖", unknown = "?" },
  highlights = { adapter_name = "NeotestAdapterName" },
  floating = { border = "rounded", max_height = 0.6, max_width = 0.6, options = {} },
  strategies = {
    integrated = { width = 120 },
  },
  summary = {
    enabled = true,
    animated = true,
    follow = true,
    expand_errors = true,
    count = true, -- Clears count warning
    open = "botright vsplit | vertical resize 50",
    mappings = {
      expand = { "<CR>", "+", "zR" },
      expand_all = "e",
      output = "o",
      short = "i",
      attach = "a",
      jumpto = "i",
      stop = "u",
      run = "r",
      debug = "d",
      mark = "m",
      run_marked = "R",
      clear_marked = "M",
      target = "t",
      clear_target = "T",
      debug_marked = "D",
      next_failed = "j",
      prev_failed = "k",
      next_sibling = "]",
      prev_sibling = "[",
      parent = "p", -- Added missing
      watch = "w", -- Added missing
    },
  },
  -- Final top-level fields for full type compliance
  projects = {},
  discovery = { enabled = true, concurrent = 0 }, -- Clears concurrent warning
  running = { enabled = true, concurrent = false }, -- Clears concurrent warning
  default_strategy = "integrated",
  run = { enabled = true },
  output = { enabled = true, open_on_run = "short" },
  output_panel = { enabled = true, open = "botright split | resize 15" },
  quickfix = { enabled = true, open = false },
  status = { enabled = true, virtual_text = true, signs = true },
  state = { enabled = true },
  watch = { enabled = true, symbol_queries = {} }, -- Clears symbol_queries
  diagnostic = { enabled = true, severity = 1 }, -- Clears severity warning
}
