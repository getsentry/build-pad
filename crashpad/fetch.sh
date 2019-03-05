#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

mkdir -p build
cd build

# Install depot_tools
if [ -d depot_tools ]; then
  pushd depot_tools
  git pull -r
  popd
else
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi

. $SCRIPT_DIR/vars.sh

if [[ "${TF_BUILD:-}" == "True" ]]; then
  # Set git data to avoid errors
  git config --global user.email "azure.pipelines@sentry.io"
  git config --global user.name "Azure Pipelines"
fi

# Checkout and sync crashpad
if [ -d crashpad ]; then
  cd crashpad
  $GCLIENT_CMD sync
  git fetch origin
  git rebase origin/master
else
  $FETCH_CMD crashpad
  cd crashpad
  # Apply Sentry patches
  git checkout -b feat/getsentry-patches
  git am -3 --ignore-whitespace --ignore-space-change < $SCRIPT_DIR/patches/getsentry.patch
fi
