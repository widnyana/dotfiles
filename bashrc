# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions
isup() {
    wget -qO - "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g' ;
}
# update prompt view
function _update_ps1() {
    export PS1="\n\[\e[00;37m\][ \T ] \[\e[0m\]\[\e[01;33m\]\u\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;33m\]\w\[\e[0m\]\[\e[00;37m\]\n\[\e[0m\]\[\e[00;36m\]\\$\[\e[0m\] "
}
