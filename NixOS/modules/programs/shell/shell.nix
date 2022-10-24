{ pkgs, ... }:

{
  # This file determines the default shell
  users.users.moncheeta.shell = pkgs.fish;
}
