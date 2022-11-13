{ ... }:

{
  programs.fish = {
    enable = true;
    shellInit = "source $CONFIG_DIR/Custom/shell.fish";
  };
}
