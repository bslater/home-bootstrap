#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# curl --fail-with-body --location --show-error --silent -o bootstrap.sh && chmod 700 bootstrap.sh && ./bootstrap.sh

# --- prerequisites ---
command -v curl >/dev/null 2>&1 || { echo "curl not found. Install curl first."; exit 1; }

# --- token (masked prompt if not provided) ---
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  read -rsp "Enter your GitHub token: " GITHUB_TOKEN
  echo
fi

SETUP_URL="https://raw.githubusercontent.com/bslater/home/main/setup-pi.sh"
SETUP_FILE="setup-pi.sh"

# --- fetch setup script (robust curl flags) ---
curl --fail-with-body --location --show-error --silent \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3.raw" \
     "$SETUP_URL" -o "$SETUP_FILE"

# lock down perms and run
chmod 700 "$SETUP_FILE"

# Prefer exporting the token so it isn't visible in process args
export GITHUB_TOKEN
bash "./$SETUP_FILE"
unset GITHUB_TOKEN
