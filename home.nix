{ config, pkgs, ... }:

{
  imports = [
    ./modules/home.nix
  ];

  home.username = "moncheeta";
  home.homeDirectory = "/home/moncheeta";

  home.packages = with pkgs; [
    ## Applications
    spotify
    discord
    betterdiscordctl

    ## Games
    # Minecraft
    lunar-client
    minecraft

    # Steam
    steam

    ## Command Line Programs
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

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

}
