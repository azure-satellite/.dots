#!/bin/bash

set -e

# Install nix
if [[ ! -d /nix/store ]]; then
	curl https://nixos.org/nix/install | sh
	. ~/.nix-profile/etc/profile.d/nix.sh
fi

# Install home-manager
if !(nix-channel --list | grep home-manager > /dev/null); then
	nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
fi

# Clone required repos
code=~/Code/mine
if [[ ! -d $code/furnisher ]]; then
	git clone --recurse-submodules https://github.com/stellarhoof/furnisher $code/furnisher
fi
if [[ ! -d $code/fzf.vim ]]; then
	git clone https://github.com/stellarhoof/fzf.vim $code/fzf.vim
fi

# Install everything!
if [[ ! -f /tmp/home-manager-install-done ]]; then
	home-manager -f $code/furnisher/default.nix -b bak switch
	touch /tmp/home-manager-install-done
fi

if false; then
	# TODO: Make this script idempotent
	./$code/furnisher/user/mutable/.local/share/pass/install.sh
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

# Set all ssh remotes
function setOrigin {
	git remote set-url origin git@github.com:stellarhoof/$1.git
}
cd $code/furnisher && setOrigin furnisher
cd $code/furnisher/user/mutable/.local/share/pass && setOrigin pass
cd $code/furnisher/user/home-manager/programs/st && setOrigin st
cd $code/fzf.vim && setOrigin fzf.vim

# Set fish as default shell
fish=$(command -v fish)
if !(cat /etc/shells | grep $fish > /dev/null); then
	echo $fish | sudo tee -a /etc/shells
	sudo chsh -s "$fish" $USER
fi
