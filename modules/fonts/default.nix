{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    nerdfonts
    font-awesome
  ];
}
