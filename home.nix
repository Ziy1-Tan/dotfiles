{ pkgs, ... }:

{
  # This is the Home Manager data format version, not the nixpkgs version.
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  home.backupFileExtension = "hm-bak";

  # Nix owns the command-line tools. Plugin and runtime managers continue to
  # own their respective plugins and Node versions.
  home.packages = with pkgs; [
    zsh
    vim
    tmux
    git
    curl
    alacritty
    fzf
    fd
    zoxide
    bun
    zinit
  ];

  home.file = {
    # vim-plug remains the owner of Vim plugins. Nix only supplies the manager
    # entrypoint, so the existing vimrc can keep its Plug declarations.
    ".vim/autoload/plug.vim".source = "${pkgs.vimPlugins.vim-plug}/plug.vim";

    # zinit remains the owner of zsh plugins. Home Manager exposes its
    # entrypoint from the immutable Nix package; zinit itself still downloads
    # its plugins.
    ".zinit.zsh".source = "${pkgs.zinit}/share/zinit/zinit.zsh";

    ".zshrc".source = ./zshrc;
    ".zprofile".source = ./zprofile;
    ".vimrc".source = ./vimrc;
    ".tmux.conf".source = ./tmux.conf;
    ".gitconfig".source = ./gitconfig;
    ".ssh/config".source = ./.ssh/config;
  };

  xdg.configFile = {
    "zsh/alias.zsh".source = ./config/zsh/alias.zsh;
    "zsh/env.zsh".source = ./config/zsh/env.zsh;
    "zsh/fzf.zsh".source = ./config/zsh/fzf.zsh;
    "zsh/prompt.zsh".source = ./config/zsh/prompt.zsh;
    "alacritty/alacritty.toml".source =
      ./config/alacritty/alacritty.toml;
  };
}
