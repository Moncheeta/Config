{ ... }:

{
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock"; }
    ];
    timeouts = [
      { timeout = 120; command = "swaylock"; }
    ];
    systemdTarget = "hyprland-session.target";
  };
}
