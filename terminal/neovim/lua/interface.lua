require("nightfox").setup({
  palettes = {
    carbonfox = {
      bg1 = "#000000", -- Black background
      bg0 = "#1d1d2b", -- Alt backgrounds (floats, statusline, ...)
      bg3 = "#121820", -- 55% darkened from stock
      sel0 = "#131b24", -- 55% darkened from stock
    },
  },
  specs = {
    all = {
      inactive = "bg0", -- Default value for other styles
    },
  },
  groups = {
    all = {
      NormalNC = { fg = "fg1", bg = "inactive" }, -- Non-current windows
    },
  },
})

vim.cmd("colorscheme carbonfox")

require("bar") -- status bar
require("mini.starter").setup()

require("mini.comment").setup() -- use gcc to toggle comment
require("mini.surround").setup() -- used to highlight matching symbols
require('mini.jump2d').setup() -- use enter to jump
require("mini.indentscope").setup() -- shows a line at the current indent
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

require("telescope").setup {
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown()
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
