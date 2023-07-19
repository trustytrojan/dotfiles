# reset to terminal defaults
RESET="\[\033[0m\]"

# function to make bold colors
function bold {
    echo "\[\033[1;$1m\]"
}

# bold colors
CYAN=$(bold 36)
RED=$(bold 31)
WHITE=$(bold 37)
BLUE=$(bold 34)

# red username and `#` are reserved for root
if [ $UID = 0 ]; then
    USER=$RED
    PROMPT_CHAR=\#
else
    USER=$WHITE
    PROMPT_CHAR=\$
fi

# colored prompt
PS1="$CYAN[ $USER\u$RESET@\h $BLUE\W $CYAN]$RESET$PROMPT_CHAR "

# colored output for programs
alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -al"
alias ip="ip -c"
