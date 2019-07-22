# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -alh --color'

# Make parent dirs if they are missing
alias mkdir='mkdir -pv'
# Lets include vim like exit commands
alias :q="exit"
alias :Q="exit"

#History
shopt -s histappend
shopt -s cmdhist
HISTCONTROL=ignoredups
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTIGNORE="&:ls:[bf]g:exit"

#Handling Utf-8
export LESSCHARSET=utf-8

# Settings for interactive shell only inside this block
if [[ $- == *i* ]]
then

#    #SSH Agent
#    if [ -z "$SSH_AUTH_SOCK" ] ; then
#        inTemp=$(find /tmp -maxdepth 2 -type s -name "agent*" -user $USER -printf '%T@ %p\n' 2>/ansible-ansible-dev/null |sort -n|tail -1|cut -d' ' -f2)
#        if [[ "" != "$inTemp" ]]
#        then
#            SSH_AUTH_SOCK="$inTemp"
#            export SSH_AUTH_SOCK
#        else
#            eval `ssh-agent -s`
#            ssh-add
#        fi
#    fi

    #Screen Prompt - extra details if we are inside a screen session
    screenPrompt=""
    if [[ "" != "${STY}" ]]
    then
        screenPrompt="(screen: ${STY})\n"
    fi
    #Prompt
    function redPrompt(){
        export PS1=${screenPrompt}'\[\e[1m\]${PWD}\[\e[0m\]'"\n\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;9m\]\h\[$(tput sgr0)\] "
    }
    function bluePrompt(){
        export PS1=${screenPrompt}'\[\e[1m\]${PWD}\[\e[0m\]'"\n\[\033[38;5;32m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;32m\]\h\[$(tput sgr0)\] "
    }

    if [[ "$(whoami)" == "root" ]]
    then
        redPrompt
    else
        bluePrompt
    fi

    #Prevent Ctrl+S Freezing things
    stty -ixon

    # fix spelling errors for cd, only in interactive shell
    shopt -s cdspell

    # More useful bash completelion setting
    bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
    bind "set bell-style none" # no bell
    bind "set show-all-if-ambiguous On" # show list automatically, without double tab
    complete -r cd  # completion on symlinks is unusual and a __complete__ pain in the arse. Let's remove it

    alias gti=git

    ## To install
    ## dnf -y install bash-completion
    [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
        . /usr/share/bash-completion/bash_completion

    export EDITOR=vim
    alias vi="vim"
fi

# Moves up a number of dirs
up(){
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
    do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# Extract everything
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

