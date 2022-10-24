{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cnijfilter_4_00
    ];
  };

  programs.system-config-printer.enable = true;
}
