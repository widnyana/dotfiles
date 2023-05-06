#!/bin/bash


gh_latest_release() {
  #: usage: gh_latest_release "repo/name"
  if [ ! -z ${1} ]; then
    curl --silent "https://api.github.com/repos/${1}/releases/latest?access_token=${GITHUB_PERSONAL_TOKEN}" | # Get latest release from GitHub api
      grep '"tag_name":' |                                            # Get tag line
      sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
  fi
}