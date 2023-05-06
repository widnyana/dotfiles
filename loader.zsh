#!/usr/bin/env zsh
_DOT_DIR=$0:a:h


source ${_DOT_DIR}/aliases
source ${_DOT_DIR}/python
source ${_DOT_DIR}/nodejs
source ${_DOT_DIR}/golang
source ${_DOT_DIR}/paths

#: load ssh alias
for box in $(pwd)/boxes/*.box; do
    source "${box}"
done 

#: specific per OS
if [[ $(uname) == "Linux" ]]; then

elif [[ $(uname) == "Darwin" ]]; then
    source ${_DOT_DIR}/mac
fi

#: finalize $PATH
FINAL_PATH=$(python ${_DOT_DIR}/bin/_pathnodupe.py)
echo $FINAL_PATH
echo "====="
export PATH=${FINAL_PATH}
echo $PATH
#: clean up
unset _BOXES _DOT_DIR FINAL_PATH