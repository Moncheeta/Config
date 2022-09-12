local g = vim.g
local o = vim.o
local cmd = vim.cmd
local a = vim.api

-- Opt
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true

o.wrap = false
g.strip_whitespace_on_save = 1

o.encoding = "utf-8"

o.swapfile = false
o.backup = false
o.undodir = os.getenv("HOME") .. "/undodir"
o.undofile = true

o.updatetime = 50

o.clipboard = "unnamedplus"

-- UI
o.mouse = "a"
o.guicursor="n-v-c:block"

o.guifont = "JetBrainsMono Nerd Font:h12"

o.hidden = true
o.showmode = false

o.termguicolors = true
cmd("syntax on")

o.number = true
o.relativenumber = true

o.cursorline = true
a.nvim_set_hl(0, "ColorLineNr", { ctermfg=White })

g.sonokai_style = "atlantis"
cmd("colorscheme sonokai")

local lualine = require("lualine")

local colors = {
  bg       = "#202328",
  fg       = "#bbc2cf",
  yellow   = "#ECBE7B",
  cyan     = "#008080",
  darkblue = "#081633",
  green    = "#98be65",
  orange   = "#FF8800",
  violet   = "#a9a1e1",
  magenta  = "#c678dd",
  blue     = "#51afef",
  red      = "#ec5f67",
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local config = {
  options = {
    component_separators = "",
    section_separators = "",
    theme = {
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
	"mode",
	color = { fg = colors.blue, gui = "bold" },
}

ins_left {
  "filesize",
  cond = conditions.buffer_not_empty,
	color = { fg = colors.green, gui = "bold" },
}

ins_left {
  "filename",
  cond = conditions.buffer_not_empty,
  color = { fg = colors.red, gui = "bold" },
}

ins_right { "location" }

ins_left {
  function()
    return "%="
  end,
}

ins_left {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

ins_right {
  "branch",
  icon = "",
  color = { fg = colors.violet, gui = "bold" },
}

ins_right {
  "diff",
  symbols = { added = " ", modified = "柳 ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

lualine.setup(config)

-- Keybindings
g.mapleader = " "

a.nvim_set_keymap("n", "<C-m>", ":noh<CR>", { silent = true })

a.nvim_set_keymap("n", "-", "<Plug>(choosewin)", { silent = true })
a.nvim_set_keymap("n", "<SPACE>", "<Plug>(wildfire-fuel)", { silent = true })
--nmap <F1> vim.lsp.buf.hover()<CR>
--nmap <F2> vim.lsp.buf.definition()<CR>
--nmap <F3> vim.lsp.buf.rename()<CR>
--nmap <F4> :Telescope fzf<CR>

--nmap <silent> <F5> :NvimTreeToggle<CR>
--nmap <silent> <F6> :Telescope fd<CR>
--nmap <silent> <F7> :TMToggle<CR>
--nmap <silent> <F8> :ToggleTerm<CR>

--nmap <F9> :GV<CR>
--nmap <F10> :Gissues<CR>
--nmap <F11> :Git add .<CR>
--nmap <F12> :Git commit<CR>

require("mini.starter").setup() -- a menu screen
require("mini.comment").setup() -- use gcc to toggle comment
require("mini.tabline").setup() -- shows all open buffers
require("mini.indentscope").setup() -- shows a line at the current indent
require("mini.pairs").setup() -- auto pairs

require("colorizer").setup() -- for hex and rgb values to be colored
require("todo-comments").setup()
require("gitsigns").setup()
require("nvim-tree").setup() -- file explorer

require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    parser_install_dir = "$HOME/Extra/parsers"
}

require('orgmode').setup_ts_grammar()
require('orgmode').setup()

require("telescope").setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"                              -- the default case_mode is "smart_case"
    },
    file_browser = {
      hijack_netrw = true,
    }
  }
}
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("media_files")
require("telescope").load_extension("ui-select")

-- Lang Server Conf
local servers = { "clangd", "rust_analyzer", "tsserver", "pyright", "sumneko_lua", "golangci_lint_ls", "kotlin_language_server", "bashls" }
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
    kotlin = {
      function()
        return {
          exe = "java -jar /home/moncheeta/Documents/Config/Language_Servers/kotlin/ktfmt/core/target/ktfmt-0.34-jar-with-dependencies.jar",
          stdin = false
        }
      end
    },
  }
})
