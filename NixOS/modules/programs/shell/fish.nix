{ ... }:

{
  programs.fish = {
    enable = true;
    shellInit = "source $CONFIG_DIR/Custom/Shell/shell.fish";
  };
}
