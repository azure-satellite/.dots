# Furnisher

These are my personal dotfiles, managed with https://github.com/rycee/home-manager

## DIY furnishing

1. Install nix (https://nixos.org/nix/download.html)
2. Install home-manager (https://github.com/rycee/home-manager)
3. Install this repo: `curl https://github.com/stellarhoof/furnisher | sh`

## What's in the box

User configuration lives under `user` and system configuration under `system`
- `./user/home-manager`: files compiled by home-manager
- `./user/home-files`: files are copied to the Nix store and linked from `$HOME`
- `./user/mutable` files are linked from `$HOME`

## TODO

- Add private keys
- Set password for user
- Connect to wifi (iwctl)
- Add and update channels (home manager, nixos unstable) for user and root
- Switch to the new nix configuration with `sudo nixos-rebuild switch --upgrade`
- Install home manager
- Unmute output devices in alsamixer:
    amixer sset Master unmute
    amixer sset Speaker unmute
    amixer sset Headphone unmute

```
command -v fish | sudo tee -a /etc/shells
sudo chsh -s "$(command -v fish)" "${USER}"

# Pass stuff
git clone --recurse-submodules https://github.com/stellarhoof/furnisher $HOME/garage
home-manager -f $HOME/garage/default.nix switch

./user/mutable/.local/share/pass/install.sh

mkdir -p ~/.ssh
pass ssh/github.com > ~/.ssh/github.com
pass ssh/github.com.pub > ~/.ssh/github.com.pub
chmod 600 ~/.ssh/github.com*
ssh-add -K ~/.ssh/github.com

git remote add origin git@github.com:stellarhoof/furnisher.git
git fetch
git branch -u origin/master
```
