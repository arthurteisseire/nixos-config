# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t470s>
      ./hardware-configuration.nix
      ./my_sway.nix
      ./my_i3.nix
    ];

  # Use the systemd-boot EFI boot loader.

#  boot.loader.systemd-boot.enable = true; # (for UEFI systems only)
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
 
    grub = {
      devices = [ "nodev" ];
      enable = true;
      efiSupport = true;
      version = 2;
      useOSProber = true;
    };
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp58s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Print
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
	hardware = {
    pulseaudio = {
      enable = true;
    };
    bluetooth = {
      enable = true;
    };
  };

  services.blueman.enable = true;
  services.fstrim.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users = { 
    mutableUsers = true;
    defaultUserShell = pkgs.zsh; # Make zsh default shell
    users = {
      arthur = {
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "docker" "video" ];
      };
    };
  };

  programs.steam.enable = true;
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    pipewire

    # Softs
    git
    git-secret
    wget
    vim_configurable
    alacritty
    gammastep
    firefox
    chromium
    google-chrome
    pavucontrol
    htop
    zip
    unzip
    tree
    gimp
    tdesktop
    smartgithg
    slack
    gparted
    blender
    cgoban
    qdirstat
    transmission
    ntfs3g

    nix-prefetch
    nix-prefetch-git
    direnv
    nix-direnv

    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance

    zsh
    oh-my-zsh

    # unfree
    (jetbrains.idea-ultimate.override { jdk = pkgs.jetbrains.jdk; })
    (jetbrains.clion.override { jdk = pkgs.jetbrains.jdk; })
    (jetbrains.pycharm-community.override { jdk = pkgs.jetbrains.jdk; })
    teams
    postman
    obs-studio
    handbrake
  ];
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;

  programs.vim.defaultEditor = true;

  # Enable zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      s = "git status";
      config = "vim ~/.config/sway/config";
      i3config = "vim ~/.config/i3/config";
      pconfig = "vim ~/.config/nixpkgs/config.nix";
      gconfig = "vim /etc/nixos/configuration.nix";
      sconfig = "vim /etc/nixos/my_sway.nix";
      i3exit = "~/.config/i3/i3exit";
    };
  };

  # Enable Oh-my-zsh
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" "docker" "kubectl" ];
    theme = "robbyrussell";
  }; 

  fonts.fonts = with pkgs; [
    font-awesome
    cantarell-fonts
  ];

  # For nix direnv
	nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  environment.pathsToLink = [ "/share/nix-direnv" ];

	environment.interactiveShellInit = ''
		eval "$(direnv hook zsh)"
  '';


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
  system.stateVersion = "22.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

}

