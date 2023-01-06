local plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugged")

plug "echasnovski/mini.nvim"
plug "sheerun/vim-polyglot"

-- LSP
plug("neovim/nvim-lspconfig")
plug("nvim-treesitter/nvim-treesitter")
plug("nvim-treesitter/nvim-treesitter-context")
plug("gcmt/wildfire.vim")
plug("Shougo/deoplete.nvim")
plug("deoplete-plugins/deoplete-lsp")
plug("mhartington/formatter.nvim")

-- UI
plug("sainnhe/sonokai")
plug("junegunn/goyo.vim")
plug("nvim-lualine/lualine.nvim")
plug("lewis6991/gitsigns.nvim")
plug("norcalli/nvim-colorizer.lua")
plug("folke/todo-comments.nvim")

-- Telescope
plug("nvim-lua/plenary.nvim")
plug("nvim-telescope/telescope.nvim")
plug("nvim-telescope/telescope-fzf-native.nvim", {["do"] = "make"})
plug("nvim-telescope/telescope-ui-select.nvim")
plug("nvim-telescope/telescope-file-browser.nvim")

-- Other
plug("wakatime/vim-wakatime")
plug("benizi/vim-automkdir")
plug("rhysd/vim-grammarous")

vim.call("plug#end")

-- Opt
vim.cmd("let g:deoplete#enable_at_startup = 1")
vim.cmd("colorscheme sonokai")

require("bar")

require("mini.starter").setup() -- a menu screen
require("mini.comment").setup() -- use gcc to toggle comment
require('mini.jump2d').setup() -- use enter to jump
require("mini.indentscope").setup() -- shows a line at the current indent
require("mini.surround").setup() -- used to highlight matching symbols
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

vim.g.automkdir_silent = 1
