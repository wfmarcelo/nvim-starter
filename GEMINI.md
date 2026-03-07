# Neovim Configuration (NVC) Agent Context

This repository contains a modular Neovim configuration based on NvChad, but heavily customized for C#, Python, and IA-assisted development.

## Project Structure
- `init.lua`: Main entry point.
- `lua/options.lua`: Neovim and NvChad options.
- `lua/mappings.lua`: Keybindings.
- `lua/plugins/init.lua`: Plugin declarations (lazy.nvim).
- `lua/configs/`: Detailed configuration for specific plugins (lsp, dap, avante, etc.).

## Key Plugins
- **Avante.nvim:** For AI-assisted code editing and chat.
- **Gemini-cli.nvim:** For full agentic powers directly in Neovim.
- **LSPConfig & Mason:** LSP management.
- **Conform.nvim:** Formatting.
- **DAP:** Debugging support for .NET and others.

## Coding Style
- Follow Lua best practices for Neovim (using `vim.api`, `vim.keymap`, etc.).
- Keep plugin configurations modular in `lua/configs/`.
