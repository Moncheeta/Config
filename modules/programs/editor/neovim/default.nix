{ pkgs, vars, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = "luafile \$NIXOS_CONFIG_DIR/modules/programs/editor/neovim/init.lua";
    plugins = with pkgs.vimPlugins; [
      # Language support
      mini-nvim # a bunch of nice plugins
      vim-polyglot # language support
      nvim-treesitter
      nvim-lspconfig
      formatter-nvim

      # Navigation
      telescope-nvim
      telescope-file-browser-nvim
      telescope-ui-select-nvim
      wildfire-vim
      vim-choosewin
      nvim-treesitter-context
      vim-surround
      vim-automkdir

      # Github
      gitsigns-nvim

      # UI
      lualine-nvim
      sonokai
      nvim-colorizer-lua
      todo-comments-nvim
      goyo-vim

      # Other
      orgmode
      vim-wakatime
    ];
  };
}
