#!/usr/bin/env bash

set -euo pipefail

export ROOTDIR="$HOME/.furnisher"
export CACHEDIR="$HOME/.cache/furnisher"

mkdir -p $CACHEDIR
[[ -d $ROOTDIR ]] || git clone https://github.com/stellarhoof/furnisher $ROOTDIR
cd $ROOTDIR

if [[ ! -f "$CACHEDIR/repo-setup" ]]; then
    GITPREFIX="git@github.com:stellarhoof"
	git remote set-url origin $GITPREFIX/furnisher.git
	git submodule update --init
	git submodule update --remote
	git config submodule.st.url $GITPREFIX/st.git
	git config submodule.pass.url $GITPREFIX/pass.git
	git config submodule.fzf.vim.url $GITPREFIX/fzf.vim.git
	git config submodule.home-manager.url $GITPREFIX/home-manager.git
    touch "$CACHEDIR/repo-setup"
fi

OSNAME=""
if [[ "$OSTYPE" == linux* ]]; then
	OSNAME=$(grep -oP '^NAME="\K\w+' /etc/OSNAME-release | tr '[:upper:]' '[:lower:]')
elif [[ "$OSTYPE" == darwin* ]]; then
	OSNAME="darwin"
fi
[[ -d "machines/$OSNAME" ]] || (echo "Unsupported operating system $OSNAME" && exit 1)

[[ -d /nix/store ]] || curl https://nixos.org/nix/install | sh
source "$HOME/.nix-profile/etc/profile.d/nix.sh"

NIXCONFDIR="$HOME/.config/nixpkgs"
mkdir -p $NIXCONFDIR
ln -sf "$ROOTDIR/machines/$OSNAME/default.nix" "$NIXCONFDIR/home.nix"

hash home-manager || nix-shell "gitmodules/home-manager/default.nix" -A install

./post-install.sh

echo "Done. All that's left is to:
- Change your login shell
- Log back in"
