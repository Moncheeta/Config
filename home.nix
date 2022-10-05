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
      NIXOS_CONFIG_DIR = "$HOME/Config";
      XDG_CACHE_HOME   = "$HOME/.cache";
      XDG_CONFIG_HOME  = "$HOME/.config";
      XDG_BIN_HOME     = "$HOME/.local/bin";
      XDG_DATA_HOME    = "$HOME/.local/share";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      PATH = "$XDG_BIN_HOME:$PATH";
    };

    packages = with pkgs; [
      ### Programs
      ## Audio
      pamixer
      pavucontrol
      playerctl
      spotify
      cava

      ## Command Line
      # Formats
      glow
      ouch # for decompressing files

      # Help
      tldr

      # Communication
      element-desktop-wayland

      # Navigation
      xplr
      bat
      ripgrep
      fzf
      fd

      # System
      btop
      trash-cli
      lfs
      wl-clipboard

      # Other
      pfetch
      peaclock
      cmatrix
      pingu

      ## Programming Languages
      # Rust
      cargo

      # Python
      python3
      python310Packages.pip

      ## Games
      steam
      lunar-client

      ### Libs
      libnotify
      libsecret
      xorg.libxcb
      libappindicator

      ### Window Managers
      ## Hyprland
      swaybg
      swaylock-effects
      sway-launcher-desktop
    ];
  };

  programs.home-manager.enable = true;
}
