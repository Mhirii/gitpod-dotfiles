#!/usr/bin/env bash

# set in gitpod variables [OPTIONAL]
# useNix=true or false
# NEOVIM_VERSION
# fish_shell=true or false

current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
dotfiles_source="${current_dir}/scripts"

echo "Cloning neovim configuration..."
git clone https://github.com/mhirii/lazyvim "$HOME"/.config/nvim
echo "Neovim configuration has been cloned."

echo "Cloning tmux configuration..."
git clone https://github.com/mhirii/tmux "$HOME"/.config/tmux
echo "Tmux configuration has been cloned."

echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Tmux plugin manager has been cloned."

# set useNix in gitpod variables
if [ "$useNix" = true ]; then
  echo "Evaluating the nix dev-shell..."
  nix develop $current_dir
  echo "The dev shell was installed successfully"

  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install

else

  echo "Installing neovim..."
  cd $(mktemp -d) || exit 0
  URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
  if test -n "$NEOVIM_VERSION"; then
    URL="https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim.appimage"
  fi
  curl -LO "$URL"
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract >/dev/null
  mkdir -p /home/gitpod/.local/bin
  ln -s "$(pwd)"/squashfs-root/AppRun /home/gitpod/.local/bin/nvim
  cd "$HOME" || exit 0
  echo "Neovim installation has finished."
fi

echo " abbr v 'nvim'; abbr lg 'lazygit'; abbr lzd 'lazydocker'; abbr t 'tmux'; abbr tns 'tmux new-session -s'; abbr ta 'tmux attach'; abbr tls 'tmux list-sessions'; abbr tks 'tmux kill-session -t'; " >>"$HOME"/.config/fish/config.fish
echo "fish_vi_key_bindings" >"$HOME"/.config/fish/config.fish
