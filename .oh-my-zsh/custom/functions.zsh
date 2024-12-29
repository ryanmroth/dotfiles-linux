#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH functions.
#  Note:        Intended to be used in concert with Oh My Zsh
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Make Terminal Better (Remapping defaults and adding functionality)
#  2.  Process Management
#  3.  Searching
#  4.  Networking, Domain, Etc.
#  5.  Docker
#  6.  Encoding
#  7.  Pentesting
#  8.  Misc
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Make Terminal Better
#  --------------------------------------------------

    # Directories
    # ---------------
    
    function cd() {                   
      builtin cd "$@"; ll;              # Always list directory contents upon 'cd'
    }

    function mcd () { 
      mkdir -p "$1" && cd "$1";         # Makes new directory and jumps inside
    }

    # Other
    # ---------------
    
    # Search manpage given in agument '1' for term given in argument '2' (case insensitive)
    # displays paginated result with colored search terms and two lines surrounding each hit.
    # Example: mans mplayer codec
    function mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

    # Remind yourself of an alias (given some part of it)
    function showa () { 
      /usr/bin/grep --color=always -i -a1 $@ ~/.config/ohmyzsh/aliases.zsh | grep -v '^\s*$' | less -FSRXc ; 
    }

#  --------------------------------------------------
#   2.  Process Management
#  --------------------------------------------------
 
    # List processes owned by my user
    function my_ps() { 
      ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; 
    }

    # Find out the pid of a specified process
    # Note that the command name can be specified via a regex
    # E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
    # Without the 'sudo' it will only find processes of the current user
    function findPid () { 
      lsof -t -c "$@" ; 
    }

#  --------------------------------------------------
#   3.  Searching
#  --------------------------------------------------

    # Find file under the current directory
    function ff () {
      /usr/bin/find . -name "$@" ;
    }

    # Find file whose name starts with a given string
    function ffs () {
      /usr/bin/find . -name "$@"'*' ;
    }

    # Find file whose name ends with a given string
    function ffe () {
      /usr/bin/find . -name '*'"$@" ;
    }

