#!/usr/bin/env bash

set -euo pipefail

export ROOTDIR="$HOME/.furnisher"
export CACHEDIR="$HOME/.cache/furnisher"

mkdir -p $CACHEDIR
[[ -d $ROOTDIR ]] || git clone https://github.com/stellarhoof/furnisher $ROOTDIR
cd $ROOTDIR

if [[ ! -f "$CACHEDIR/repo-setup" ]]; then
    GITPREFIX="git@github.com:stellarhoof"
    setRemote () {
        remote="$GITPREFIX/$1.git"
        git config submodule.$1.url $remote
        git -C "gitmodules/$1" remote set-url origin $remote
    }
    git remote set-url origin $GITPREFIX/furnisher.git
    git submodule update --init
    git submodule update --remote
    setRemote st
    setRemote pass
    setRemote fzf.vim
    touch "$CACHEDIR/repo-setup"
fi

OSNAME=""
if [[ "$OSTYPE" == linux* ]]; then
    OSNAME=$(grep -oP '^NAME="\K\w+' /etc/OSNAME-release | tr '[:upper:]' '[:lower:]')
elif [[ "$OSTYPE" == darwin* ]]; then
    # TODO: select doesn't work on bash < 4, which is the default installed on
    # mac os
    echo "You will need to follow the instructions on https://github.com/NixOS/nix/issues/3125 before proceeding"
    echo "Do you wish to proceed?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No ) exit;;
        esac
    done
    OSNAME="darwin"
fi
[[ -d "machines/$OSNAME" ]] || (echo "Unsupported operating system $OSNAME" && exit 1)

[[ -d /nix/store ]] || curl https://nixos.org/nix/install | sh
source "$HOME/.nix-profile/etc/profile.d/nix.sh"

NIXCONFDIR="$HOME/.config/nixpkgs"
mkdir -p $NIXCONFDIR
ln -sf "$ROOTDIR/machines/$OSNAME/default.nix" "$NIXCONFDIR/home.nix"

hash home-manager || nix-shell "<home-manager>" -A install

# Running a different script to use nix-shell as an interpreter and make an
# environment with various needed tools installed
./post-install.sh
