{ pkgs, ... }:
{
  # The set of packages to appear in the user environment
  home.packages = with pkgs; [ waypipe ];
}
