#!/usr/bin/env zsh

export _DOT_DIR=$0:a:h
export SDK_DIR="${HOME}/Development/sdks"

export CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
export DOT_DIR="${HOME}/.dotfiles"

create_auth_keys() {
  cat <<EOF > "${_DOT_DIR}/auth_keys"
export GITHUB_PERSONAL_TOKEN=

### gitlab
export GITLAB_PERSONAL_USERNAME=""
export GITLAB_PERSONAL_TOKEN=""
EOF
  chmod 600 "${_DOT_DIR}/auth_keys"
}


if [ ! -f ${_DOT_DIR}/auth_keys ]; then
  create_auth_keys
  echo "please configure your token here: ${_DOT_DIR}/auth_keys"
  exit 1
fi

chmod 600 "${_DOT_DIR}/auth_keys"

source ${_DOT_DIR}/global_env
source ${_DOT_DIR}/common/colors
source ${_DOT_DIR}/auth_keys

#: machine-local feature flags (WID_ENABLE_*). See FEATURE_FLAGS.md.
[ -f "${_DOT_DIR}/office/flags" ] && source "${_DOT_DIR}/office/flags"

source ${_DOT_DIR}/functions.sh
source ${_DOT_DIR}/paths                      ### declare $PATH here
source ${_DOT_DIR}/core

source ${_DOT_DIR}/android
source ${_DOT_DIR}/blockchain
source ${_DOT_DIR}/devs
source ${_DOT_DIR}/golang
source ${_DOT_DIR}/nodejs
source ${_DOT_DIR}/python
source ${_DOT_DIR}/rust
source ${_DOT_DIR}/aliases
source ${_DOT_DIR}/infrastructure

if [ -f ${_DOT_DIR}/workaround ]; then
  source ${_DOT_DIR}/workaround
fi

#: specific per OS
if [[ $(uname) == "Linux" ]]; then
    source ${_DOT_DIR}/linux
elif [[ $(uname) == "Darwin" ]]; then
    source ${_DOT_DIR}/mac
fi

# office stuff
__OFFICE_DIR="${_DOT_DIR}/office"
if [[ -d "${__OFFICE_DIR}" ]]; then
  # Specific variable for golang usage in the office
  if [[ -f "${__OFFICE_DIR}/golang" ]]; then
      source "${__OFFICE_DIR}/golang"
  fi

  # Specific variable for development stuff used in the office
  if [[ -f "${__OFFICE_DIR}/devs" ]]; then
      source "${__OFFICE_DIR}/devs"
  fi
fi

#: finalize $PATH — only reassign if the dedupe helper actually produced output
#: (a minimal box without python3 must not end up with an empty PATH)
FINAL_PATH=$(python3 ${_DOT_DIR}/bin/_pathnodupe.py 2>/dev/null)
[[ -n "$FINAL_PATH" ]] && export PATH=${FINAL_PATH}

## Completions
export FPATH="$FPATH:${_DOT_DIR}/completions/"

#: clean up
unset _DOT_DIR FINAL_PATH
