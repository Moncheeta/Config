{ ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "ls -A --color=always";
      ll = "ls -lA --color=always";
      cp = "cp -v";
      rm = "trash";
      top = "btop";
      bat = "bat -n";
      cat = "bat -n";
      fm = "xplr";
      f = "fzf";
      cls = "clear";
      ping = "pingu";
      find = "fd";
      disk = "lfs";
      pause = "read -n1 -r -p 'Press any key to continue...'";
      fetch = "PF_INFO='ascii title os kernel memory' pfetch";
      clock = "peaclock";
      syn = "cava"; # visual music
      lock = "swaylock --fade-in 1 --screenshots --effect-blur 5x3 -u";
      reboot = "systemctl reboot";
      shut = "poweroff";
      mut = "zellij";
      mat = "cmatrix";

      clone = "gh repo clone";
      commit = "git commit";
      push = "git push";
      merge = "git merge";
      rebase = "git rebase";
      repo = "gh repo";
      add = "git add";
      stat = "git status";
      gstatus = "gh status";
      fork = "gh repo fork";
      pr = "gh pr";
      issue = "gh issue";
      release = "gh release";

      mail = "himalaya";
      mark = "glow";
      spot = "spotify";
      wttr = "curl wttr.in";
    };
    shellInit = ''
      source $NIXOS_CONFIG_DIR/modules/scripts/himalaya.fish
      zoxide init fish | source
      sleep 0.1
      PF_INFO='ascii title os kernel memory' pfetch
    '';
  };
}
