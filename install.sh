#!/bin/bash
# 
# Script for installing .dotfiles
# 
# @package   dotfiles
# @author    Piotr Kierzniewski <p.kierzniewski@viewone.pl>
# @copyright 2014 ViewOne Sp. z o.o.
# @license   http://opensource.org/licenses/MIT MIT
# @link      https://github.com/kierzniak/dotfiles

# Dotfiles path
dir="${HOME}/.dotfiles"


# Get new repository
if [ ! -d "$dir" ]; then
  # Clone repository if not exists
  echo "Clone repository"
  git clone https://github.com/kierzniak/dotfiles.git "$dir"
else
  # Pull repository if exists
  echo "Repository already exists in ${dir}"
  echo "Pulling changes from repository"
  git --work-tree="${dir}" --git-dir="${dir}"/.git pull origin master
fi

# Symlink files if .dotfiles directory exists otherwise exit script
if [ -d "$dir" ]; then
  echo "Symlinking dotfiles from ${dir}"
else
  echo "$dir does not exist"
  exit 1
fi

# Function to symlink
link() {
  from="$1"
  to="$2"
  echo "Linking '$from' to '$to'"
  rm -f "$to"
  ln -s "$from" "$to"
}

create_dir() {
  dir_to_create="$1"

  if [[ ! -e "$dir_to_create" ]]; then
    mkdir -p "$dir_to_create"
fi
}

# Iterate over *.symlink files in .dotfiles directory
for location in $(find  ${dir} -name '*.symlink'); do
  # Remove .symlink extenstion from file
  file="${location%.symlink}"

  # Remove path from file
  file="${file##*/}"

  # Symlink with link function
  link "$location" "$HOME/.$file"
done

# Create ~/.ssh/config file if not already exists
if [[ ! -e "$HOME/.ssh/config" ]]; then
    "$HOME/.ssh"
    touch "$HOME/.ssh/config"
fi

link "${dir}/ssh/config" "$HOME/.ssh/config"

create_dir "$HOME/.config"
create_dir "$HOME/.config/ghostty"

# Symlink ghostty config
link "${dir}/config/ghostty" "$HOME/.config/ghostty/config"

# Symlink starship config 
link "${dir}/config/starship.yml" "$HOME/.config/starship.yml"
