#!/bin/bash

BANNER="vcangel's dotfiles!
 ** **    *  ** * *
   *  *    *   *   
*      **   *    * 
  *                
        *        * 
 *    **    *  *   
          *        
*  * *          *  
           * *     
    *             *
       *          *
              *    "

# Display a banner
echo "$BANNER"

# Display a message
echo "Installing dependencies..."
./install_packages.sh

# Check if the install_packages.sh script ran successfully
if [ $? -ne 0 ]; then
  echo "Failed to install dependencies. Exiting..."
  exit 1
fi

# Display a message
echo "Preparing dotfiles!..."

printf "Any existing configuration files will be backed up (.pre-vca suffix) and replaced with my dotfiles!\n"

echo "Do you want to continue? [y/N]"
read response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Aborted... (T_T)"
  exit 1
fi

# Setup config files
VCA_DOTFILES="$(pwd)"
BACKUP_SUFFIX="pre-vca"

## X11
X11_SRC="$VCA_DOTFILES/.config/x11/.xinitrc"
X11_DEST="$HOME/.xinitrc"

## ZSH
ZSHRC_SRC="$VCA_DOTFILES/.config/zsh/.zshrc"
ZSHRC_DEST="$HOME/.zshrc"

## NVIM
NVIM_SRC="$VCA_DOTFILES/.config/nvim"
NVIM_DEST="$HOME/.config/nvim"

## Oh My ZSH
OMZ_SRC="$VCA_DOTFILES/.config/omz"
OMZ_DEST="$HOME/.config/omz"

## Tmuxinator
TMUXINATOR_SRC="$VCA_DOTFILES/.config/tmuxinator"
TMUXINATOR_DEST="$HOME/.config/tmuxinator"

# Function to create a backup if the file exists
backup_if_exists() {
  local file=$1
  if [ -e "$file" ]; then
    mv "$file" "$file.$BACKUP_SUFFIX"
  fi
}

# Create symlink for .xinitrc
backup_if_exists "$X11_DEST"
ln -sf "$X11_SRC" "$X11_DEST"

# Create symlink for .zshrc
backup_if_exists "$ZSHRC_DEST"
ln -sf "$ZSHRC_SRC" "$ZSHRC_DEST"

# Copy NVIM files
mkdir -p "$NVIM_DEST"
for file in "$NVIM_SRC"/*; do
  base_file=$(basename "$file")
  backup_if_exists "$NVIM_DEST/$base_file"
  cp -r "$file" "$NVIM_DEST/"
done

# Copy OMZ files
mkdir -p "$OMZ_DEST"
for file in "$OMZ_SRC"/*; do
  base_file=$(basename "$file")
  backup_if_exists "$OMZ_DEST/$base_file"
  cp -r "$file" "$OMZ_DEST/"
done

# Copy Tmuxinator files
mkdir -p "$TMUXINATOR_DEST"
for file in "$TMUXINATOR_SRC"/*; do
  base_file=$(basename "$file")
  backup_if_exists "$TMUXINATOR_DEST/$base_file"
  cp -r "$file" "$TMUXINATOR_DEST/"
done

# Check for errors and revert changes if any
if [ $? -ne 0 ]; then
  echo "An error occurred. Reverting changes..."
  rm -rf "$NVIM_DEST" "$OMZ_DEST" "$TMUXINATOR_DEST"
  if [ -f "$X11_BACKUP" ]; then
    mv "$X11_BACKUP" "$X11_DEST"
  fi
  if [ -f "$ZSHRC_BACKUP" ]; then
    mv "$ZSHRC_BACKUP" "$ZSHRC_DEST"
  fi
  exit 1
fi

# Display success message
echo "All done! ( ˙▿˙ )"

