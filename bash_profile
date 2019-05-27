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
    export PATH=/isitools/sratoolkit.2.4.2-centos_linux64/bin/:$PATH
fi
