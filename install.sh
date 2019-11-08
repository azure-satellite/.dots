#!/bin/bash

set -e

# Install nix
if [[ ! -d /nix/store ]]; then
	curl https://nixos.org/releases/nix/nix-2.3/install | sh
	. ~/.nix-profile/etc/profile.d/nix.sh
fi

# Install home-manager
if !(nix-channel --list | grep home-manager > /dev/null); then
	nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
fi

codedir=~/Code
repodir=$codedir/furnisher
fzfdir=$codedir/fzf.vim
hmdir=$codedir/home-manager
passdir=$repodir/user/mutable/.local/share/pass
stdir=$repodir/user/home-manager/programs/st

# Clone and setup required repos
function setOrigin {
	git remote set-url origin git@github.com:stellarhoof/$1.git
}
if [[ ! -d $repodir ]]; then
	git clone --recurse-submodules https://github.com/stellarhoof/furnisher $repodir
    cd $repodir && setOrigin furnisher
    cd $passdir && setOrigin pass
    cd $stdir && setOrigin st
    git checkout --track origin/config
fi
if [[ ! -d $fzfdir ]]; then
	git clone https://github.com/stellarhoof/fzf.vim $fzfdir
    cd $fzfdir && setOrigin fzf.vim
    git checkout --track origin/local-gfiles
fi
if [[ ! -d $hmdir ]]; then
    git clone https://github.com/stellarhoof/home-manager $hmdir
    cd $hmdir && setOrigin home-manager
    git checkout --track origin/my-changes
fi

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
