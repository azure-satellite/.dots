#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnupg pass openssh

set -euo pipefail

cd $ROOTDIR

if [[ ! -f "$CACHEDIR/key-imported" ]]; then
	gpg --import gitmodules/pass/gpg/store{,.pub}
	gpg --edit-key $(cat gitmodules/pass/.gpg-id) trust quit
	touch "$CACHEDIR/key-imported"
fi

export PASSWORD_STORE_DIR="$ROOTDIR/gitmodules/pass"

GITHUBKEY=stellarhoof.github.com
if [[ ! -f ~/.ssh/$GITHUBKEY.pub ]]; then
	mkdir -p ~/.ssh
    [[ -z ${DISPLAY+x} ]] && export DISPLAY=:0
    ECHOPASS="$CACHEDIR/echopass.sh"
    echo "cat" > $ECHOPASS
    chmod +x "$ECHOPASS"
    SSH_ASKPASS="$ECHOPASS" ssh-add ~/.ssh/$GITHUBKEY <<< "$(pass ssh/github.com.passphrase)"
	pass ssh/github.com.pub > ~/.ssh/$GITHUBKEY.pub
	chmod 600 ~/.ssh/$GITHUBKEY.pub
fi
