{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings.editor = "nvim";
    extensions = with pkgs; [
      gh-eco
    ];
  };
}
