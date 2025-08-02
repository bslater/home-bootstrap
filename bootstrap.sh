#!/bin/bash
set -e

# curl -Lso bootstrap.sh "https://raw.githubusercontent.com/bslater/home-bootstrap/main/bootstrap.sh" && chmod 700 bootstrap.sh && ./bootstrap.sh

# Prompt for GH_TOKEN if not set
if [[ -z "$GH_TOKEN" ]]; then
  read -rsp "Enter your GitHub token: " GH_TOKEN
  echo
fi

# Download the setup script
curl -H "Authorization: token $GH_TOKEN" \
     -L "https://api.github.com/repos/bslater/home/contents/setup-pi.sh" \
     -o setup-pi.sh

chmod +x setup-pi.sh
./setup-pi.sh $GH_TOKEN
