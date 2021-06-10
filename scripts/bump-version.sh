#!/usr/bin/env bash

set -euo pipefail
git config --global user.name "Teknasyon Bot"
git config --global user.email "cibot@teknasyon.com"
npx standard-version
echo "[realese] Release version=$(git describe --abbrev=0 | tr -d '\n')" >> $GITHUB_ENV
export VERSION="$(git describe --abbrev=0 | tr -d '\n')"
VERSION=${VERSION:1}
echo $VERSION
npx podspec-bump -w -i "$VERSION"
git add -A
# amend last commit without changing the message
git commit --amend --no-edit