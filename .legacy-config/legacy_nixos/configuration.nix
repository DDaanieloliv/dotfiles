# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

# Home-manager NixOS module Instalation.
#
# let
#  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
# in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # (import "${home-manager}/nixos")
    ];

# home-manager = {
#   useUserPackages = true;     # Usa pacotes do usuário (recomendado para NixOS)
#   useGlobalPkgs = true;       # Usa os pacotes do sistema (evita duplicação)
#   backupFileExtension = "bk"; # Altera a extensão do backup para ".bk" (opcional)
#   users.daniel = import ./home.nix;
# };



  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Recife";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      accelProfile = "adaptive";
      scrollMethod = "twofinger";  # Corrigido: sem hífen
    };
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
        pygobject3  # Para suporte a ícones
      ];
    };
    displayManager.sessionCommands = ''
      xwallpaper --zoom ~/Downloads/3y5ptawmvr081.jpg
      xset r rate 200 35 &
    '';
  };

  #programs.hyprland = {
  #  enable = true;
  #  package = (pkgs.hyprland.override {
  #    enableXWayland = true;   # Habilita XWayland (para apps X11)
  #    legacyRenderer = true;   # Força renderizador legado (evita tela preta em GPUs antigas)
  #    withSystemd = true;      # Suporte a systemd (recomendado)
  #  });
  #  xwayland.enable = true;    # Habilita XWayland no módulo também
  #};

  # hardware.opengl = {
  #   enable = true;
  #   extraPackages = with pkgs; [mesa];
  # };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable SDDM instead GDM.
  # services.xserver.displayManager.sddm.enable = true;

  # Enable grafic drives to 'picon'.
  # hardware.opengl.enable = true;
  hardware.graphics.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };


  # Configure console keymap
  console.keyMap = "br-abnt2";

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  tree
    ];
  };

 #fonts.packages = with pkgs; [
 #  nerd-fonts.fira-code
 #  nerd-fonts.hack
 #  nerd-fonts.jetbrains-mono
 #
 #  # Font Awesome para ícones específicos
 #  font-awesome
 #];

  # Install firefox.
  programs.firefox.enable = true;

  # Install picom.
  services.picom = {
    enable = true;
    backend = "xrender";
    fade = true;
    shadow = true;
    vSync = true;
    settings = {
     #corner-radius = 12;  # Tamanho do arredondamento (em pixels)
     #rounded-corners-exclude = [
     #"class_g = 'Polybar'"  # Exclua elementos que não devem ser arredondados
     #"class_g = 'Dunst'"       # Notificações
     #"class_g = 'Rofi'"        # Lançador de aplicativos
     #"class_g = 'peek'"        # Gravador de tela
     #"name *= 'rectangular'"   # Qualquer janela com "rectangular" no nome
     #"class_g = 'qtile'"
     #];
      shadow-radius = 12;
      shadow-offset-x = -12;
      shadow-offset-y = -12;
      shadow-opacity = 0.3;
      fading = true;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      opacity-rule = [
        "90:class_g = 'Alacritty'"
        "90:class_g = 'Rofi'"
      ];
    };
  };

  # Install hyprland.
  # programs.hyprland.enable = true;


  # Globally install the Flatpack service.
  services.flatpak.enable = true;
  xdg.portal.enable = true;        # Necessário para integração com apps GUI
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  # Escolha GTK ou KDE

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    btop
    alacritty
    neofetch
    pfetch
    tree
    xwallpaper
    pcmanfm
    rofi
    pulseaudio
    mesa-demos
    pciutils      # fornece lspci
    systemd
    cava
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;  # Recomendado desativar login por senha
      PermitRootLogin = "no";          # Segurança adicional
    };
  };

  # nixpkgs.config.cmus.full = true;  # Instala com todos os codecs


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
  system.stateVersion = "25.05"; # Did you read the comment?

}
