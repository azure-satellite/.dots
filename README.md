# Furnisher

These are my personal dotfiles, managed with https://github.com/rycee/home-manager

## DIY furnishing

Pretty simple; IKEA style:

```
git clone --recurse-submodules https://github.com/stellarhoof/furnisher $HOME/garage
home-manager -f $HOME/garage/default.nix switch
```

## What's in the box

User configuration lives under `user` and system configuration under `system`
- `./user/home-manager`: files compiled by home-manager
- `./user/home-files`: files are copied to the Nix store and linked from `$HOME`
- `./user/mutable` files are linked from `$HOME`

## TODO

### Things to do after installing a new system (for lack of a better place)

- Set password for user
- Connect to wifi (iwctl)
- Add and update channels (home manager, nixos unstable) for user and root
- Switch to the new nix configuration with `sudo nixos-rebuild switch --upgrade`
- Install home manager
- Unmute output devices in alsamixer:
    amixer sset Master unmute
    amixer sset Speaker unmute
    amixer sset Headphone unmute

### Musings

- Manage system configuration as well and make this a provisioning thing?
- See what we can salvage from this guy:

```
./user/mutable/.local/share/pass/install.sh

mkdir -p ~/.ssh
pass ssh/github.com > ~/.ssh/github.com
pass ssh/github.com.pub > ~/.ssh/github.com.pub
chmod 600 ~/.ssh/github.com*
ssh-add -K ~/.ssh/github.com

pass git remote add origin git@github.com:stellarhoof/pass.git
pass git fetch
pass git branch -u origin/master

git remote add origin git@github.com:stellarhoof/furnisher.git
git fetch
git branch -u origin/master
```
