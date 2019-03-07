# .bash_profile

export HOME=/w5home/mikec

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

export PATH=/isitools/boost_1_60_0:/isitools/boost_1_60_0/bin:/opt:/opt/apache2:/opt/apache2/bin:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local:/usr/local/bin:/usr/local/lib64:/isitools/rshiny_server/shiny-server/bin:$PATH

#source /isitools/.bash_profile

source /isitools/.bash_profile_perl5.24.4
source /isitools/.bash_profile_python2.7.15
source /isitools/.bash_profile_R-3.4.1
source /isitools/.bash_profile_vim8

export BOOST_ROOT=/isitools/boost_1_60_0
export BOOST_INCLUDEDIR="$BOOST_ROOT/include"
export BOOST_LIBRARYDIR="$BOOST_ROOT/lib"

if [ -d "$HOME/.local/vim/bin" ] ; then
  PATH="$HOME/.local/vim/bin:$PATH"
fi

### ALIASES ###
alias glp="git log --pretty=format:\"%cr: %s\""
alias glg="git log --oneline --decorate --graph --all"
alias glgc="git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""

# git
function git_ls_a {
    for fn in `ls`; do
        echo "$(git log -1 --format="%ad" -- $fn) $fn"
    done
}
export -f git_ls_a

alias auth="ssh auth.morgridge.us"
alias m2="ssh mir-2.morgridge.us"
alias m3="ssh mir-3.morgridge.us"
alias m4="ssh mir-4.morgridge.us"
alias m5="ssh mir-4.morgridge.us"
alias m6="ssh mir-6.morgridge.us"
alias m9="ssh mir-9.morgridge.us"
alias m12="ssh galaxydev.morgridge.us"
alias m19="ssh mir-19.morgridge.us"
alias m20="ssh mir-20.morgridge.us"
alias m24="ssh confluence.morgridge.us"
alias m29="ssh jira.morgridge.us"
alias m36="ssh mir-36.morgridge.us"
alias m37="ssh mir-37.morgridge.us"
alias m38="ssh mir-38.morgridge.us"
alias m39="ssh galaxy.morgridge.us"
alias m49="ssh mir-49.morgridge.us"
alias m80="ssh mir-80.morgridge.us"
alias m81="ssh mir-81.morgridge.us"
alias ss6="sudo ssh 10.129.28.6"

alias netl="netstat -na |grep LIST |grep tcp"
alias nete="netstat -na |grep ESTAB |grep tcp"

alias lrt="ls -ltr "
