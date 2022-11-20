{ config, pkgs, ... }:

{
  imports = [
    ./modules/home.nix
  ];

  home = {
    stateVersion = "22.11";

    username = "moncheeta";
    homeDirectory = "/home/moncheeta";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "alacritty";
      WALLPAPER = "$CONFIG_DIR/Wallpapers/Cars/RX7/savanna_japan.png";
      CONFIG_DIR = "$HOME/Config";
      NIXOS_CONFIG_DIR = "$HOME/Config/NixOS";
      XKB_DEFAULT_LAYOUT = "us(colemak)";

      ## Below is for stuff to work
      # window manager (wayland)
      LIBSEAT_BACKEND = "logind";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      XCURSOR_SIZE = "24";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      # steam
      XDG_CACHE_HOME   = "$HOME/.cache";
      XDG_CONFIG_HOME  = "$HOME/.config";
      XDG_BIN_HOME     = "$HOME/.local/bin";
      XDG_DATA_HOME    = "$HOME/.local/share";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      PATH = "$XDG_BIN_HOME:$PATH";
    };

    packages = with pkgs; [
      # Programs
      ## GUI
      spotify
      kdenlive
      gimp
      element-desktop-wayland
      pcmanfm

      ## Command Line
      ### Formats
      glow
      ouch # for decompressing files

      ### Useful
      tldr
      calc
      pfetch
      ffmpeg

      ### Navigation
      xplr
      bat
      ripgrep
      fzf
      fd

      ### System
      #### Info
      htop
      btop
      lfs
      pass

      #### Audio
      pamixer
      pavucontrol
      playerctl
      cava
      cmus

      #### Other
      trash-cli
      yt-dlp
      spotdl

      ### Other
      peaclock
      cmatrix
      pingu
      tokei
      jq

      # Programming Languages
      tree-sitter
      ## Shell
      shfmt
      nodePackages.bash-language-server

      ## Rust
      cargo
      rustc
      rustfmt
      rust-analyzer

      ## Lua
      sumneko-lua-language-server
      stylua

      ## Kotlin
      kotlin-language-server

      ## C, C++
      clang
      clang-tools

      ## Go
      go
      gopls

      ## Python
      python3
      black

      ### Python-Libs
      python310Packages.pip
      python310Packages.pynvim
      python310Packages.jedi-language-server

      ## json, yaml, html
      nodePackages.prettier

      ## Other
      dart
      nodejs

      # Games
      steam
      lunar-client
      retroarchFull

      # Libs
      libcxx
      libnotify
      libsecret
      xorg.libxcb
      libappindicator

      # Desktop
      ## Wayland
      river
      swaybg
      swaylock-effects
      sway-launcher-desktop
      wl-clipboard
      # Xorg
      xorg.xrdb
      xsel
    ];
  };

  programs.home-manager.enable = true;
}
