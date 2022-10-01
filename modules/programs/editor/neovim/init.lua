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

vim.cmd("set scrolloff=999")

o.hidden = true
o.showmode = false

o.termguicolors = true
cmd("syntax on")

o.number = true
o.relativenumber = true

o.cursorline = true
a.nvim_set_hl(0, "ColorLineNr", { ctermfg=White })

cmd("colorscheme sonokai")

local lualine = require("lualine")

local colors = {
  bg       = "#181819",
  fg       = "#e2e2e3",
  yellow   = "#e7c664",
  cyan     = "#f39660",
  darkblue = "#7f8490",
  green    = "#9ed072",
  orange   = "#f39660",
  violet   = "#b39df3",
  magenta  = "#b39df3",
  blue     = "#76cce0",
  red      = "#fc5d7c",
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
  color = function()
    local mode_color = {
      n = colors.green,
      i = colors.blue,
      v = colors.red,
      [''] = colors.red,
      V = colors.red,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = colors.bg, gui = "bold", bg = mode_color[vim.fn.mode()] }
  end,
}

ins_left {
  "filename",
  cond = conditions.buffer_not_empty,
  color = { fg = colors.red, gui = "bold" },
}

ins_left {
  "filesize",
  cond = conditions.buffer_not_empty,
  color = { fg = colors.green, gui = "bold" },
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
  symbols = { added = "+", modified = "~", removed = "-" },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  "location"
}

lualine.setup(config)

-- keybindings
g.mapleader = " "

a.nvim_set_keymap("n", "<c-m>", ":noh<cr>", { silent = true })

a.nvim_set_keymap("n", "-", "<plug>(choosewin)", { silent = true })
a.nvim_set_keymap("n", "<space>", "<plug>(wildfire-fuel)", { silent = true })

a.nvim_set_keymap("n", "<f1>", "vim.lsp.buf.hover()<cr>", { silent = true })
a.nvim_set_keymap("n", "<f2>", "vim.lsp.buf.definition()<cr>", { silent = true })
a.nvim_set_keymap("n", "<f3>", "vim.lsp.buf.rename()<cr>", { silent = true })
a.nvim_set_keymap("n", "<f4>", ":Telescope live_grep<cr>", { silent = true })

a.nvim_set_keymap("n", "<f5>", ":Telescope git_status<cr>", { silent = true })
a.nvim_set_keymap("n", "<f6>", ":Telescope git_commits<cr>", { silent = true })
a.nvim_set_keymap("n", "<f7>", ":Goyo", { silent = true })
a.nvim_set_keymap("n", "<f8>", ":Telescope fd<cr>", { silent = true })

a.nvim_set_keymap("n", "<f9>", ":GV<cr>", { silent = true })
a.nvim_set_keymap("n", "<f10>", ":Git add .<cr>", { silent = false })
a.nvim_set_keymap("n", "<f11>", ":Git commit<cr>", { silent = true })
a.nvim_set_keymap("n", "<f12>", ":Git push<cr>", { silent = false})

require("mini.starter").setup() -- a menu screen
require("mini.comment").setup() -- use gcc to toggle comment
require('mini.jump2d').setup() -- use enter to jump
require("mini.indentscope").setup() -- shows a line at the current indent
-- require("mini.statusline").setup()
require("mini.surround").setup() -- used to highlight certain objects
require("mini.cursorword").setup() -- underlines current word
require('mini.trailspace').setup() -- gets rid of whitespace
require("mini.pairs").setup() -- auto pairs

require("colorizer").setup() -- for hex and rgb values to be colored
require("todo-comments").setup()
require("gitsigns").setup({
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
})

require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    parser_install_dir = "$HOME/Extra/parsers"
}
require("treesitter-context").setup { enable = true, }

-- TODO: finish settinging up orgmode
require('orgmode').setup_ts_grammar()
require('orgmode').setup()

require("telescope").setup {
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown()
    }
  }
}
require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")

g.automkdir_silent = 1

a.nvim_create_augroup("files", { clear = true })
a.nvim_create_autocmd("bufwritepre", {
	group = "files",
	command = "lua MiniTrailspace.trim()",
})

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
