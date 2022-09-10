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
    ../desktop/windowManagers/openbox/rofi.nix
    ../themes/gtk.nix
  ];
}
