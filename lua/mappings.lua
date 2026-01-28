require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights on search" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Resize splits with Ctrl + Arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Equalize window sizes (Very helpful after closing a debugger)
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    -- Map <F5> to execute the query in the current buffer
    -- 'db_exe' is a standard way to trigger Dadbod execution
    vim.keymap.set("n", "<F5>", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute Query" })

    -- F5: Run Query from Insert Mode (stays in Insert Mode)
    vim.keymap.set("i", "<F5>", "<C-o><Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute Query" })

    -- If you want to run a visual selection with F5
    vim.keymap.set("v", "<F5>", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute Selection" })

    vim.opt_local.ignorecase = true
  end,
})
