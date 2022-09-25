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
      cls = "clear";
      find = "fd";
      spot = "spotify";
      disk = "lfs";
      pause = "read -n1 -r -p 'Press any key to continue...'";
      fetch = "PF_INFO='ascii title os kernel memory pkgs' pfetch";
      clock = "peaclock";
      restart = "reboot";
      shut = "shutdown now";

      clone = "gh repo clone";
      commit = "git commit";
      push = "git push";
      merge = "git merge";
      rebase = "git rebase";
      repo = "gh repo";
      add = "git add";
      stat = "gh status";
      fork = "gh repo fork";
      pr = "gh pr";
      issue = "gh issue";
      release = "gh release";

      mail = "himalaya";
      mark = "glow";
    };
    shellInit = ''
      PF_INFO='ascii title os kernel memory pkgs' pfetch
    '';
  };
}
