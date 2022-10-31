{ config, pkgs, ... }:

{
  imports = [
    # configuration.nix takes care of basics
    ./modules/boot
    ./modules/programs/shell/shell.nix
    ./modules/services/audio.nix
    ./modules/peripherals
    ./modules/services/networking.nix

    # Also some specific to configuration.nix
    ./modules/desktop
  ];

  nixpkgs.config.allowUnfree = true;

  # For minecraft over lan to work
  networking.firewall.enable = false;

  # to fix home-manager
  programs.dconf.enable = true;

  # fixes blueman
  services.gnome.at-spi2-core.enable = true;

  # fixes swaylock
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
    '';
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

  environment.systemPackages = with pkgs; [
    nix-index # for nix-locate and other useful programs
    efibootmgr
    killall
    wget
    gparted
    glibc
    gcc
    cmake
    gnumake
    automake
    git
  ];

  system.stateVersion = "22.11";
}
