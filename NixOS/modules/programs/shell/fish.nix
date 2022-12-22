{ ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      alias xhost="xhost +SI:localhost:root"
      source ${toString ./config.fish}
    '';
  };
}
