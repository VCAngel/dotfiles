#!/bin/bash

# Function to restore backup files
restore_backup() {
  local backup_file=$1
  local original_file=${backup_file%.pre-vca}

  if [ -e "$backup_file" ]; then
	mv "$backup_file" "$original_file"
	echo "Restored: $original_file"
  fi
}

# Find and restore backup files in the home directory and .config directory
find "$HOME" -type f -name "*.pre-vca" | while read -r file; do
  restore_backup "$file"
done

find "$HOME/.config" -type f -name "*.pre-vca" | while read -r file; do
  restore_backup "$file"
done

echo "Revert process completed! (⌒_⌒;)"

