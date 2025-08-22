#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# curl --fail-with-body --location --show-error --silent -o bootstrap.sh && chmod 700 bootstrap.sh && ./bootstrap.sh

# --- prerequisites ---
command -v curl >/dev/null 2>&1 || { echo "curl not found. Install curl first."; exit 1; }

# --- token (masked prompt if not provided) ---
if [[ -z "${GITHUB_TOKEN:-}" && -z "${GH_TOKEN:-}" ]]; then
  read -rsp "Enter your GitHub token: " GITHUB_TOKEN
  echo
else
  # accept either env var name
  GITHUB_TOKEN="${GITHUB_TOKEN:-${GH_TOKEN}}"
fi

# --- repo urls ---
SETUP_URL="https://raw.githubusercontent.com/bslater/home/main/setup-pi.sh"
LIB_URL="https://raw.githubusercontent.com/bslater/home/main/modules/lib.sh"

# --- fetch lib.sh first (so setup can source it) ---
curl --fail-with-body --location --show-error --silent \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3.raw" \
     "$LIB_URL" -o lib.sh

# lock down perms
chmod 0644 lib.sh

# --- fetch setup-pi.sh ---
curl --fail-with-body --location --show-error --silent \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3.raw" \
     "$SETUP_URL" -o setup-pi.sh

chmod 700 setup-pi.sh

# --- run setup (export token to avoid argv leakage) ---
export GITHUB_TOKEN
./setup-pi.sh
unset GITHUB_TOKEN
