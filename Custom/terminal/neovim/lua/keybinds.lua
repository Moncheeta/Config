local a = vim.api

-- keybindings
a.nvim_set_keymap("n", "<C-n>", ":noh<cr>", { silent = true })

a.nvim_set_keymap("n", "-", "<plug>(choosewin)", { silent = true })
a.nvim_set_keymap("n", "<space>", "<plug>(wildfire-fuel)", { silent = true })

a.nvim_set_keymap("n", "<f1>", ":lua vim.lsp.buf.hover()<cr>", { silent = true })
a.nvim_set_keymap("n", "<f2>", ":lua vim.lsp.buf.definition()<cr>", { silent = true })
a.nvim_set_keymap("n", "<f3>", ":lua vim.lsp.buf.rename()<cr>", { silent = true })
a.nvim_set_keymap("n", "<f4>", ":lua vim.lsp.buf.code_action()<cr>", { silent = true })

a.nvim_set_keymap("n", "<f5>", ":Telescope find_files<cr>", { silent = true })
a.nvim_set_keymap("n", "<f6>", ":Telescope live_grep<cr>", { silent = true })
a.nvim_set_keymap("n", "<f7>", ":Telescope git_commits<cr>", { silent = true })
a.nvim_set_keymap("n", "<f8>", ":Telescope git_status<cr>", { silent = true })

a.nvim_set_keymap("n", "<f9>", ":GrammarousCheck<cr>", { silent = true })
-- a.nvim_set_keymap("n", "<f10>", "<cr>", { silent = true })
-- a.nvim_set_keymap("n", "<f11>", "<cr>", { silent = true })
a.nvim_set_keymap("n", "<f12>", ":Goyo<cr>", { silent = true })
