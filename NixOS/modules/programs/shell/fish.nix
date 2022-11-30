{ ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      alias xhost="xhost +SI:localhost:root"
      source ${toString ../../../../Custom/terminal/shell.fish}
    '';
  };
}
