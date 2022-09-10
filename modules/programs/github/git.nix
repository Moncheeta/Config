{ ... }:

{
  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      color = "always";
    };
    lfs.enable = true;
    userEmail = "monkey.damianek@gmail.com";
    userName = "Moncheeta";
  };
}
