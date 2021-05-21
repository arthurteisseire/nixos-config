
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  programs.sway = {
    enable = true;

    wrapperFeatures.gtk = true; # so that gtk works properly
    
    extraPackages = with pkgs; [
      swaylock-effects
      swayidle
      wl-clipboard
      mako # notification daemon
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      wofi
      waybar
      brightnessctl 
      xwayland
      wdisplays
      libappindicator-gtk3
      alacritty
      kanshi
      grim
      
      dbus
      libnotify
      networkmanager_dmenu
      networkmanagerapplet
    ];

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1

      XDG_CURRENT_DESKTOP=sway
      XDG_RUNTIME_DIR=/run/user/1000
      XDG_SEAT=seat0
      XDG_SESSION_CLASS=user
      XDG_SESSION_DESKTOP=sway
      XDG_SESSION_TYPE=wayland
    '';

  };

  environment.interactiveShellInit = ''
    alias c='wl-copy'
    alias p='wl-paste'
  '';


  programs.qt5ct.enable = true;
}
