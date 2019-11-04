# Furnisher

These are my personal dotfiles, managed with https://github.com/rycee/home-manager

## Install

`curl https://raw.githubusercontent.com/stellarhoof/furnisher/master/install.sh | bash`

## What's in the box

User configuration lives under `user` and system configuration under `system`
- `./user/home-manager`: files compiled by home-manager
- `./user/home-files`: files are copied to the Nix store and linked from `$HOME`
- `./user/mutable` files are linked from `$HOME`
