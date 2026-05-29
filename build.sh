#!/usr/bin/env bash

repo_dir="/tmp/lovely-forks"

if ! command -v docker &>/dev/null; then
  echo "Docker is not installed or not in PATH."
  exit 1
fi

git clone https://github.com/tretuttle/lovely-forks "$repo_dir" && cd "$repo_dir"
docker run --rm -it -v $(pwd):/app -w /app node:24-alpine sh -c '
  npm install --global web-ext &&
  apk add git jq zip make rsync &&
  make chrome &&
  make firefox
'

echo "Done building. output path:"
echo "  Chrome:  \"$(pwd)/tmp\""
echo "  FireFox: \"$(pwd)/build\""
