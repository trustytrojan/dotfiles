RESET="\[\033[0m\]"

function bold {
	echo "\[\033[1;$1m\]"
}

CYAN=$(bold "36")
RED=$(bold "31")
WHITE=$(bold "37")
BLUE=$(bold "34")

# Red username and `#` are reserved for root
if [ $UID = 0 ]; then
	USER=$RED
	PROMPT_CHAR=\#
else
	USER=$WHITE
	PROMPT_CHAR=\$
fi

# Colored prompt
PS1="$CYAN[ $USER\u$RESET@\h $BLUE\W $CYAN]$RESET$PROMPT_CHAR "

# Essential aliases
alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -al"
alias ip="ip -c"

# Environment variables
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1
