{ pkgs, vars, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = "luafile \$NIXOS_CONFIG_DIR/modules/scripts/neovim.lua";
    plugins = with pkgs.vimPlugins; [
      # Language support
      mini-nvim # a bunch of nice plugins
      vim-polyglot # language support
      nvim-lspconfig
      nvim-yarp
      nvim-treesitter # nvim won't work without this for some reason?
      deoplete-nvim
      deoplete-lsp
      vim-grammarous
      formatter-nvim

      # Navigation
      telescope-nvim
      telescope-file-browser-nvim
      telescope-ui-select-nvim
      wildfire-vim
      vim-choosewin
      nvim-treesitter-context
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
      vim-wakatime
    ];
  };
}
