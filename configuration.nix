{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.noctalia.nixosModules.default # system level integration
    ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    limine = {
      enable = true;
      maxGenerations = 5;
      style.wallpapers = [ pkgs.nixos-artwork.wallpapers.catppuccin-macchiato.gnomeFilePath ];
      style.interface.resolution = "1920x1080x32";
      style.interface.helpHidden = true;
      style.interface.branding = "RAMUS";
      style.interface.brandingColor = 7;
      extraConfig = "remember_last_entry: yes \n timeout: 3";
    };
  };
#  boot.plymouth = {
#    enable = true;
#    theme = "rings";
#    themePackages = with pkgs; [
#      (adi1090x-plymouth-themes.override {
#        selected_themes = [ "rings" ];
#      })
#    ];
#  };
#  boot = {
#    consoleLogLevel = 3;
#    initrd.verbose = false;
#    kernelParams = [
#      "quiet"
#      "udev.log_level=3"
#    ];
#  };

  # Networking
  networking.hostName = "ramus";
  networking.networkmanager.enable = true;

  # Locales
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Keymaps
  services.xserver.xkb = {
    layout = "es";
    variant = "nodeadkeys";
  };
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz"; # TTY
    packages = with pkgs; [ terminus_font ];
    keyMap = "es";
  };

  # Fonts
  fonts.packages = with pkgs; [ 
    nerd-fonts.jetbrains-mono 
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System profile packages
  environment.systemPackages = with pkgs; [
    wget
    git 
    pciutils
  ];

  # Define user acount.
  users.users.lucas = {
    isNormalUser = true;
    description = "lucas";
    extraGroups = [ "networkManager" "wheel" ];
  };

  # Niri
  programs.niri.enable = true;

  # Noctalia requierements
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # Default
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
  services.upower.enable = true;

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  # Extras
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
