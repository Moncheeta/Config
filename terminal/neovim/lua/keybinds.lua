-- keybindings
-- TODO: Try to use leader key more
vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<C-n>", ":noh<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-space>", "<plug>(wildfire-fuel)", { silent = true })

vim.api.nvim_set_keymap("n", "<f1>", ":lua vim.lsp.buf.hover()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f2>", ":lua vim.lsp.buf.definition()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f3>", ":lua vim.lsp.buf.rename()<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f4>", ":lua vim.lsp.buf.code_action()<cr>", { silent = true })

vim.api.nvim_set_keymap("n", "<f5>", ":Telescope find_files<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f6>", ":Telescope lsp_workspace_symbols<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f7>", ":Telescope git_commits<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f8>", ":Telescope git_status<cr>", { silent = true })

vim.api.nvim_set_keymap("n", "<f9>", ":TodoTelescope<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f10>", ":Goyo<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f11>", ":Telescope spell_suggest<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<f12>", ":Telescope diagnostics<cr>", { silent = true })

-- TODO: Write a mapping for vim-grammarous
