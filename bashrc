# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions
down4me() {
    wget -qO - "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g' ;
}
