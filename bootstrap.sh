#!/bin/bash
set -e

# Prompt for GH_TOKEN if not set
if [[ -z "$GH_TOKEN" ]]; then
  read -rsp "Enter your GitHub token: " GH_TOKEN
  echo
fi

# Download the setup script
curl -H "Authorization: token $GH_TOKEN" \
     -L "https://raw.githubusercontent.com/bslater/home/main/setup-pi.sh" \
     -o setup-pi.sh

chmod +x setup-pi.sh
./setup-pi.sh $GH_TOKEN
