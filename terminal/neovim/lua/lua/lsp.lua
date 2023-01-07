-- require("orgmode").setup_ts_grammar()
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = { "org" },
  },
  ensure_installed = "all",
}
require("treesitter-context").setup { enable = true }

-- require("orgmode").setup({
--   org_agenda_files = { "~/Documents/Notes/*" },
--   default_agenda_file = { "~/Documents/agenda.org" },
-- })

-- Lang Server Conf
local servers = { "clangd", "rust_analyzer", "sumneko_lua", "gopls", "bashls", "jedi_language_server" }
for _, lsp in pairs(servers) do
    require("lspconfig")[lsp].setup({
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      }
  })
end

require("formatter").setup({
  filetype = {
    json = {
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--double-quote"},
          stdin = true
        }
      end
    },
    yaml = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--double-quote"},
          stdin = true
        }
      end
    },
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
    html = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--double-quote"},
          stdin = true
        }
      end
    },
    sh = {
      -- Shell Script Formatter
      function()
        return {
          exe = "shfmt",
          args = { "-i", 2 },
          stdin = true,
        }
      end
    },
    lua = {
      function()
        return {
          exe = "stylua",
          args = {
            "--config-path "
              .. "/home/moncheeta/.config/stylua/stylua.toml",
            "-",
          },
          stdin = true,
        }
      end,
    },
    c = {
        -- clang-format
       function()
          return {
            exe = "clang-format",
            args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
            stdin = true,
            cwd = vim.fn.expand("%:p:h")  -- Run clang-format in cwd of the file.
          }
        end
    },
    cpp = {
        -- clang-format
       function()
          return {
            exe = "clang-format",
            args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
            stdin = true,
            cwd = vim.fn.expand("%:p:h")  -- Run clang-format in cwd of the file.
          }
        end
    },
    python = {
      -- Configuration for psf/black
      function()
        return {
          exe = "black", -- this should be available on your $PATH
          args = { "-" },
          stdin = true,
        }
      end
    },
    go = {
      function()
        return {
          exe = "gofmt",
          stdin = true
        }
      end
    },
    dart = {
      function()
        return {
          exe = "dart",
          args = {
            "format"
          },
          stdin = true
        }
      end
    },
  }
})
