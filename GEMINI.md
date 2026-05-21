# Neovim Configuration (NVC) Agent Context

This repository contains a modular Neovim configuration based on NvChad, but heavily customized for C#, Python, and AI-assisted development.

## Project Structure
- `init.lua`: Main entry point.
- `lua/options.lua`: Neovim and NvChad options.
- `lua/mappings.lua`: Keybindings.
- `lua/plugins/init.lua`: Plugin declarations (lazy.nvim).
- `lua/configs/`: Detailed configuration for specific plugins (lsp, dap, avante, etc.).
- `lua/autocmds.lua`: Custom autocommands.

## Key Technologies & Plugins
- **AI-Assisted Development:**
  - **Avante.nvim:** For AI-assisted code editing and chat.
  - **Gemini-cli.nvim:** For full agentic powers directly in Neovim.
- **LSP & Formatting:**
  - **LSPConfig & Mason:** LSP management.
  - **Roslyn.nvim:** Specific support for C#.
  - **Conform.nvim:** Formatting.
- **Debugging & Testing:**
  - **DAP:** `nvim-dap`, `netcoredbg` (via Mason).
  - **Neotest:** `neotest`, `neotest-dotnet`.
  - **UI:** `nvim-dap-ui`, `nvchad`.

## Development Guidelines
- Follow Lua best practices for Neovim (using `vim.api`, `vim.keymap`, etc.).
- Keep plugin configurations modular in `lua/configs/`.
- Follow NvChad's structure.
- When modifying DAP configurations for C#, ensure compatibility with `netcoredbg`.
- Use `dotnet build` for compiling C# projects.

## Commit Guidelines
- Use **Conventional Commits** (e.g., `feat:`, `fix:`, `docs:`, `chore:`).
- Messages must be **descriptive**: explain the *why* and *how* behind the change, providing technical context when necessary, rather than just stating what was modified.
