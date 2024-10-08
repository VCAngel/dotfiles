#!/bin/bash

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  echo "Wha... Cannot detect the OS! (・・ ) ?"
  exit 1
fi

# Read the requirements file
REQUIREMENTS_FILE="packages.txt"
if [ ! -f $REQUIREMENTS_FILE ]; then
  echo "Packages file not found! ヽ(°〇°)ﾉ"
  exit 1
fi

# Filter valid package entries (ignore comments and empty lines)
PACKAGES=$(grep -vE '^\s*#|^\s*$' "$REQUIREMENTS_FILE" | tr '\n' ' ')

printf "The following packages will be installed: \n\n $PACKAGES \n\n"
  read -p "Do you want to continue? [y/N] " response
  if [[ ! "$response" =~ ^([yY][eE][sS]|[ yY])$ ]]; then
    echo "Aborted... (T_T)"
    exit 1
  fi

# Install the packages based on the detected distribution
case $OS in
ubuntu | debian)
  echo "Ubuntu/Debian detected..."
  sudo apt update
  sudo apt install $PACKAGES
  ;;
centos | rhel)
  echo "CentOS/RHEL detected..."
  sudo yum install $PACKAGES
  ;;
fedora)
  echo "Fedora detected..."
  sudo dnf install $PACKAGES
  ;;
arch)
  echo "Arch Linux detected..."
  sudo pacman -S $PACKAGES
  ;;
*)
  echo "Unsupported distribution: $OS"
  exit 1
  ;;
esac

# Install Oh My Zsh
read -p "Do you want to install Oh My Zsh? [y/N] " ohmyzsh_response
if [[ "$ohmyzsh_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  curl -fsSL "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | sh

  # Install Oh My Zsh plugins
  ## ZSH Syntax Highlighting
  read -p "Do you want to install the ZSH Syntax Highlighting plugin? [y/N] " syntax_highlighting_response
  if [[ "$syntax_highlighting_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZDOTDIR:-$HOME}/.config/omz/plugins/zsh-syntax-highlighting
  fi

  ## ZSH Autosuggestions
  read -p "Do you want to install the ZSH Autosuggestions plugin? [y/N] " autosuggestions_response
  if [[ "$autosuggestions_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZDOTDIR:-$HOME}/.config/omz/plugins/zsh-autosuggestions
  fi

  ## ZSH Autocomplete
  read -p "Do you want to install the ZSH Autocomplete plugin? [y/N] " autocomplete_response
  if [[ "$autocomplete_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://github.com/marlonrichert/zsh-autocomplete ${ZDOTDIR:-$HOME}/.config/omz/plugins/zsh-autocomplete
  fi
fi

# Install paru
if [[ "$OS" == "arch" ]]; then
  read -p "Do you want to install Paru? [y/N] " paru_response
  if [[ "$paru_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
  fi

  # Using paru
  ## Install packages from the AUR
  read -p "Do you want to install Discord (AUR)? [y/N] " discord_response
  if [[ "$discord_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    paru -S discord
  fi

  read -p "Do you want to install Google Chrome (AUR)? [y/N] " chrome_response
  if [[ "$chrome_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    paru -S google-chrome
  fi

  read -p "Do you want to install Snapd (AUR)? [y/N] " snapd_response
  if [[ "$snapd_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    paru -S snapd
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap
  fi
fi

printf "\n\n Packages installed successfully! ヽ(・∀・)ﾉ\n\n"