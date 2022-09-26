{ ... }:

let
  servers = {
    gmail = {
      imap = {
        host = "imap.gmail.com";
    	port = 993;
    	tls.enable = true;
      };
      smtp = {
        host = "smtp.gmail.com";
    	port = 465;
    	tls.enable = true;
      };
    };
  };
in
{
  programs.himalaya = {
    enable = true;
    settings.name = "Damian Myrda";
    settings.notify-query = "not seen";
  };

  systemd.user.services = { 
    mail-notify = {
      Unit = {
        Description = "Himalaya Notification Service";
        After = "network.target";
      };
      Service = {
        ExecStart = "himalaya notify";
        Restart = "always";
        RestartSec = 10;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  accounts.email.accounts = {
    gmail = servers.gmail // {
      realName = "Moncheeta";
      primary = true;
      himalaya = {
        enable = true;
      };
      address = "monkey.damianek@gmail.com";
      userName = "monkey.damianek@gmail.com";
      passwordCommand = "pass show gmail";
    };
  };
}
