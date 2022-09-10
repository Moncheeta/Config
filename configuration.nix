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

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  security.doas = {
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
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
    };

    systemPackages = with pkgs; [
      nix-index # for nix-locate and other useful programs
      killall
      tldr
      wget
      pass
      gcc
      gnumake
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
