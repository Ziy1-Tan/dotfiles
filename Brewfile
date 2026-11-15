# GUI casks only when the install script exports DOTFILES_GUI=1.
# brew bundle has no lock file; versions track upstream.

brew "fzf"
brew "fd"
brew "ripgrep"
brew "zoxide"
brew "tlrc"
brew "tmux"

brew "dockutil" if OS.mac?

if OS.mac? && ENV["DOTFILES_GUI"] == "1"
  cask "ghostty"
  cask "raycast"
  cask "rectangle"
  cask "hiddenbar"
  cask "maccy"
  cask "snipaste"
  cask "itsycal"
  cask "betterdisplay"
  cask "obsidian"
  cask "font-fira-code-nerd-font"
  cask "font-sauce-code-pro-nerd-font"
  cask "font-google-sans-code"
end
