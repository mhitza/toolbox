#!/usr/bin/env bash

set -o pipefail
set -x

current_shell="$(grep "$USER" /etc/passwd | cut -d: -f7)"

if [[ "$current_shell" != *"/zsh" ]]; then
    output="$(grep -i ^ID= /etc/os-release)"

    if [[ "$output" == "ID=ubuntu" ]]; then
        sudo apt update && sudo apt install -y zsh
    fi

    if [[ "$output" == "ID=fedora" ]]; then
        sudo dnf install -y zsh
    fi
fi

zsh_path=$(which zsh)
chsh --shell "$zsh_path"

ln -s "$PWD/shell-config/zshrc" ~/.zshrc
