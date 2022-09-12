{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-gtk-theme;
    };
    cursorTheme = {
      name = "Capitaine Cursors";
      package = pkgs.capitaine-cursors;
    };
  };
}
