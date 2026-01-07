alias usermount="sudo mount -o uid=$USER,gid=$GROUPS"

# the WLR_DRM_* flags are needed for screen tearing
# add --unsupported-gpu here for nvidia
alias sway='WLR_DRM_NO_MODIFIERS=1 WLR_DRM_NO_ATOMIC=1 sway'

export GTK_THEME=Adwaita-dark
