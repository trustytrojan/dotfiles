# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.extraModprobeConfig = ''
    blacklist raydium_i2c_ts
  '';

  fileSystems."/mnt/safe_place".device = "/dev/nvme0n1p4";
  fileSystems."/home".device = "/dev/nvme0n1p6";

  networking = {
    hostName = "p14s-nixos";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.t = {
    isNormalUser = true;
    description = "t";
    extraGroups = [ "networkmanager" "wheel" "video" "corectrl" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    grim
    slurp
    pavucontrol
    sof-firmware
    qpwgraph
    brightnessctl
    gammastep
    git
    waybar
    nvtop
    vscode
    polkit_gnome
    gparted
    parted
    ventoy
    xorg.xlsclients
    vesktop
    gnome.gnome-tweaks
    gnome.gnome-themes-extra
    dex
    ntfs3g
    fastfetch
    lshw
  ];

  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.corectrl.enable = true;
  services.gnome.gnome-keyring.enable = true;
  xdg.portal.wlr.enable = true;

  programs.sway = {
    package = pkgs.swayfx;
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock-effects swayidle foot wofi grim slurp wl-clipboard mako
    ];
  };

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
      highlight_changes = true;
      highlight_changes_delay_secs = 1;
      delay = 10;
      tree_view = true;
      highlight_base_name = true;
      color_scheme = 6;
    };
  };

  fonts = {
    packages = with pkgs; [
      liberation_ttf
      font-awesome
      iosevka-bin
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.fprintd.enable = true;

  programs.bash = {
    promptInit = ''
        # Color/style escape sequences
        bold() { echo $'\e[1;'$1'm'; }
        RESET=$'\e[0m'
        CYAN=$(bold 36)
        RED=$(bold 31)
        WHITE=$(bold 37)
        BLUE=$(bold 34)

        # Red username and `#` are reserved for root
        if [ $UID = 0 ]; then
                USER_COLOR=$RED
                PROMPT_CHAR=\#
        else
                USER_COLOR=$WHITE
                PROMPT_CHAR=\$
        fi

	# Colored prompt
        PS1="$CYAN[ $USER_COLOR\u$RESET@\H $BLUE\W $CYAN]$RESET$PROMPT_CHAR "
	unset bold RESET CYAN RED WHITE BLUE USER_COLOR PROMPT_CHAR
    '';
    shellAliases = {
      "ls" = "ls --color=auto";
      "ll" = "ls -lh";
      "la" = "ll -a";
      "ip" = "ip -c";
      "du" = "du -hd1";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
	enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:0:2";
      nvidiaBusId = "PCI:0:1:0";
    };
  };

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
  system.stateVersion = "24.05"; # Did you read the comment?
}
