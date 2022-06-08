# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true; 
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Europe/Lisbon";
  location.provider = "geoclue2";

  networking = {
    hostName = "tardis"; 
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      xkbOptions = "ctrl:swapcaps";
      libinput.enable = true; # Enable touchpad support.
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce+i3";
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        configFile = ./i3config;
        extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock #default i3 screen locker
        ];
      };
      layout = "pt";
    };
    gnome.gnome-keyring.enable = true;
    tlp.enable = true;
    acpid.enable = true;
    printing.enable = true;
    blueman.enable = true;
    openssh.enable = true;
  };

  # Enable sound.
  sound = {
    enable = true;
    mediaKeys.enable = true;
    mediaKeys.volumeStep = "5%";
  };

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
	    '';
    };
    bluetooth = {
      enable = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      driSupport = true;
    };
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  nixpkgs.config.pulseaudio = true; # Explicit PulseAudio support in applications
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.herulume = {
    isNormalUser = true;
    home = "/home/herulume";
    shell = pkgs.bash;
    extraGroups = [ "wheel" "networkmanager" "audio" "lp" "docker" "video" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    shared-mime-info
  ];

  programs.dconf.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable Docker support.
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    cantarell-fonts
  ];


  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
