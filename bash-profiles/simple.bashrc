#.bashrc
# Add bin to path
export PATH="$PATH:$HOME/bin"
# Dynamic resizing
shopt -s checkwinsize
# Custom prompt
PS1="[\@] \u@\h \w > "
# Add color
eval `dircolors -b`
# User defined aliases
alias vi='vim'