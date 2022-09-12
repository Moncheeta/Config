{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 10;
    };
    settings = {
      cursor_shape = "block";

      scrollback_lines = 10000;

      enable_audio_bell = "no";

      hide_window_decorations = "yes";

      background = "#191919";
      foreground = "#c4c4b5";

      cursor = "#f6f6ec";
      selection_foreground = "#191919";
      selection_background = "#343434";

      # dull black
      color0 = "#191919";
      # light black
      color8 = "#615e4b";

      # dull red
      color1 = "#f3005f";
      # light red
      color9 = "#f3005f";

      # dull green
      color2 = "#97e023";
      # light green
      color10 = "#97e023";

      # yellow
      color3 = "#fa8419";
      # light yellow
      color11 = "#dfd561";

      # blue
      color4 = "#9c64fe";
      # light blue
      color12 = "#9c64fe";

      # magenta
      color5 = "#f3005f";
      # light magenta
      color13 = "#f3005f";

      # cyan
      color6 = "#57d1ea";
      # light cyan
      color14 = "#57d1ea";

      # dull white
      color7 = "#c4c4b5";
      # bright white
      color15 = "#f6f6ee";
    };
  };
}
