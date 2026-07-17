Dot Files
======

just some configuration on my machine, if you think its usefull, just use it. :)


## Installation
```shell
git clone https://github.com/widnyana/dotfiles.git ~/.dotfiles
~/.dotfiles/bin/install-dotfiles.sh
```

Supported on macOS (Homebrew) and Fedora/RHEL (`dnf`). The installer is
self-healing: re-running the same command repairs drift (broken/wrong symlinks,
half-finished installs). Preview what it would change first with:

```shell
~/.dotfiles/bin/install-dotfiles.sh --dry-run
```

On Linux it needs root or non-interactive `sudo` for `dnf`; run `sudo -v` first.