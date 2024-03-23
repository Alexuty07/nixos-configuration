{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader (UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS devices
  boot.initrd.luks.devices."luks-1ec6d49d-7a0b-4ac9-aaea-e8efc1c75ac0".device = "/dev/disk/by-uuid/1ec6d49d-7a0b-4ac9-aaea-e8efc1c75ac0";

  # Autoupgrade
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-unstable";
  };

  # Garbage collection
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Hostname
   networking.hostName = "nixos";

  # KDE Partition Manager
  programs.partition-manager.enable = true;

  # zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  # WLAN
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # i18n
  time.timeZone = "America/New_York";
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

  # X11
  services.xserver.enable = true;

  # Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Automatic login (to avoid entering a second pasword)
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "alexuty";

  # Keyboard settings (xkb)
  services.xserver.xkb = {
    layout = "us,es";
    options = "eurosign:e/*,compose:rctl*/,grp:win_space_toggle";
  };

  # CUPS
  services.printing.enable = true;

  # Pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Touchpad support
  services.xserver.libinput.enable = true;

  # Virtualization with virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # User account. Set a password with ‘passwd’
  users.users.alexuty = {
    isNormalUser = true;
    description = "Alex Santiago";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      anki-bin
      audacity
      electron-mail
      gimp
      gitkraken
      kate
      kdenlive
      keepassxc
      libqalculate
      libreoffice
      librewolf
      monero-gui
      obsidian
      protonvpn-gui
      qalculate-qt
      qbittorrent-qt5
      retroarch
      signal-desktop
      steam
      tailscale-systray
      telegram-desktop
      vesktop
      vlc
      waydroid
      ytmdesktop
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    android-tools
    filelight
    fortune-kind
    git
    htop
    hyfetch
    kdePackages.kdeconnect-kde   
   #libsForQt5.kdeconnect-kde
    logitech-udev-rules
    meslo-lgs-nf
    microcodeIntel
    neofetch
    nerdfonts
    nfs-utils
    papirus-icon-theme
    qemu_full
    qmk
    syncthing
    syncthingtray
    solaar
    tailscale
    tldr
    unipicker
    wget
    xclip
    yakuake
    zsh
    zsh-powerlevel10k
  ];

  # OpenSSH daemon
  services.openssh.enable = true;

  system.stateVersion = "23.11";

}
