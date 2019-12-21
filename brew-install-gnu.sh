#!/bin/sh

# For setting up a gnu-ish macOS environment
# For those of us who work in Linux all day from a Mac ...

brew install coreutils
brew install bash
brew install binutils
brew install diffutils
brew install ed
brew install findutils
brew install gawk
brew install gnu-indent
brew install gnu-sed
brew install gnu-tar
brew install gnu-which
brew install gnutls
brew install grep
brew install gzip
brew install screen
brew install watch
brew install wdiff
brew install wget
brew install git
brew install python3

echo 'PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/binutils/bin:/usr/local/opt/gettext/bin:/usr/local/opt/gnu-getopt/bin:/usr/local/opt/ed/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/gnu-indent/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/gnu-which/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:${HOME}/Library/Python/3.7/bin:$PATH"' >> ~/.bash_profile

grep -q "/usr/local/bin/bash" /etc/shells || echo '/usr/local/bin/bash' | sudo tee -a /etc/shells

chsh -s /usr/local/bin/bash
