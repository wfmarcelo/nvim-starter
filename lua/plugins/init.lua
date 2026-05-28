return {
  -- 1. Utilities
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- Define o estilo do layout como vertical
        layout_strategy = "vertical",

        layout_config = {
          vertical = {
            -- Força o Telescope a ocupar praticamente 100% da tela
            width = 0.95,
            height = 0.95,

            -- Coloca o preview no topo e a busca (prompt) embaixo
            preview_height = 0.65, -- Altere esse valor se quiser o preview maior ou menor
            -- mirror = true, -- O 'mirror' inverte a ordem padrão, jogando o preview para cima
          },
        },
      },
    },
  },
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
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false,

    opts = {
      instructions_file = "avante.md",
      provider = "gemini",
      providers = {
        ollama = {
          model = "qwen2.5-coder:7b",
        },
        gemini = {
          model = "gemini-3.1-flash-lite",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    },
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
      {
        "<leader>aM",
        function()
          require("configs.aider").change_model()
        end,
        desc = "AI: Change Aider Model",
      },
    },
    dependencies = {
      "folke/snacks.nvim",
      -- optional dependencies
      "catppuccin/nvim",
    },
    config = function()
      require("configs.aider").setup()
    end,
  },
}
