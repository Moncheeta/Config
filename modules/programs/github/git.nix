{ ... }:

{
  programs.git = {
    enable = true;
    difftastic = {
      enable = false;
      color = "always";
    };
    lfs.enable = true;
    userEmail = "monkey.damianek@gmail.com";
    userName = "Moncheeta";
  };
}
