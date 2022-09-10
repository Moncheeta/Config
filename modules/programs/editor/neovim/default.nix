{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = "luafile $NIXOS_CONFIG_DIR/modules/programs/neovim/init.lua";
    plugins = with pkgs.vimPlugins; [
      # Language support
      mini-nvim # a bunch of nice plugins
      vim-polyglot # language support
      nvim-treesitter
      nvim-lspconfig
      formatter-nvim

      # Navigation
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-media-files-nvim
      telescope-ui-select-nvim
      nvim-tree-lua
      wildfire-vim
      vim-choosewin
      nvim-treesitter-context

      # Github
      vim-fugitive
      plenary-nvim
      gitsigns-nvim
      gv-vim

      # UI
      lualine-nvim
      sonokai
      vim-better-whitespace
      nvim-colorizer-lua
      todo-comments-nvim

      # Other
      vim-wakatime
    ];
  };
}
