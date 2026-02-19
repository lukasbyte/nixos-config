{ config, pkgs, inputs, ... }: {
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    package = null;
  };
}
