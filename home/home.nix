{ config, pkgs, ... }:

{
  imports = (import ./programs) ++ (import ./services);
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "herulume";
  home.homeDirectory = "/home/herulume";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    vlc
    ispell
    feh
    firefox
    neofetch
    discord
    neovim
    spotify
    portfolio
    unzip
    elixir_ls
    libvterm
    _1password-gui
    zoom-us
    lutris
    openssl
    gnome.zenity
    steam
    slack
    deluge
    zip
  ];

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
    ];
  };

  programs.firefox.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableBashIntegration = true;

}
