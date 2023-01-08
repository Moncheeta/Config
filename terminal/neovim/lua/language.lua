local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "clangd", "rust_analyzer", "sumneko_lua", "bashls", "jedi_language_server" }
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
        capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	})
end

require("orgmode").setup_ts_grammar()
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "org" },
	},
	ensure_installed = "all",
})
require("treesitter-context").setup({ enable = true })

require("orgmode").setup({
  org_agenda_files = { "~/documents/notes/agenda/*" },
  default_agenda_file = { "~/documents/notes/agenda/agenda.org" },
})

require("formatter").setup({
	filetype = {
		rust = {
			function()
				return {
					exe = "rustfmt",
					args = { "--emit=stdout" },
					stdin = true,
				}
			end,
		},
		sh = {
			function()
				return {
					exe = "shfmt",
					args = { "-i", 2 },
					stdin = true,
				}
			end,
		},
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						"-",
					},
					stdin = true,
				}
			end,
		},
		c = {
			function()
				return {
					exe = "clang-format",
					args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
					stdin = true,
					cwd = vim.fn.expand("%:p:h"),
				}
			end,
		},
		cpp = {
			function()
				return {
					exe = "clang-format",
					args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
					stdin = true,
					cwd = vim.fn.expand("%:p:h"),
				}
			end,
		},
		python = {
			function()
				return {
					exe = "black",
					args = { "-" },
					stdin = true,
				}
			end,
		},
	},
})

vim.api.nvim_create_augroup("files", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "files",
	command = "lua MiniTrailspace.trim()",
})
