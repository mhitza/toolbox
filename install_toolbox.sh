#!/usr/bin/env bash

set -e
set -x
START_DIR=$(pwd)
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

function download() {
    if command -v curl >/dev/null 2>&1; then
        curl -L -O "$1"
    elif command -v wget >/dev/null 2>&1; then
        wget "$1"
    else
        echo "Error: Neither curl nor wget is installed." >&2
        return 1
    fi
}

INSTALL_DIR="$HOME/.local/bin"
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi

version_file=eget-1.3.4-linux_amd64
version_file_tgz="$version_file.tar.gz"
download "https://github.com/zyedidia/eget/releases/download/v1.3.4/$version_file_tgz"

# Calculate the hash of the downloaded file
ACTUAL_HASH=$(sha256sum "$version_file_tgz" | cut -d' ' -f1)
EXPECTED_HASH="c6b3da99e494e14a9f8c2877f9eb5891d573a95f436ecba7013cfb7d0992abf5"

if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
    echo "Hash verification successful" > /dev/null
    # Extract the binary
    tar xzf "$version_file_tgz"
    copy_target="$START_DIR/bin/eget"
    mv "$version_file/eget" "$copy_target"
    link_target="$INSTALL_DIR/eget"
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
  ln -s "$1/$2" "$INSTALL_DIR/$2"
}

eget_local FiloSottile/age
symlink_local "$target_bin" age

eget_local psanford/wormhole-william
symlink_local "$target_bin" wormhole-william

eget_local svenstaro/miniserve
symlink_local "$target_bin" miniserve

download "https://beyondgrep.com/ack-v3.9.0" && mv ack-v3.9.0 "$target_bin/ack" && chmod +x "$target_bin/ack"
symlink_local "$target_bin" ack


symlink_local "$target_scripts" encrypt-for
symlink_local "$target_scripts" decrypt-mine
symlink_local "$target_scripts" ssh-delivery
symlink_local "$target_scripts" ssh-port-forward
symlink_local "$target_scripts" http-serve
symlink_local "$target_scripts" record
symlink_local "$target_scripts" replay
symlink_local "$target_scripts" ask-llm
symlink_local "$target_scripts" describe-diff
symlink_local "$target_scripts" fastgpt
symlink_local "$target_scripts" review-changes
symlink_local "$target_scripts" private-fork
