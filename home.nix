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
      "EDITOR" = "nvim";
      "VISUAL" = "nvim";
      "TERMINAL" = "kitty";
      "KITTY_ENABLE_WAYLAND" = "1";
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "XCURSOR_SIZE" = "24";
      "LIBVA_DRIVER_NAME" = "nvidia";
      "XDG_SESSION_TYPE" = "wayland";
      "GBM_BACKEND" = "nvidia-drm";
      "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      "WLR_NO_HARDWARE_CURSORS" = "1";
      "NIXOS_CONFIG_DIR" = "\${HOME}/Configs";
      "XDG_CACHE_HOME"   = "\${HOME}/.cache";
      "XDG_CONFIG_HOME"  = "\${HOME}/.config";
      "XDG_BIN_HOME"     = "\${HOME}/.local/bin";
      "XDG_DATA_HOME"   = "\${HOME}/.local/share";
      "STEAM_EXTRA_COMPAT_TOOLS_PATHS" = "\${HOME}/.steam/root/compatibilitytools.d";
      "PATH" = [
       "\${XDG_BIN_HOME}"
      ];
    };

    packages = with pkgs; [
      ## Applications
      dmenu
      spotify
      discord
      betterdiscordctl
      pavucontrol

      ## Games
      # Minecraft
      lunar-client

      # Steam
      steam

      ## Command Line Programs
      tldr
      lfs # for checking disks
      bat # better file viewer
      trash-cli
      unzip
      fd # find
      ripgrep
      links2 # html web browser
      gh
      hub # git wrapper
      xclip # clipboard
      btop # top
      glow # markdown in the terminal
      pfetch # stats
      pamixer # for audio
      tokei # code stats
      peaclock # better tty-clock
      cargo

      ## Libs
      libsecret
      xorg.libxcb

      ## Window Managers
      # openbox
      obconf
      lxappearance
      tint2
    ];
  };

  programs.home-manager.enable = true;
}
