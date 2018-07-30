#!/bin/bash

PATH=$HOME/bin:/usr/bin:/bin:/usr/lib64:/usr/lib
[[ "$(uname -s)" == "Linux" ]] && onMac=false || onMac=true
BASH_PROFILE_HOME=$HOME/bin/Bash_Profile
source $BASH_PROFILE_HOME/alias_and_env_profile
source $BASH_PROFILE_HOME/git_profile
if [[ $(hostname) != *"biostat"* ]]; then
    source $BASH_PROFILE_HOME/R_and_Python_and_PATH_profile
    source $BASH_PROFILE_HOME/perl_profile
fi

if ! [ $onMac == true ] 
then 
    umask 0002
    REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//` 
    echo "This is a CentOS $REV machine"
    export LD_LIBRARY_PATH=/$LD_LIBRARY_PATH:/isitools/gcc4.8/isl0.12.2/lib
    export WORKON_HOME=$HOME/bin/Python_Virtual_Envs
    use_R 3.1.3 #DEFAULT SYSTEM R LIBRARY
    use_Python 3.6.6 
fi

if [ $UID -gt 99 ] && [ "`id -gn`" = "`id -un`" ]; then
    umask 002
else
    umask 022
fi
