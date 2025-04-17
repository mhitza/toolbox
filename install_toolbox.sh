#!/usr/bin/env bash

set -e
set -x
START_DIR=$(pwd)
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

version_file=eget-1.3.4-linux_amd64
curl -s -L "https://github.com/zyedidia/eget/releases/download/v1.3.4/$version_file.tar.gz" -o eget.tar.gz

# Calculate the hash of the downloaded file
ACTUAL_HASH=$(sha256sum eget.tar.gz | cut -d' ' -f1)
EXPECTED_HASH="c6b3da99e494e14a9f8c2877f9eb5891d573a95f436ecba7013cfb7d0992abf5"

if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
    echo "Hash verification successful" > /dev/null
    # Extract the binary
    tar xzf eget.tar.gz
    copy_target="$START_DIR/bin/eget"
    mv "$version_file/eget" "$copy_target"
    link_target="$HOME/.local/bin/eget"
    ln -s "$copy_target" "$link_target"
else
    echo "Hash verification failed!" > /dev/null
fi

# Cleanup
cd .. >/dev/null
rm -rf "$TMP_DIR"

cd "$START_DIR"



shopt -s expand_aliases

target_bin="$PWD/bin"
target_scripts="$PWD/scripts"

alias eget_local="eget --to \"$target_bin\""
function symlink_local() {
  ln -s "$1/$2" "$HOME/.local/bin/$2"
}

eget_local FiloSottile/age
symlink_local "$target_bin" age

eget_local psanford/wormhole-william
symlink_local "$target_bin" wormhole-william

eget_local svenstaro/miniserve
symlink_local "$target_bin" miniserve


symlink_local "$target_scripts" encrypt-for
symlink_local "$target_scripts" decrypt-mine
symlink_local "$target_scripts" ssh-delivery