#  --------------------------------------------------
#   4.  Networking, Domain, Etc.
#  --------------------------------------------------
#
    # Unshorten link
    #function unshort {
    #    readonly link=${1:?"The shortened link must be specified."}
    #    curl -k -v -I "$link" 2>&1 | grep -i "< location" | cut -d " " -f 3
    #}

    # Display useful host related informaton
    function ii() {
      echo -e "\nYou are logged on $HOST"
      echo -e "\nAdditionnal information:$NC " ; uname -a
      echo -e "\nUsers logged on:$NC " ; w -h
      echo -e "\nCurrent date:$NC " ; date
      echo -e "\nMachine stats:$NC " ; uptime
      echo -e "\nCurrent network location:$NC " ; scselect
      echo -e "\nPublic facing IP Address:$NC " ; myip
      echo
    }

    # Start an HTTP server from a directory, optionally specifying the port
    function server() {
      local port="${1:-8000}"
      python3 -m http.server "$port"
    }
    
    # Show all the names (CNs and SANs) listed in the SSL certificate
    # for a given domain
    function getcertnames() {
      if [ -z "${1}" ]; then
        echo "ERROR: No domain specified.";
        return 1;
	    fi;

      local domain="${1}";
      echo "Testing ${domain}…";
      echo ""; # newline

      local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
        | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

      if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText=$(echo "${tmp}" \
          | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
          no_serial, no_sigdump, no_signame, no_validity, no_version");
        echo "Common Name:";
        echo ""; # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
        echo ""; # newline
        echo "Subject Alternative Name(s):";
        echo ""; # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
          | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
        return 0;
      else
        echo "ERROR: Certificate not found.";
        return 1;
      fi;
    }

#  --------------------------------------------------
#   5.  Docker
#  --------------------------------------------------

    # Drop into an interactive shell with bash
    function dockershell() {
      docker run --rm -i -t --entrypoint=/bin/bash "$@"
    }

    # Drop into an interactive shell with sh
    function dockershellsh() {
        docker run --rm -i -t --entrypoint=/bin/sh "$@"
    }

    # Drop into an interactive shell with bash and mount current working directory inside
    function dockershellhere() {
        dirname=${PWD##*/}
        docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
    }

    # Drop into an interactive shell with sh and mount current working directory inside
    function dockershellshhere() {
        docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
    }

    # Docker For Pentesting
    # ---------------

    # Run any Impacket example just by typing "impacket"
    # E.g. impacket wmiexec.py lab.example.com/user@192.168.1.1
    function impacket() {
        docker run --rm -it f1rstm4tter/impacket "$@"
    }

    #  Mount the current directory into /tmp/serve and then
    #  use Impacket’s smbserver.py to create a share at that directory
    function smbservehere() {
        local sharename
        [[ -z $1 ]] && sharename="SHARE" || sharename=$1
        docker run --rm -it -p 445:445 -v "${PWD}:/tmp/serve" f1rstm4tter/impacket smbserver.py -smb2support $sharename /tmp/serve
    }

    # Run this in a directory to serve it over 80 and 443
    function nginxhere() {
        docker run --rm -it -p 80:80 -p 443:443 -v "${PWD}:/srv/data" f1rstm4tter/nginxserve
    }

    # Mount whatever files you want to share
    # into /srv/data/share and expose it on port 80
    function webdavhere() {
        docker run --rm -it -p 80:80 -v "${PWD}:/srv/data/share" f1rstm4tter/webdav
    }

    # Run Metasploit and mount ~/.msf4 directory that gets shared across every instance
    function metasploit() {
        docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" metasploitframework/metasploit-framework ./msfconsole "$@"
    }

    # Same above except forward every port from 8443-8500 when metasploit is launched.
    # As long as a listener is set somewhere in that range - you can catch it
    function metasploitports() {
        docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -p 8443-8500:8443-8500 metasploitframework/metasploit-framework ./msfconsole "$@"
    }

    # Run the msfvenom command and save the payload
    # E.g. msfvenomhere -a x86 --platform windows -p windows/messagebox TEXT="pwned" -f dll -o /data/pwned.dll
    function msfvenomhere() {
        docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -v "${PWD}:/data" metasploitframework/metasploit-framework ./msfvenom "$@"
    }

    # Simple JavaScript server that echos any HTTP request it receives it to stdout
    # This starts a local listener on 80
    function reqdump() {
        docker run --rm -it -p 80:3000 f1rstm4tter/reqdump
    }

    # Purpose-built Docker image starts a webserver that
    # accepts any file POST’ed to it and saves it to disk
    function postfiledumphere() {
        docker run --rm -it -p80:3000 -v "${PWD}:/data" f1rstm4tter/postfiledump
    }

    # MobSF Docker image
    function mobsf() {
      docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
    }

#  --------------------------------------------------
#   6.  Encoding
#  --------------------------------------------------
    
    function encode64() {
      if [[ $# -eq 0 ]]; then
        cat | base64
      else
        printf '%s' $1 | base64
      fi
    }

    function encodefile64() {
      if [[ $# -eq 0 ]]; then
        echo "You must provide a filename"
      else
        base64 -i $1 -o $1.txt
        echo "${1}'s content encoded in base64 and saved as ${1}.txt"
      fi
    }

    function decode64() {
      if [[ $# -eq 0 ]]; then
        cat | base64 --decode
      else
        printf '%s' $1 | base64 --decode
      fi
    }

#  --------------------------------------------------
#   7.  Pentesting
#  --------------------------------------------------

    # Find subdomains
    function findsubs() {
      if [[ $# -eq 0 ]]; then
        echo "You must provide a domain name."
      else
        trimmed=$(echo "$1" | cut -f 1 -d '.')
        subfinder -d $1 -all -cs > temp ; cat temp | cut -d "," -f 1 > $trimmed-subdomains.txt ; rm temp
        echo
        echo "${1}'s subdomains enumerated and saved as $trimmed-subdomains.txt"
      fi
    }

    # Find alive subdomains
    function livesubs() {
      if [[ $# -eq 0 ]]; then
        echo "You must provide file containing subdomains."
      else
        trimmed=$(echo "$1" | cut -f 1 -d '-')
        cat $1 | httpx -title -wc -sc -cl -ct -location -web-server -asn -o $trimmed-alive-subdomains.txt
        echo
        echo "${1}'s live subdomains evaluated and saved as $trimmed-alive-subdomains.txt"
      fi
    }

    # Capture screenshots of subdomains
    function capturesubs() {
      if [[ $# -eq 0 ]]; then
        echo "You must provide file containing subdomains."
      else
        cat $1 | cut -f 1 -d ' ' | gowitness scan file -f -
        echo
        echo "${1}'s live subdomains captured and saved"
      fi
    }

    # The three above in a single function
    function subanalyzer() {
      if [[ $# -eq 0 ]]; then
        echo "You must provide a domain name."
      else
        echo
        echo -e "[\e[1;32mBGN\e[0m] Executing subdomain analysis."
        trimmed=$(echo "$1" | cut -f 1 -d '.')
        echo -e "[\e[1;35mINF\e[0m] Making directory to hold results."
        mkdir $trimmed-results > /dev/null 2>&1
        echo -e "[\e[1;35mINF\e[0m] Directory \e[1;36m$trimmed-results\e[0m created."
        echo -e "[\e[1;35mINF\e[0m] Entering results directory."
        cd $trimmed-results > /dev/null 2>&1
        echo -e "[\e[1;35mINF\e[0m] Identifying subdomains."
        subfinder -d $1 -all -cs > temp 2>&1 ; cat temp | cut -d "," -f 1 > $trimmed-subdomains.txt ; cat temp > subanalyzer.log ; rm temp
        echo -e "[\e[1;35mINF\e[0m] Subdomains saved as \e[1;36m$trimmed-subdomains.txt\e[0m."
        echo -e "[\e[1;35mINF\e[0m] Evaluating alive status of identified subdomains."
        cat $trimmed-subdomains.txt | httpx -title -wc -sc -cl -ct -location -web-server -asn -o $trimmed-alive-subdomains.txt >> subanalyzer.log 2>&1
        echo -e "[\e[1;35mINF\e[0m] Alive subdomains saved as \e[1;36m$trimmed-alive-subdomains.txt\e[0m."
        echo -e "[\e[1;35mINF\e[0m] Capturing screenshots of alive subdomains."
        cat $trimmed-alive-subdomains.txt | cut -f 1 -d ' ' | gowitness scan file -q --screenshot-format png --screenshot-fullpage -f - >> subanalyzer.log 2>&1
        echo -e "[\e[1;35mINF\e[0m] Screenshots of alive subdomains saved in \e[1;36mscreenshots\e[0m directory."
        echo -e "[\e[1;32mEND\e[0m] Analysis completed successfully. Log stored as \e[1;36msubanalyzer.log\e[0m"
        echo
      fi
    }

#  --------------------------------------------------
#   8.  Misc
#  --------------------------------------------------
