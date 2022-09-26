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
  programs.himalaya.enable = true;

  accounts.email.accounts = {
    gmail = servers.gmail // {
      realName = "Moncheeta";
      primary = true;
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        remove = "both";
        subFolders = "Maildir++";        
      };
      himalaya.enable = true;
      imapnotify = {
        enable = true;
        onNotify = "\${pkgs.isync}/bin/mbsync";
        onNotifyPost = {
          mail = "\${pkgs.libnotify}/bin/notify-send 'Mail Arrived'";
        };
      };
      address = "monkey.damianek@gmail.com";
      userName = "monkey.damianek@gmail.com";
      passwordCommand = "pass show gmail";
    };
  };
}
