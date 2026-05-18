return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },

  {
    "dmtrKovalenko/fff.nvim",
    lazy = false,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      prompt = " ",
      title = "Files",
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "G",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Gread",
      "Gwrite",
      "Gclog",
      "Gblame",
      "GBrowse",
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    opts = {},
  },

  {
    "nicolasgb/jj.nvim",
    cmd = {
      "J",
      "Jdiff",
      "Jvdiff",
      "Jhdiff",
      "JJ",
    },
    dependencies = {
      "sindrets/diffview.nvim",
    },
    config = function()
      require("jj").setup {
        diff = {
          backend = "diffview",
        },
      }

      vim.api.nvim_create_user_command("JJ", function(opts)
        vim.cmd("J " .. opts.args)
      end, {
        nargs = "*",
        complete = "command",
      })
    end,
  },

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
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
    --{
    --"voltycodes/areyoulockedin.nvim",
    --dependencies = { "nvim-lua/plenary.nvim" },
    --event = "VeryLazy",
    --config = function()
     -- require("areyoulockedin").setup({
      --  session_key = "",
     -- })
    --end,
 -- },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css"
      },
      highlight = {
        enable = true,
        -- Ensure Tamarin files get highlighted
        disable = function(lang, buf)
          if lang == "tamarin" then
            return false
          end
        end,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Associate .spthy files with Tamarin
      vim.filetype.add({
        extension = {
          spthy = "tamarin",
        },
      })

      -- Add parser configuration
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.tamarin = {
        install_info = {
          url = "https://github.com/aeyno/tree-sitter-tamarin.git",
          files = {"src/parser.c", "src/scanner.c"},
          branch = "main",
        },
        filetype = "tamarin",
      }

      -- Install Tamarin parser only if not already installed
      local parsers = require("nvim-treesitter.parsers")
      if not parsers.has_parser("tamarin") then
        vim.cmd("TSInstall tamarin")
      end
    end,
  },

  {
    "3rd/image.nvim",
    build = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = { enabled = false },
        html = { enabled = false },
        css = { enabled = false },
      },
    },
  },

  {
    "dragmakex/solidity-metrics.nvim",
    ft = "solidity",
    dependencies = { "3rd/image.nvim" },
    cmd = {
      "SolidityMetricsFile",
      "SolidityMetricsWorkspace",
      "SolidityMetricsScope",
      "SolidityMetricsHtml",
    },
    keys = {
      { "<leader>sf", "<cmd>SolidityMetricsFile<cr>", desc = "Solidity metrics: current file" },
      { "<leader>sw", "<cmd>SolidityMetricsWorkspace<cr>", desc = "Solidity metrics: workspace" },
      { "<leader>ss", "<cmd>SolidityMetricsScope<cr>", desc = "Solidity metrics: scope file" },
      { "<leader>sh", "<cmd>SolidityMetricsHtml<cr>", desc = "Solidity metrics: export HTML" },
    },
    opts = {
      cmd = nil,
      prefer_local = true,
      local_bin = "solidity-code-metrics",
      timeout = 120000,
      scopefile = "scope.txt",
      workspace_root_markers = {
        ".git",
        "foundry.toml",
        "hardhat.config.js",
        "hardhat.config.ts",
        "truffle-config.js",
        "truffle.js",
        "package.json",
      },
      exclude = {
        "**/node_modules/**",
        "**/mock*/**",
        "**/test*/**",
        "**/migrations/**",
        "**/Migrations.sol",
      },
      output = {
        kind = "split",
        split = "botright new",
        float = {
          border = "rounded",
          width = 0.9,
          height = 0.9,
        },
      },
      html = {
        open = true,
        filename = "solidity-metrics.html",
      },
      visual = {
        enabled = true,
        strict = true,
      },
      notify = true,
    },
  },

}
