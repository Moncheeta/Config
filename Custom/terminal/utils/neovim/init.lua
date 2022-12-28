local g = vim.g
local o = vim.o
local a = vim.api
local cmd = vim.cmd

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
o.spell = true

o.updatetime = 50
o.ttyfast = true

o.clipboard = "unnamedplus"

-- UI
o.mouse = "a"
o.guicursor="n-v-c:block"

o.guifont = "JetBrainsMono Nerd Font:h12"

cmd("set scrolloff=999")

o.hidden = true
o.showmode = false

o.termguicolors = true
cmd("syntax on")

o.number = true
o.relativenumber = true

o.cursorline = true
a.nvim_set_hl(0, "ColorLineNr", { ctermfg=White })

a.nvim_create_augroup("files", { clear = true })
a.nvim_create_autocmd("bufwritepre", {
  group = "files",
  command = "lua MiniTrailspace.trim()",
})

require("plugins")
require("lsp")
require("keybinds")
