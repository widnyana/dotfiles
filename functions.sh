#!/bin/bash


gh_latest_release() {
  #: usage: gh_latest_release "repo/name"
  if [ ! -z ${1} ]; then
    curl --silent -H "Authorization: Bearer ${GITHUB_PERSONAL_TOKEN}" "https://api.github.com/repos/${1}/releases/latest" | # Get latest release from GitHub api
      grep '"tag_name":' |                                            # Get tag line
      sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
  fi
}


ghostty_terminfo_push() {
  #: usage: ghostty_terminfo_push user@host
  if [ -z "${1}" ]; then
    echo "usage: ghostty_terminfo_push <host>" >&2
    return 1
  fi
  infocmp -x xterm-ghostty | ssh "${1}" -- 'tic -x -'
}


removecontainers() {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
}

docker_armageddon() {
    removecontainers
    docker network prune -f
    docker rmi -f $(docker images --filter dangling=true -qa)
    docker volume rm $(docker volume ls --filter dangling=true -q)
    docker rmi -f $(docker images -qa)
}

