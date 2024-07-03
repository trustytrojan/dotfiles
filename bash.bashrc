# This file is meant to replace /etc/bash.bashrc on my Arch Linux installs

set_ps1() {
	# Color/style escape sequences
	bold() { echo $'\e[1;'$1'm'; }
	local RESET=$'\e[0m'
	local CYAN=$(bold 36)
	local RED=$(bold 31)
	local WHITE=$(bold 37)
	local BLUE=$(bold 34)
	unset bold

	# Red username and `#` are reserved for root
	local USER PROMPT_CHAR
	if [ $UID = 0 ]; then
		USER=$RED
		PROMPT_CHAR=\#
	else
		USER=$WHITE
		PROMPT_CHAR=\$
	fi

	# Colored prompt
	PS1="$CYAN[ $USER\u$RESET@\h $BLUE\W $CYAN]$RESET$PROMPT_CHAR "
}

set_ps1

# Essential aliases
alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -al"
alias ip="ip -c"
alias du="du -hd1"

# Environment variables
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
