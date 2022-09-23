{ ... }:

{
  services.xserver = {
    layout = "us";
    xkbVariant = "colemak";
  };
  console.useXkbConfig = true;
}
