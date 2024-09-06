#!/usr/bin/env bash

current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
dotfiles_source="${current_dir}/scripts"

echo "Cloning neovim configuration..."
git clone https://github.com/mhirii/lazyvim "$HOME"/.config/nvim
nvim -c
echo "Neovim configuration has been cloned."

echo "Cloning tmux configuration..."
git clone https://github.com/mhirii/tmux "$HOME"/.config/tmux
nvim -c
echo "Tmux configuration has been cloned."

echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Tmux plugin manager has been cloned."

if [ "$useNix" = true ]; then
  echo "Evaluating the nix dev-shell..."
  cd "$dotfiles_source" && nix develop "$HOME" || exit 0
  echo "The dev shell was installed successfully"
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
