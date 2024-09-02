# Dotfiles for my personal setup! ヽ(\*・ω・)ﾉ

**Dotfiles** are configuration files that are used to customize and personalize your system.
These are the ones I use on my daily basis! ( ˙▿˙ )

## What's in here? (・・ ) ?

Some of the dotfiles I use are:

### `.config/`

- **[zsh](.config/zsh)**: My zsh configuration with [oh-my-zsh](.config/omz)!.
- **[Neovim](.config/nvim)**: My neovim configuration for coding.
- **[tmuxinator](.config/tmuxinator)**: My tmuxinator configuration for tmux sessions.
- **[x11](.config/x11)**: X11 configuration files.

### `.local/`

- [bin/](.local/bin): Some scripts I use.
- [src/](.local/src): My src files for the (suckless) software I use!

## How to use them? (・ω・) ?

First of all, you need to clone the repository and then
create symbolic links to the files you want to use.

Clone the repo:

```sh
git clone https://github.com/VCAngel/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

If you want all the features, you can install the dependencies I use:

```sh
./install_packages.sh
```

Then, create the symbolic links:

```sh
./install.sh
```

**CAUTION**: This will override your current configuration files! So use it with care! ( ˙▿˙ )

## Contact ( ´ ▽ ` )

- Angel Vargas <vcangel00@gmail.com>
- [vcangel.dev](https://vcangel.dev)
