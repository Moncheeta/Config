local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "ccls", "rust_analyzer" }
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
        capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	})
end

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
	ensure_installed = "all",
})
require("treesitter-context").setup({ enable = true })

vim.api.nvim_create_augroup("files", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "files",
	command = "lua MiniTrailspace.trim()",
})
