vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	-- Main
	use("echasnovski/mini.nvim")
	use("sainnhe/sonokai")
	-- Programming
	use("sheerun/vim-polyglot")
	use("neovim/nvim-lspconfig")
	use("nvim-treesitter/nvim-treesitter")
	use("nvim-treesitter/nvim-treesitter-context")
	use("mhartington/formatter.nvim")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/nvim-cmp")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
	-- Editing
	use("deoplete-plugins/deoplete-lsp")
	use("gcmt/wildfire.vim")
	-- UI
	use("nvim-lualine/lualine.nvim")
	use("lewis6991/gitsigns.nvim")
	use("norcalli/nvim-colorizer.lua")
	use("folke/todo-comments.nvim")
	use("nvim-lua/plenary.nvim")
	use("nvim-telescope/telescope.nvim")
	use{"nvim-telescope/telescope-fzf-native.nvim", run = "make" }
	use("nvim-telescope/telescope-ui-select.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	-- Other
	use("junegunn/goyo.vim")
	use("wakatime/vim-wakatime")
	use("benizi/vim-automkdir")
	use("rhysd/vim-grammarous")
end)
