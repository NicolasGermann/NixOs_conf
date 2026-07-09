# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
  cfg = builtins.fromTOML (builtins.readFile ./packages.toml);
  
in{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.xremap-flake.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.initrd.availableKernelModules = ["thunderbolt" "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "evdev"];
  services.hardware.bolt.enable = true;
  boot.initrd.systemd.enable = true;
  hardware.keyboard.qmk.enable = true;


  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };


  #Enable Ly
  services.displayManager.ly.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "mac";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.flatpak.enable = true;


services.xremap = {
  enable = true;
};

services.xremap.config.modmap = [
  {
    name = "Global";
    remap = { "CapsLock" = "Control_L"; }; # globally remap CapsLock to Esc
  }
];

services.xremap.config.keymap = [
  {
    name = "Windows-Style Ctrl+Alt fuer deutsches Tastaturlayout";
    remap = {
      # @-Zeichen (Strg + Alt + Q)
      "C-M-q" = "Alt_R-q";
      
      # Euro-Zeichen (Strg + Alt + E)
      "C-M-e" = "Alt_R-e";

      # Geschweifte Klammer auf '{' (Strg + Alt + 7)
      "C-M-7" = "Alt_R-7";
      
      # Eckige Klammer auf '[' (Strg + Alt + 8)
      "C-M-8" = "Alt_R-8";
      
      # Eckige Klammer zu ']' (Strg + Alt + 9)
      "C-M-9" = "Alt_R-9";
      
      # Geschweifte Klammer zu '}' (Strg + Alt + 0)
      "C-M-0" = "Alt_R-0";
      
      # Backslash '\' (Strg + Alt + ß-Taste)
      # Die physikalische ß-Taste wird von xremap als 'minus' erkannt.
      "C-M-minus" = "Alt_R-minus";
      
      # Tilde '~' (Strg + Alt + +-Taste rechts neben Ü)
      # Die physikalische +-Taste wird von xremap als 'equal' erkannt.
      "C-M-equal" = "Alt_R-equal";

      # Pipe-Symbol '|' (Strg + Alt + <-Taste links neben Y)
      # Die Taste für < > | wird von xremap als '102nd' erkannt.
      "C-M-102nd" = "Alt_R-102nd";
      
      # Mü-Zeichen 'µ' (Strg + Alt + M)
      "C-M-m" = "Alt_R-m";
    };
  }
];

  # Enable bluetooth
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = true;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};

  hardware.graphics.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."nicolasg" = {
    isNormalUser = true;
    description = "Nicolas Germann";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  services.upower.enable = true;
  # Install firefox.
  programs.firefox.enable = true;

  programs.niri.enable = true;
  programs.dms-shell.enable = true;
  programs.dms-shell.enableSystemMonitoring = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    builtins.map (name: pkgs.${name}) cfg.packages;
  programs.niri.useNautilus = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
