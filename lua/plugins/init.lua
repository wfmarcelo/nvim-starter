return {
  -- 1. Utilities
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false, -- Load on startup so it can handle directory buffers
    config = function()
      require "configs.oil"
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPre",
    config = function()
      require("guess-indent").setup {}
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      terminal = { enabled = true },
      picker = { enabled = true },
    },
  },
  { "stevearc/conform.nvim", opts = require "configs.conform" },
  { "folke/lazydev.nvim", ft = "lua", opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } } },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = require "configs.kulala",
    config = function(_, opts)
      require("kulala").setup(opts)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- 2. Core LSP & Treesitter
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function()
      return require "configs.mason"
    end,
  },
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor", "cshtml" },
    config = function()
      require("roslyn").setup {
        args = {
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
          "--stdio",
        },
        config = {
          -- Aumenta o timeout para evitar o erro de LSP timeout
          timeout = 10000,
          on_attach = function(client, bufnr)
            -- Desativa o Signature Help para evitar o erro de desserialização
            client.server_capabilities.signatureHelpProvider = nil
          end,
          settings = {
            ["razor"] = {
              -- Desabilita algumas funções automáticas que pesam no CSHTML
              formatOnType = false,
            },
          },
        },
      }
    end,
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", opts = require "configs.treesitter" },
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml", "puml" },
  },
  {
    "weirongxu/plantuml-previewer.vim",
    ft = "plantuml",
    dependencies = { "tyru/open-browser.vim" },
    config = function()
      -- This ensures the previewer works with the system plantuml
      -- Manjaro's plantuml package usually handles the jar path automatically
    end,
  },

  -- 3. Debugging (DAP)
  {
    -- Debug Framework
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require "configs.nvim-dap"
    end,
    event = "VeryLazy",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require "configs.nvim-dap-ui"
    end,
  },
  { "ramboe/ramboe-dotnet-utils", dependencies = { "mfussenegger/nvim-dap" } },

  -- 4. Testing (Neotest)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet", -- Adapter as a dependency
    },
    config = function()
      require "configs.neotest"
    end,
  },

  -- 5. Database
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- 6. IA
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        -- Ativamos as sugestões para o "Ghost Text"
        suggestion = {
          enabled = true,
          auto_trigger = true, -- Sugere enquanto você digita
          keymap = {
            accept = "<M-l>", -- Alt + l para aceitar a sugestão
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true, -- Garante que funcione em .md
          help = false,
          gitcommit = true,
          -- Desative em arquivos onde você não quer IA "atrapalhando"
          ["*"] = true, 
        },
      }
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" to keep up to date, or false to use the latest code
    opts = function()
      return require "configs.avante"
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua", -- if you want to use copilot.lua
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    cmd = { "Avante", "AvanteChat", "AvanteChatActions" },
  },
  {
    "marcinjahn/gemini-cli.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    cmd = { "Gemini" },
    opts = {},
  },
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = { "Aider", "AiderToggle" },
    keys = {
      { "<leader>a/", "<cmd>Aider toggle<cr>", desc = "AI: Toggle Aider" },
      { "<leader>as", "<cmd>Aider send<cr>", desc = "AI: Send to Aider", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>Aider command<cr>", desc = "AI: Aider Commands" },
      { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "AI: Send Buffer" },
      { "<leader>a+", "<cmd>Aider add<cr>", desc = "AI: Add File" },
      { "<leader>a-", "<cmd>Aider drop<cr>", desc = "AI: Drop File" },
      { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "AI: Add Read-Only" },
      { "<leader>aR", "<cmd>Aider reset<cr>", desc = "AI: Reset Session" },
    },
    dependencies = {
      "folke/snacks.nvim",
      -- optional dependencies
      "catppuccin/nvim",
    },
    config = function()
      require("nvim_aider").setup {
        args = {
          "--model",
          "ollama/qwen2.5-coder:7b",
          "--no-auto-commits",
          "--pretty",
          "--stream",
        },
        win = {
          style = "nvim_aider",
          position = "right",
        },
      }
    end,
  },
}
