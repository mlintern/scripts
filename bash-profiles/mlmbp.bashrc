# This file is sourced by all bash shells on startup, whether interactive
# or not.  This file *should generate no output* or it will break the
# scp and rcp commands.

#make eterm into xterm for emacs/ssh purposes
if [[ "$TERM" = "eterm-color" ]]; then
    export TERM="xterm-color"
fi

if [[ $WHOAMI = 'root' ]]; then
        export PATH="/bin:/sbin:/usr/bin:/usr/sbin:${ROOTPATH}"
else
        export PATH="/bin:/usr/bin:${PATH}"
fi

#Extend command history
export HISTSIZE=5000000

if ! shopt -q login_shell; then
    if [ -f /usr/bin/keychain ]; then
	[ -f ~/.ssh/id_dsa ] && /usr/bin/keychain --noask ~/.ssh/id_dsa &> /dev/null
	[ -f ~/.ssh/id_rsa ] && /usr/bin/keychain --noask ~/.ssh/id_rsa &> /dev/null
    fi
    [ -f ~/.keychain/$HOSTNAME-sh ] && source ~/.keychain/$HOSTNAME-sh > /dev/null &> /dev/null
fi

export http_proxy=http://127.0.0.1:8840
export https_proxy=http://127.0.0.1:8840
export no_proxy='cnsr,hc-beta.oraclecorp.com,localhost,dev.compendiumblog.com,cnr,dev.cpdm.oraclecorp.com,test.cpdm.oraclecorp.com'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
source /opt/boxen/env.sh
