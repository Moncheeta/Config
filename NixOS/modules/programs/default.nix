{ ... }:

{
  imports = [
    ./github
    ./discord
    ./shell
    ./terminal
    ./editor
    ./browser
    ./gpg
  ];

  programs.exa.enable = true;
}
