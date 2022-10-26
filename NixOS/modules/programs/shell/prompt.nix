{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vicmd_symbol = "[<](bold green)";
      };

      directory.style = "blue";

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_metrics = {
        format = "[+$added](green)/[-$deleted](red) ";
      };

      format = "$username\$hostname\$directory\$git_branch\$git_metrics\$line_break\$character";
    };
  };
}
