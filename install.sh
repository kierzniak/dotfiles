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
spaceship_prompt_dir="${dir}/oh-my-zsh/themes/spaceship-prompt"

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

# Instal spaceship-prompt

# Get spaceship-prompt repository
if [ ! -d "$spaceship_prompt_dir" ]; then
  # Clone repository if not exists
  echo "Clone spaceship-prompt repository"
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$spaceship_prompt_dir"
else
  # Pull repository if exists
  echo "Repository already exists in ${spaceship_prompt_dir}"
  echo "Pulling changes from repository"
  git --work-tree="${spaceship_prompt_dir}" --git-dir="${spaceship_prompt_dir}"/.git pull origin master
fi

# Symlink spaceship-prompt theme
rm -f "${dir}/oh-my-zsh/themes/spaceship.zsh-theme"
ln -s "$spaceship_prompt_dir/spaceship.zsh-theme" "${dir}/oh-my-zsh/themes/spaceship.zsh-theme"

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
