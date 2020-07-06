#!/usr/bin/env zsh
_DOT_DIR=$0:a:h


create_auth_keys() {
  cat <<EOF > "${_DOT_DIR}/auth_keys" 
GITHUB_PERSONAL_TOKEN=
EOF
}


if [ ! -f ${_DOT_DIR}/auth_keys ]; then
  create_auth_keys
  echo "please configure your token here: ${_DOT_DIR}/auth_keys"
  exit 1
fi
source ${_DOT_DIR}/auth_keys

source ${_DOT_DIR}/functions.sh
source ${_DOT_DIR}/aliases
source ${_DOT_DIR}/python
source ${_DOT_DIR}/nodejs
source ${_DOT_DIR}/golang
source ${_DOT_DIR}/paths
source ${_DOT_DIR}/devs
source ${_DOT_DIR}/android

source ${_DOT_DIR}/containers

if [[ -x "$(command -v direnv)" ]]; then
  eval "$(direnv hook zsh)"
fi

#: specific per OS
if [[ $(uname) == "Linux" ]]; then

elif [[ $(uname) == "Darwin" ]]; then
    source ${_DOT_DIR}/mac
fi

# office stuff
if [[ -d "${_DOT_DIR}/office" ]]; then
  # Specific variable for golang usage in the office
  if [[ -f "${_DOT_DIR}/office/golang" ]]; then
      source "${_DOT_DIR}/office/golang"
  fi
fi

#: finalize $PATH
echo -e "Finalizing \$PATH"
FINAL_PATH=$(python ${_DOT_DIR}/bin/_pathnodupe.py)
export PATH=${FINAL_PATH}

#: clean up
unset _BOXES _DOT_DIR FINAL_PATH

echo "loader.zsh finished!"