{ config, pkgs, inputs, ... }:


let
  modules = ./home-modules;
in
{
  imports = [
    (modules + /shell.nix)
    (modules + "/quickshell.nix")
    ./plasma.nix
  ];

  home.username = "hannah";
  home.homeDirectory = "/home/hannah";

  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    oh-my-zsh
    nerd-fonts.jetbrains-mono 
    librewolf
    thunderbird

    blender

    starship
    alacritty
    discord
    fastfetch

    inputs.kwin-effects-glass.packages.${pkgs.system}.default # for KDE Wayland
    inputs.kwin-effects-glass.packages.${pkgs.system}.x11 # for KDE X11
    inputs.nixos-splash-plasma6.packages.${pkgs.system}.default

    nixfmt

    jetbrains.idea-oss
    neovim
    obsidian
    spotify
    steam
    tmux
    vim
    vscode
    wget
    zsh
    hyfetch

    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder


    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    direnv
  ];

  programs.git = {
    enable = true;
    userName = "HannahPadd";
    userEmail = "hannah@lindrob.nl";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Underline";
        vi_mode_style = "None";
        unfocused_hollow = true;
        thickness = 0.15;
      };
      font.size = 12;
      font.normal = {
        family = "JetBrainsMono Nerd Font";
        style = "Regular";
      };
      font.bold = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold";
      };
      font.italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Italic";
      };
      font.bold_italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold Italic";
      };
      general.live_config_reload = true;
      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
        save_to_clipboard = true;
      };
      window.opacity = 0.0;
      window.blur = true;
      window.dimensions = {
        lines = 35;
        columns = 110;
      };
    };
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

}