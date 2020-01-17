#!/usr/bin/env bash

set -euo pipefail

os=""
if [[ "$OSTYPE" == linux* ]]; then
	os=$(grep -oP '^NAME="\K\w+' /etc/os-release | tr '[:upper:]' '[:lower:]')
elif [[ "$OSTYPE" == darwin* ]]; then
	os="darwin"
fi
[[ ! -d ./$os ]] && echo "Unsupported OS $os" && exit 1

# Install nix
if [[ ! -d /nix/store ]]; then
	curl https://nixos.org/releases/nix/nix-2.3/install | sh
	. "~/.nix-profile/etc/profile.d/nix.sh"
fi

repodir="~/.furnisher"
passdir="$repodir/common/mutable/.local/share/pass"

# Clone and setup required repos
function setOrigin {
	git remote set-url origin git@github.com:stellarhoof/$1.git
}
if [[ ! -d $repodir ]]; then
	git clone --recurse-submodules https://github.com/stellarhoof/furnisher $repodir
	cd "$repodir" && setOrigin furnisher
	cd "$passdir" && setOrigin pass
	cd "$repodir/user/home-manager/programs/st" && setOrigin st
	cd "$repodir/common/home-manager" && setOrigin home-manager
	cd "$repodir/common/fzf.vim" && setOrigin fzf.vim
fi

cd $repodir

nixdir=~/.config/nixpkgs
mkdir -p $nixdir
ln -sf "./$1/default.nix" "$nixdir/home.nix"
ln -sf "./common/mutable/.config/nixpkgs/config.nix" "$nixdir/config.nix"
nix-shell "./common/home-manager/default.nix" -A install

# Install everything!
hmdone=/tmp/home-manager-install-done
if [[ ! -f $hmdone ]]; then
	home-manager -f $repodir/default.nix -b bak switch
	touch $hmdone
fi

keyimported=/tmp/gpg-key-imported
if [[ ! -f $keyimported ]]; then
	gpg --import $passdir/gpg/store{,.pub}
	gpg --edit-key $(cat $passdir/.gpg-id) trust quit
	touch $keyimported
fi

# Add ssh keys
key=stellarhoof.github.com
askpass=/tmp/echopass.sh
if [[ ! -f ~/.ssh/$key.pub ]]; then
	mkdir -p ~/.ssh
	echo "pass ssh/github.com.passphrase" > $askpass
	chmod +x $askpass
	pass ssh/github.com > ~/.ssh/$key
	chmod 600 ~/.ssh/$key
	echo | SSH_ASKPASS=$askpass ssh-add ~/.ssh/$key
	pass ssh/github.com.pub > ~/.ssh/$key.pub
	chmod 600 ~/.ssh/$key.pub
	rm $askpass
fi

# Set fish as default shell
fish=$(command -v fish)
if !(cat /etc/shells | grep $fish > /dev/null); then
	echo $fish | sudo tee -a /etc/shells
	sudo chsh -s "$fish" $USER
fi

rm $hmdone $keyimported
echo "Done. All that's left is to logout and log back in"
