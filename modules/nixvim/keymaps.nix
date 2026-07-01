{ config
, pkgs
, ...
}: {
  programs.nixvim.keymaps = [
    # Neo-tree bindings
    {
      action = "<cmd>Neotree toggle<CR>";
      key = "<leader>e";
    }
    {
      key = "<C-s>";
      action = "<cmd>w<CR><cmd>lua vim.lsp.buf.format({ async = true })<CR>";
    }

    # Window Vim like movements
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "Move to the left window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "Move to the right window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "Move to the below window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "Move to the above window";
      };
    }

    # Undotree
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>UndotreeToggle<CR>";
      options = {
        desc = "Undotree";
      };
    }

    # Lazygit
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit (root dir)";
      };
    }

    # Commentary bindings
    {
      action = "<cmd>Commentary<CR>";
      key = "<leader>/";
    }

    # Daily note (zen) — open/create today's markdown note in ~/git/notes
    {
      mode = "n";
      key = "<leader>n";
      action.__raw = ''
        function()
          local dir = vim.fn.expand("~/git/notes")
          local date = os.date("%Y-%m-%d")
          local path = dir .. "/" .. date .. ".md"
          vim.fn.mkdir(dir, "p")
          if vim.fn.filereadable(path) == 0 then
            vim.fn.writefile({}, path)
          end
          local prev_buf = vim.api.nvim_get_current_buf()
          vim.cmd("edit " .. vim.fn.fnameescape(path))
          local note_buf = vim.api.nvim_get_current_buf()
          if package.loaded["snacks"] and Snacks and Snacks.zen then
            Snacks.zen({
              on_close = function()
                -- restore parent window to whatever was there before, drop the note buffer
                if vim.api.nvim_buf_is_valid(prev_buf) then
                  pcall(vim.api.nvim_win_set_buf, 0, prev_buf)
                end
                pcall(vim.cmd, "bdelete " .. note_buf)
              end,
            })
          end
        end
      '';
      options = {
        desc = "Today's daily note (zen)";
      };
    }

    # Canonical task list — open/create ~/git/notes/TODO.md in zen
    {
      mode = "n";
      key = "<leader>t";
      action.__raw = ''
        function()
          local dir = vim.fn.expand("~/git/notes")
          local path = dir .. "/TODO.md"
          vim.fn.mkdir(dir, "p")
          if vim.fn.filereadable(path) == 0 then
            vim.fn.writefile({ "# TODO", "", "- [ ] " }, path)
          end
          local prev_buf = vim.api.nvim_get_current_buf()
          vim.cmd("edit " .. vim.fn.fnameescape(path))
          local note_buf = vim.api.nvim_get_current_buf()
          if package.loaded["snacks"] and Snacks and Snacks.zen then
            Snacks.zen({
              on_close = function()
                if vim.api.nvim_buf_is_valid(prev_buf) then
                  pcall(vim.api.nvim_win_set_buf, 0, prev_buf)
                end
                pcall(vim.cmd, "bdelete " .. note_buf)
              end,
            })
          end
        end
      '';
      options = {
        desc = "Open TODO.md (zen)";
      };
    }

    # Grep across the notes vault — type a query, or leave blank to browse all lines
    {
      mode = "n";
      key = "<leader>ot";
      action.__raw = ''
        function()
          require('telescope.builtin').live_grep({
            cwd = vim.fn.expand("~/git/notes"),
            additional_args = { "--fixed-strings" },
          })
        end
      '';
      options = {
        desc = "Grep notes (blank = all)";
      };
    }

    # Toggle checkbox on the current line: - [ ] <-> - [x]
    {
      mode = "n";
      key = "<leader>x";
      action.__raw = ''
        function()
          local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
          local new_line
          if line:match("%- %[[ ]%]") then
            new_line = line:gsub("%- %[[ ]%]", "- [x]", 1)
          elseif line:match("%- %[[xX]%]") then
            new_line = line:gsub("%- %[[xX]%]", "- [ ]", 1)
          else
            -- not a checkbox line — insert one before the content
            new_line = line:gsub("^(%s*)", "%1- [ ] ", 1)
          end
          vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
        end
      '';
      options = {
        desc = "Toggle checkbox";
      };
    }

    # Grep across the notes vault
    {
      mode = "n";
      key = "<leader>og";
      action = "<cmd>lua require('telescope.builtin').live_grep({ cwd = vim.fn.expand('~/git/notes') })<CR>";
      options = {
        desc = "Grep notes";
      };
    }

    # Find files in the notes vault
    {
      mode = "n";
      key = "<leader>of";
      action = "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.expand('~/git/notes') })<CR>";
      options = {
        desc = "Find notes";
      };
    }

    # Telescope bindings

    {
      mode = "n";
      action = "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.env.HOME })<CR>";
      key = "<leader>ff";
      options = {
        desc = "Find files (home dir)";
      };
    }
    {
      action = "<cmd>Telescope find_files<CR>";
      key = "<leader><leader>";
    }
    {
      action = "<cmd>Telescope git_commits<CR>";
      key = "<leader>fg";
    }
    {
      action = "<cmd>Telescope oldfiles<CR>";
      key = "<leader>fh";
    }
    {
      action = "<cmd>Telescope colorscheme<CR>";
      key = "<leader>ch";
    }
    {
      action = "<cmd>Telescope man_pages<CR>";
      key = "<leader>fm";
    }

    # Notify bindings

    {
      mode = "n";
      key = "<leader>un";
      action = ''
        <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
      '';
      options = {
        desc = "Dismiss All Notifications";
      };
    }

    # Bufferline bindings

    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = {
        desc = "Cycle to next buffer";
      };
    }

    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = {
        desc = "Cycle to previous buffer";
      };
    }

    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = {
        desc = "Cycle to next buffer";
      };
    }

    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = {
        desc = "Cycle to previous buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<cr>";
      options = {
        desc = "Delete buffer";
      };
    }

    # Next buffer
    {
      mode = "n";
      key = "<Right>";
      action = "<cmd>bn<CR>";
      options = {
        desc = "Next buffer";
      };
    }

    # Previous buffer
    {
      mode = "n";
      key = "<Left>";
      action = "<cmd>bp<CR>";
      options = {
        desc = "Previous buffer";
      };
    }

    # Copilot Chat

    {
      mode = "n";
      key = "<leader>ze";
      action = "<cmd>CopilotChatExplain<cr>";
      options = {
        desc = "Copilot Chat Explain";
      };
    }

    {
      mode = "n";
      key = "<leader>zr";
      action = "<cmd>CopilotChatReview<cr>";
      options = {
        desc = "Copilot Chat Explain";
      };
    }

    {
      mode = "v";
      key = "<leader>zf";
      action = "<cmd>CopilotChatFix<cr>";
      options = {
        desc = "Copilot Chat Explain";
      };
    }

    {
      mode = "n";
      key = "<leader>zo";
      action = "<cmd>CopilotChatOptimize<cr>";
      options = {
        desc = "Copilot Chat Explain";
      };
    }
  ];
}
