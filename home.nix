{ config, pkgs, inputs, ... }:


let
  modules = ./home-modules;

    enableWayland =
    drv: bin:
    drv.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/${bin} \
          --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WaylandPerMonitorScaling" \
          --add-flags "--ozone-platform=wayland"
      '';
    });

  discord-wl = enableWayland pkgs.discord "discord";
  spotify-wl = enableWayland pkgs.spotify "spotify";
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
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    blender

    starship
    alacritty
    discord-wl
    fastfetch
    appimage-run
    moonlight-qt
    parsec-bin
    dotnetCorePackages.sdk_9_0_1xx-bin
    opencode

    ##These are boken right now :(
    #inputs.kwin-effects-glass.packages.${pkgs.stdenv.hostPlatform.system}.default # for KDE Wayland
    #inputs.kwin-effects-glass.packages.${pkgs.stdenv.hostPlatform.system}.x11 # for KDE X11
    inputs.nixos-splash-plasma6.packages.${pkgs.stdenv.hostPlatform.system}.default

    nixfmt

    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    kdePackages.krdc
    catppuccin-kvantum
    prismlauncher
    itgmania

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
    gimp
    xonotic

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
    wayvr
    xrizer
  ];

  programs.git = {
    enable = true;
    settings.user.name = "HannahPadd";
    settings.user.email = "hannah@lindrob.nl";
    settings.init.defaultBranch = "main";
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

  home.file.".config/opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    "model" = "ollama/gemma4:26b";
    "provider" = {
      "ollama" = {
        "npm" = "@ai-sdk/openai-compatible";
        "name" = "Remote Ollama Server";
        "options" = {
          "baseURL" = "http://192.168.1.162:11434/v1";
        };
        "models" = {
          "qwen3.6:27b" = { "name" = "Qwen 3.6 (27B)"; };
          "gemma4:31b" = { "name" = "Gemma 4 (31B)"; };
          "qwen3.6:latest" = { "name" = "Qwen 3.6 (Latest)"; };
          "qwen3.5:27b" = { "name" = "Qwen 3.5 (27B)"; };
          "gemma4:26b" = { "name" = "Gemma 4 (26B)"; };
          "moophlo/Qwen3-Coder-30B-A3B-Instruct-GGUF:latest" = { "name" = "Qwen3 Coder (GGUF)"; };
          "devstral:latest" = { "name" = "Devstral"; };
          "qwen2.5-coder:32b-instruct-q4_K_M" = { "name" = "Qwen 2.5 Coder (32B Q4)"; };
          "gemma3:27b-it-q8_0" = { "name" = "Gemma 3 (27B IT Q8)"; };
          "deepseek-r1:1.5b" = { "name" = "DeepSeek R1 (1.5B)"; };
          "qwen3.5:latest" = { "name" = "Qwen 3.5 (Latest)"; };
        };
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