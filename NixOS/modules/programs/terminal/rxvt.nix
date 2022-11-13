{ ... }:

{
  programs.urxvt = {
    enable = true;
    fonts = [
      "xft:JetBrainsMono Nerd Font:size=10"
    ];
    keybindings = {
      "Control-Shift-C" = "eval:selection_to_clipboard";
      "Control-Shift-V" = "eval:paste_clipboard";
    };
    scroll.bar.enable = false;
  };
}
