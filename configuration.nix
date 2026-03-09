# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

/*
  boot.kernelPatches = [
  {
    name = "amdgpu-ignore-ctx-privileges";
    patch = pkgs.fetchpatch {
      name = "cap_sys_nice_begone.patch";
      url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
      hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    };
  }
];
*/

  networking.hostName = "framework-hannah"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

    services.udev.extraRules = ''
      ## QinHeng
      # CH340
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1A86", ATTRS{idProduct}=="7522", MODE="0660", TAG+="uaccess"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1A86", ATTRS{idProduct}=="7523", MODE="0660", TAG+="uaccess"
      # CH341
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1A86", ATTRS{idProduct}=="5523", MODE="0660", TAG+="uaccess"
      # CH343
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1A86", ATTRS{idProduct}=="55D3", MODE="0660", TAG+="uaccess"
      # CH9102x
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1A86", ATTRS{idProduct}=="55D4", MODE="0660", TAG+="uaccess"

      ## Silabs
      # CP210x
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="10C4", ATTRS{idProduct}=="EA60", MODE="0660", TAG+="uaccess"

      ## Espressif
      # ESP32-S3 / ESP32-C3 / ESP32-C5 / ESP32-C6 / ESP32-C61 / ESP32-H2 / ESP32-P4
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="303A", ATTRS{idProduct}=="1001", MODE="0660", TAG+="uaccess"
      # ESP32-S2
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="303A", ATTRS{idProduct}=="0002", MODE="0660", TAG+="uaccess"

      ## FTDI
      # FT232BM/L/Q, FT245BM/L/Q
      # FT232RL/Q, FT245RL/Q
      # VNC1L with VDPS Firmware
      # VNC2 with FT232Slave
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0660", TAG+="uaccess"

      ## SlimeVR
      # smol slime dongle
      SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="7690", MODE="0660", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="7690", MODE="0660", TAG+="uaccess"
    '';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hannah = {
    isNormalUser = true;
    description = "Hannah Lynn Lindrob";
    extraGroups = [ "networkmanager" "wheel" "audio" "dialout" "docker" ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true; # Enables TPM emulator
    };
  };
  users.groups.libvirtd.members = ["hannah"];


  virtualisation.docker.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  security.wrappers = {
    docker-rootlesskit = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service+ep";
      source = "${pkgs.rootlesskit}/bin/rootlesskit";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gh
    steam
    gamescope-wsi
    protonup-qt
    ntfs3g
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
    # Other general flags if available can be set here.
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  services.flatpak.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}

