#!/usr/bin/env bash -x
set -euo pipefail

HOMEBREW_DIR=~/.homebrew
HOMEBREW_TGZ_TEMP_LOCATION=/tmp/homebrew.tar.gz

mkdir -p $HOMEBREW_DIR

curl -L  https://github.com/Homebrew/brew/tarball/master -o $HOMEBREW_TGZ_TEMP_LOCATION

tar -xzf $HOMEBREW_TGZ_TEMP_LOCATION --strip 1 -C .homebrew

echo "export PATH=\"\$PATH:$HOMEBREW_DIR/bin\"" >> ~/.zshrc
