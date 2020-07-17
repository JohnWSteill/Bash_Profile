#!/bin/bash

export WORKON_HOME=$HOME/bin/Python_Virtual_Envs

PS1='\A  \h  \W > '
PS1='\[\e[1;91m\]\A  \h  \W\[\e[0m\] > '

PATH=$HOME/bin:/usr/bin:/bin:/usr/lib64:/usr/lib:usr/local/bin
[[ "$(uname -s)" == "Linux" ]] && onMac=false || onMac=true

BASH_PROFILE_HOME=$HOME/bin/Bash_Profile
source $BASH_PROFILE_HOME/git_profile

if [ $onMac == 'true' ] 
then
    alias vi=mvim
    export PATH="/Users/jsteill/anaconda/bin:$PATH"
    export PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
    alias mysql="/Applications/MAMP/Library/bin/mysql"
else 
    umask 0002
    REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//` 
    echo "This is a CentOS $REV machine"
    export LD_LIBRARY_PATH=/isitools/gcc4.9.4/lib64
    export LD_LIBRARY_PATH=/isitools/gcc4.8/isl0.12.2/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$HOME/bin/vim_py374_install/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$HOME/bin/Python3.7.4/python/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$HOME/bin/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
    export PATH=$HOME/bin/Python3.7.4/python/bin/:$PATH
    export PATH=/isitools/sratoolkit.2.4.2-centos_linux64/bin/:$PATH
    export PATH=/isitools/perl5.16.3/bin:/isitools/perl5.16.3/lib:$PATH
    export PATH=/isitools/R-3.5.1/lib64/R:/isitools/R-3.5.1/bin:$PATH
    export PATH=/isitools/bowtie-1.2.2:$HOME/bin:$PATH
    export PATH=/isitools/anaconda3/bin:$HOME/bin:$PATH # For Pandoc in Rmd

    export PYTHONPATH=$HOME/bin/Python3.7.4/python/bin/
    # Uses sytem defaults, defined in R_Python_and_Perl_Envs_profile 
    source $BASH_PROFILE_HOME/alias_and_env_profile
    source $BASH_PROFILE_HOME/R_Python_and_Perl_Envs_profile
    use_R 
    use_Perl
fi

alias ssh="ssh -o ServerAliveInterval=60"
# Save and reload the history after each command finishes
shopt -s histappend
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export HISTSIZE=10000                   # big big history
export HISTFILESIZE=10000               # big big history
export HISTCONTROL="ignoreboth:erasedups" # no duplicate entries, cmds wth space
