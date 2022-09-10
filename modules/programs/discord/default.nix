{ ... }:

{
  nixpkgs.overlays =
  let
    myOverlay = self: super: {
      discord = super.discord.override { withOpenASAR = true; };
    };
  in
  [ myOverlay ];
}
