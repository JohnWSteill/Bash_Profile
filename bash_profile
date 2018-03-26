#!/bin/bash
if ([[ "$(uname -s)" == "Linux" ]]) 
then
    onMac=false
else
    onMac=true
fi

BASH_PROFILE_HOME=$HOME/bin/Bash_Profile

source $BASH_PROFILE_HOME/alias_and_env_profile
source $BASH_PROFILE_HOME/git_profile
if [[ $(hostname) != *"biostat"* ]]; then
    source $BASH_PROFILE_HOME/R_and_Python_and_PATH_profile
    source $BASH_PROFILE_HOME/perl_profile
fi

