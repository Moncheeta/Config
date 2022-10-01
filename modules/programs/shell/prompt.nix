{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      directory.style = "blue";

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "~";
        untracked = "*";
        modified = "⇣";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_metrics = {
        format = "[+$added](green)/[-$deleted](red) ";
      };

      format = "$username\$hostname\$directory\$git_branch\$git_status\$git_metrics\$line_break\$character";
    };
  };
}
