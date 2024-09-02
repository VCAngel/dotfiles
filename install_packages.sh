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
echo "\n\nInstalling Oh My Zsh...\n\n"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# # Check if the Oh My Zsh installation was successful
if [ $? -ne 0 ]; then
  echo "Failed to install Oh My Zsh. You can try to install it manually!"
fi

printf "\n\n Packages installed successfully! ヽ(・∀・)ﾉ\n\n"