# /etc/skel/.bash_profile:
# $Header: /home/cvsroot/gentoo-src/rc-scripts/etc/skel/.bash_profile,v 1.10 2002/11/18 19:39:22 azarah Exp $

#This file is sourced by bash when you log in interactively.
[ -f ~/.bashrc ] && . ~/.bashrc

for k in /usr/bin/keychain /opt/local/bin/keychain /usr/local/bin/keychain; do
    if [ -f $k ]; then
        for i in ~/.ssh/*; do
            [ -f $i ] && [ -f $i.pub ] && $k --nogui --inherit any $i
        done
#     [ -f ~/.ssh/id_dsa ] && /usr/bin/keychain --nogui ~/.ssh/id_dsa
#     [ -f ~/.ssh/id_rsa ] && /usr/bin/keychain --nogui ~/.ssh/id_rsa
    fi
done
[ -f ~/.keychain/$HOSTNAME-sh ] && source ~/.keychain/$HOSTNAME-sh > /dev/null

if [[ -s "$HOME/.aliases" ]]  ; then source "$HOME/.aliases" ; fi

if [[ -d "$HOME/.rbenv" ]] ; then eval "$(rbenv init -)"; fi

# [[ -f $HOME/.bash_completions/git-completion ]] && source $HOME/.bash_completions/git-completion
# [[ -f /opt/boxen/homebrew/etc/bash_completion.d/git-prompt.sh ]] && source /opt/boxen/homebrew/etc/bash_completion.d/git-prompt.sh
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
	fi

FG_BLACK="\[\033[01;30m\]"
FG_WHITE="\[\033[01;37m\]"
FG_RED="\[\033[01;31m\]"
FG_GREEN="\[\033[01;32m\]"
FG_BLUE="\[\033[01;34m\]"
NO_COLOR="\[\e[0m\]"

WHOAMI="`/usr/bin/whoami`"

#build PS1
#don't set PS1 for dumb terminals
if [[ "$TERM" != 'dumb' ]] && [[ -n "$BASH" ]]; then
    PS1=''
    #don't modify titlebar on console
    [[ "$TERM" != 'linux' && "$CF_REAL_TERM" != "eterm-color" ]] && PS1="${PS1}\[\e]2;\u@\H:\W\a"

    #use a red $ if you're root, white otherwise
    if [[ $WHOAMI = "root" ]]; then
    	  #red hostname
	      PS1="${PS1}${FG_RED}\u:"
    else
      	#green user@hostname
     	  PS1="${PS1}${FG_GREEN}\u:"
    fi
 
    GIT_PS1_SHOWDIRTYSTATE=1
    #working dir basename and prompt
    PS1="${PS1} ${FG_RED}\$(__git_ps1 "[%s]") ${FG_BLUE}\W \$ ${NO_COLOR}"
fi
