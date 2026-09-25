#!/usr/bin/env bash

set -euo pipefail

echo "Docker context: $(docker context show)"
echo "This will delete ALL containers, images, volumes, and custom networks."
read -r -p "Type DELETE to continue: " confirmation
[[ "$confirmation" == "DELETE" ]] || exit 1

# Remove containers first to release their images, volumes, and networks.
containers=$(docker container ls -aq)
if [[ -n "$containers" ]]; then
  docker container rm -f $containers
fi

images=$(docker image ls -aq | sort -u)
if [[ -n "$images" ]]; then
  docker image rm -f $images
fi

# Includes named volumes, which may contain database data.
volumes=$(docker volume ls -q)
if [[ -n "$volumes" ]]; then
  docker volume rm $volumes
fi

docker network prune -f

echo "Docker cleanup complete."
