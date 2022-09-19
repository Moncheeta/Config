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
      fm = "lf";
      cls = "clear";
      find = "fd";
      spot = "spotify";
      disk = "lfs";
      pause = "read -n1 -r -p 'Press any key to continue...'";
      fetch = "PF_INFO='ascii title os kernel memory pkgs' pfetch";
      clock = "peaclock";
      restart = "reboot";
      shut = "shutdown now";

      clone = "hub clone --recursive";
      commit = "hub commit";
      push = "hub push";
      merge = "hub merge";
      new = "hub create";
      add = "hub add";
      stat = "hub status";
      pullreq = "hub pull-request -e";
      pulllist = "hub pr list --color=always -o popularity";
      issue = "hub issue --color=always -e";

      cfetch = "tokei";

      mail = "himalaya";
      mark = "glow";

    };
    shellInit = ''
      PF_INFO='ascii title os kernel memory pkgs' pfetch
    '';
  };
}
