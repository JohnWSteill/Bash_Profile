#!/bin/bash

PATH=$HOME/bin:/usr/bin:/bin:/usr/lib64:/usr/lib
[[ "$(uname -s)" == "Linux" ]] && onMac=false || onMac=true
BASH_PROFILE_HOME=$HOME/bin/Bash_Profile
source $BASH_PROFILE_HOME/git_profile

source $BASH_PROFILE_HOME/R_Python_and_Perl_Envs_profile
source $BASH_PROFILE_HOME/alias_and_env_profile

if ! [ $onMac == true ] 
then 
    umask 0002
    REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//` 
    echo "This is a CentOS $REV machine"
    export LD_LIBRARY_PATH="/isitools/gcc4.8/isl0.12.2/lib:\
/isitools/gcc4.9.4/lib64"
    # Uses sytem defaults, defined in R_Python_and_Perl_Envs_profile 
    use_R 
    use_Python 
    use_Perl
fi
export PATH=${PATH}:/Users/jsteill/edirect
export PATH=${PATH}:/usr/X11/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL="ignoreboth:erasedups" # no duplicate entries, cmds wth space

