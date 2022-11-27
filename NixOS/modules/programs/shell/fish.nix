{ ... }:

{
  programs.fish = {
    enable = true;
    shellInit = "source ${toString ../../../../Custom/shell.fish}";
  };
}
