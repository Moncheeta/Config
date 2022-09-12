{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./kernal.nix
    ./cpu.nix
    ./gpu.nix
    ./drives.nix
  ];
}
