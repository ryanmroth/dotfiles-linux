#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH aliases.
#  Note:        Intended to be used in concert with Oh My Zsh
#               For a full list of active aliases, run 'alias'.
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Make Terminal Better (Remapping defaults and adding functionality)
#  2.  File & Folder management
#  3.  Process Management
#  4.  Searching
#  5.  Networking
#  6.  System Operations & Information
#  7.  Git
#  8.  Encoding
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Make Terminal Better
#  --------------------------------------------------
    
    # General
    # ---------------
    alias ls='lsd -G'                    # Preferred 'ls' implementation
    alias cp='cp -iv'                   # Preferred 'cp' implementation
    alias mv='mv -iv'                   # Preferred 'mv' implementation
    alias grep='grep --color=auto'      # Color grep
    alias mount='mount |column -t'      # Pretty and human readable mount
    alias mkdir='mkdir -pv'             # Preferred 'mkdir' implementation
    alias ll='ls -FGlAh'               # Preferred 'll' implementation
    alias less='less -FSRXc'            # Preferred 'less' implementation
    alias f='open -a Finder ./'         # Opens current directory in MacOS Finder
    alias c='clear'                     # Clear terminal display
    alias path='echo -e ${PATH//:/\\n}' # Echo all executable Paths
    alias fix_stty='stty sane'          # Restore terminal settings when screwed up
    
    # Directories
    # ---------------
    alias .1='cd ..'                    # Go back 1 directory level
    alias .2='cd ../..'                 # Go back 2 directory levels
    alias .3='cd ../../..'              # Go back 3 directory levels
    alias .4='cd ../../../..'           # Go back 4 directory levels
    alias .5='cd ../../../../..'        # Go back 5 directory levels

    alias back='cd $OLDPWD'             # Go back to previous working directory

    # History
    # --
    alias h='history'
    alias hl='history | less'
    alias hs='history | grep'
    alias hsi='history | grep -i'

#  --------------------------------------------------
#   2.  File & Folder Management
#  --------------------------------------------------

    alias filesize='stat -f \"%z bytes\"'                           # Get file size
    alias numFiles='echo $(ls -1 | wc -l)'                          # Count of non-hidden files in current dir
    alias make1mb='dd if=/dev/zero of=1MB.dat bs=1M count=1'        # Creates a file of 1mb size (all zeros)
    alias make5mb='dd if=/dev/zero of=5MB.dat bs=5M count=1'        # Creates a file of 5mb size (all zeros)
    alias make10mb='mdd if=/dev/zero of=10MB.dat bs=10M count=1'    # Creates a file of 10mb size (all zeros)

#  --------------------------------------------------
#   3.  Process Management
#  --------------------------------------------------
    
    # Find memory hogs
    alias memHogsTop='top | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

    # Find CPU hogs
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#  --------------------------------------------------
#   4.  Searching
#  --------------------------------------------------
    
    # Quickly search for file
    alias qfind='find . -name '
    
#  --------------------------------------------------
#   5.  Networking
#  --------------------------------------------------
    
    alias myip='curl icanhazip.com'                  # Public facing IP Address
    alias netCons='lsof -i'                          # Show all open TCP/IP sockets
    alias lsock='lsof -i -P'                         # Display open sockets
    alias lsockU='lsof -nP | grep UDP'               # Display only open UDP sockets
    alias lsockT='slsof -nP | grep TCP'              # Display only open TCP sockets
    alias openPorts='sudo lsof -i | grep LISTEN'     # All listening connections
    alias ping='ping -c 5'                           # Stop after 5 pings

#  --------------------------------------------------
#   6.  System Operations & Information
#  --------------------------------------------------

    # Update system
    alias sysupdate='sudo apt update && sudo apt full-upgrade -y'
  
#  --------------------------------------------------
#   7.  Git
#  --------------------------------------------------

    # Updating multiple repos with one command
    alias git-pull-all='find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'

#  --------------------------------------------------
#   8.  Encoding
#  --------------------------------------------------

    # Aliases to base64 encoding and decoding functions
    alias e64='encode64'
    alias ef64='encodefile64'
    alias d64='decode64'
