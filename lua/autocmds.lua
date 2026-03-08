require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- check for file changes when buffer gains focus or enters
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd "checktime"
    end
  end,
})

autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    require("cmp").setup.buffer {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    }
  end,
})
