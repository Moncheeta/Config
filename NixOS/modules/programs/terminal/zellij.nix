{ ... }:

{
  programs.zellij = {
    enable = true;
    settings = {
      ui = {
        pane_frames.rounded_corners = true;
      };
      theme = "custom";
      themes.custom = {
        fg = "#e2e2e3";
        bg = "#2c2e34";
        black = "#181819";
        red = "#fc5d7c";
        green = "#9ed072";
        yellow = "#e7c664";
        blue = "#76cce0";
        magenta = "#b39df3";
        cyan = "#f39660";
        white = "#e2e2e3";
        orange = "#f39660";
      };
    };
  };
}
