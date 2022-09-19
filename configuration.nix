{ config, pkgs, ... }:

{
  imports = [
    # configuration.nix takes care of basics
    ./modules/boot
    ./modules/programs/shell/shell.nix
    ./modules/audio
    ./modules/peripherals
    ./modules/network

    # Also some specific to configuration.nix
    ./modules/desktop
    ./modules/fonts
  ];

  nixpkgs.config.allowUnfree = true;

  # For minecraft over lan to work
  networking.firewall.enable = false;

  # to fix home-manager
  programs.dconf.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      trusted-users = [ "moncheeta" ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 1d";
    };
  };

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.moncheeta = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = "Damian Myrda";
    createHome = true;
    home = "/home/moncheeta";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "lp" "scanner" "tty" "input" ];
  };

  environment = {
    variables = {
      NIXOS_CONFIG_DIR = "\${HOME}/Configs";

      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";

      XDG_CACHE_HOME  = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME    = "\${HOME}/.local/bin";
      XDG_DATA_HOME   = "\${HOME}/.local/share";
      # Steam needs this to find Proton-GE
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

      PATH = [
        "\${XDG_BIN_HOME}"
      ];
    };

    systemPackages = with pkgs; [
      nix-index # for nix-locate and other useful programs
      efibootmgr
      killall
      wget
      pass
      gparted
      glibc
      gcc
      cmake
      git
    ];
  };

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.11";
  };
}
