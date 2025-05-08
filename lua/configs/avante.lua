return
  {
    provider = "claude",
    auto_suggestions_provider = "claude",
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-latest",
      temperature = 0,
      max_tokens = 4096,
    },
    vendors = {
      ["litellm-eth"] = {
        endpoint = "https://litellm.sph-prod.ethz.ch/chat/completions",
        api_key_name = "LITELLM_ETH_API_KEY",
        model = "claude-3-5-sonnet-latest",
        temperature = 0,
        max_tokens = 4096,
        stream = false,
        
        parse_curl_args = function(opts, code_opts)
          -- Debug: Let's check what's in code_opts
          vim.api.nvim_echo({{"Debug - code_opts: " .. vim.inspect(code_opts), "None"}}, true, {})
          
          -- Ensure we have message content - CRITICAL FIX
          local question = "Hello, this is a test message"
          
          -- Use code_opts.question if available
          if code_opts.question and code_opts.question ~= "" then
            question = code_opts.question
          end
          
          -- Create a valid message with content
          local messages = {
            {
              role = "user",
              content = question
            }
          }
          
          -- Log the messages to be sure they have content
          vim.api.nvim_echo({{"Debug - Messages: " .. vim.inspect(messages), "None"}}, true, {})

          local json_data = {
            model = "claude-3-5-sonnet-latest",
            messages = messages,
            temperature = 0,
            max_tokens = 4096
          }
          
          -- Get API key directly
          local api_key = os.getenv(opts.api_key_name)
          
          -- Check if key exists and has reasonable length
          if not api_key or api_key == "" then
            vim.api.nvim_echo({{"ERROR: API key not found or empty", "ErrorMsg"}}, true, {})
            error("API key not found in environment variable " .. opts.api_key_name)
          else
            vim.api.nvim_echo({{"Debug - API key found with length: " .. #api_key, "None"}}, true, {})
          end
          
          -- Log the full request for debugging
          local debug_data = vim.deepcopy(json_data)
          vim.api.nvim_echo({{"Debug - Full request data: " .. vim.inspect(debug_data), "None"}}, true, {})
          
          return {
            url = opts.endpoint,
            headers = {
              ["Content-Type"] = "application/json",
              ["Authorization"] = "Bearer " .. api_key
            },
            data = vim.json.encode(json_data)
          }
        end,
        
        parse_response = function(data_stream, event_state, opts)
          -- Log the response for debugging
          vim.api.nvim_echo({{"Debug - Got response: " .. data_stream:sub(1, 200), "None"}}, true, {})
          
          -- Try to parse as regular JSON first
          local success, parsed = pcall(vim.json.decode, data_stream)
          
          if success and parsed.choices and parsed.choices[1] and 
             parsed.choices[1].message and parsed.choices[1].message.content then
            local content = parsed.choices[1].message.content
            vim.api.nvim_echo({{"Debug - Extracted content: " .. content, "None"}}, true, {})
            if opts.on_chunk then
              opts.on_chunk(content)
            end
            if opts.on_complete then
              opts.on_complete()
            end
            return
          else
            vim.api.nvim_echo({{"Debug - Could not extract content from response", "WarningMsg"}}, true, {})
          end
        end
      }
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
      enable_token_counting = true,
    },
    mappings = {
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
      },
    },
    hints = { enabled = true },
    windows = {
      position = "right",
      wrap = true,
      width = 30,
      sidebar_header = {
        enabled = true,
        align = "center", 
        rounded = true,
      },
      input = {
        prefix = "> ",
        height = 8,
      },
      edit = {
        border = "rounded",
        start_insert = true,
      },
      ask = {
        floating = false,
        start_insert = true,
        border = "rounded",
        focus_on_apply = "ours",
      },
    },
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
    diff = {
      autojump = true,
      list_opener = "copen",
      override_timeoutlen = 500,
    },
    suggestion = {
      debounce = 600,
      throttle = 600,
    },
  }
