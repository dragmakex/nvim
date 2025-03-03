return {
 
  {
    'goolord/alpha-nvim',
    cmd = "Alpha",
    init = function()
      if vim.fn.argc() == 0 then
        require("configs.alpha") -- Load the configuration from external file if no files are opened
      end
    end,
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- Automatically loads before buffers are read
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- Directory for saving session files
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- Options for session management
      })
    end,
  },
  --{
    --'boganworld/crackboard.nvim',
    --dependencies = { 'nvim-lua/plenary.nvim' },
    --lazy = false,
    --config = function()
      --require('crackboard').setup({
        --session_key = 'xx',
      --})
    --end,
  --},
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css"
      },
    },
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = require("configs.avante"),  -- This will load your avante.lua config
    build = "make",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.pick",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
            },
        },
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}}
