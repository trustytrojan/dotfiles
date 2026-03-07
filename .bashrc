alias usermount="sudo mount -o uid=$USER,gid=$GROUPS"
alias yt-dlp="yt-dlp --remote-components ejs:github --embed-metadata --embed-thumbnail"

# VERY handy for detecting whether screen tearing is working or not
alias tearing-nodes='swaymsg -t get_tree | jq ".. | select(.allow_tearing? == true) | {name, type}"'

# the WLR_DRM_* flags are needed for screen tearing
# add --unsupported-gpu here for nvidia
alias sway='WLR_DRM_NO_MODIFIERS=1 WLR_DRM_NO_ATOMIC=1 sway'

export GTK_THEME=Adwaita-dark
