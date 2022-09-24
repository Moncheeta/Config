{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings.editor = "nvim";
    extensions = with pkgs; [
      gh-notify
      gh-dash
      gh-f
      gh-s
      gh-eco
      gh-install
      gh-branch
      gh-screensaver
    ]
  };
}
