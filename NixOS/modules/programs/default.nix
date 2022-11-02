{ ... }:

{
  imports = [
    ./github
    ./shell
    ./terminal
    ./editor
    ./browser
    ./gpg
  ];

  programs.exa.enable = true;
}
