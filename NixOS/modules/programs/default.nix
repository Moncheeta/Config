{ pkgs, ... }:

{
  imports = [
    ./github
    ./shell
    ./terminal
    ./browser
    ./gpg
    ./desktop
  ];

  programs.exa.enable = true;
}
