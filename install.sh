#!/usr/bin/env bash

useNix=true

current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
dotfiles_source="${current_dir}/config"

echo "Cloning neovim configuration..."
git clone https://github.com/mhirii/lazyvim $HOME/.config/nvim
nvim -c
echo "Neovim configuration has been cloned."

echo "Cloning tmux configuration..."
git clone https://github.com/mhirii/tmux $HOME/.config/tmux
nvim -c
echo "Tmux configuration has been cloned."

echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Tmux plugin manager has been cloned."

if [ "$useNix" = false ]; then
  echo "Installing neovim..."
  source ./scripts/neovim.sh
  echo "Neovim installation has finished."
else
  echo "Evaluating the nix dev-shell..."
  cd ./scripts/ && nix develop || exit 0
  echo "The dev shell was installed successfully"
fi
