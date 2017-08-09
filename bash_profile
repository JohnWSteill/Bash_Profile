BASH_PROFILE_HOME=$HOME/bin/Bash_Profile

# My version of /isitools/.bash_profile
# Also keep an eye on /w4home/mikec/.bash_profile/*
source $BASH_PROFILE_HOME/isitools_bash_profile

source $BASH_PROFILE_HOME/git_profile

alias envp="source ~/bin/GupEnv/bin/activate"
alias envp_off="source ~/bin/GupEnv/bin/deactivate"
export PYTHONPATH=~/bin:$PYTHONPATH 
shopt -s histappend    # append to history, don't overwrite it

PS1='\A  \h  \W > '

alias ls="ls --group-directories-first --color='auto'"
alias pta="python -m unittest discover"
alias aa8="autopep8 --in-place --aggressive --aggressive "
alias rsyncGup="rsync -au --delete --exclude .git --exclude *.pyc --exclude SRS --exclude usageScripts --exclude .gitignore ~/GUP/gup/ /isitools/GUP"

# History Stuff
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export HISTCONTROL=ignoreboth:erasedups  # no duplicate entries, cmds wth space
HISTIGNORE='ls:bg:fg:history'
export HISTSIZE=10000                   # big big history
export HISTFILESIZE=10000               # big big history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

function see_ls_colors {
    IFS=:     
    for i in $LS_COLORS     
    do        
     echo -e "\e[${i#*=}m$( x=${i%=*}; [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m" 
    done       
}

function tar_gd {
    tar -czf "$1.tgz" "$1"
    mv "$1.tgz" ~/GUP/Results_Delivered/
}
export -f tar_gd

path_append ()  { path_remove $1; export PATH="$PATH:$1"; }
path_prepend () { path_remove $1; export PATH="$1:$PATH"; }
path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

export PERL_LOCAL_LIB_ROOT="$HOME/lib/perl5"
function delete_local_perl {
    rm -rf $HOME/.cpan $HOME/.local/share/.cpan $PERL_LOCAL_LIB_ROOT/*
}
export -f delete_local_perl

function install_local_perl {
    delete_local_perl
    use_perl_518;
    mkdir -p $PERL_LOCAL_LIB_ROOT
    export PERL_MM_USE_DEFAULT=1
    perl -MCPAN -e 'install Bundle::CPAN'
    #cpan Text::NSP::Measures::2D::Fisher
    cpan Text::NSP::Measures::2D::Fisher::left
    cpan Class::Std
    cpan DateTime
    wget -P $PERL_LOCAL_LIB_ROOT http://search.cpan.org/CPAN/authors/id/S/SW/SWALTERS/SOAP-WSDL-3.003.tar.gz
    tar -zxf $PERL_LOCAL_LIB_ROOT/SOAP-WSDL-3.003.tar.gz -C $PERL_LOCAL_LIB_ROOT
    perl $PERL_LOCAL_LIB_ROOT/SOAP-WSDL-3.003/bin/wsdl2perl.pl -b $PERL_LOCAL_LIB_ROOT http://www.ebi.ac.uk/europepmc/webservices/soap?wsdl
}


function dontUsePerl510 {
    ere_p510="perl5\.10"
    for p in ${PATH//:/ }; do 
        if [[ $p =~ $ere_p510 ]]; then 
            path_remove $p
        fi 
    done
}
export -f dontUsePerl510


function use_perl_518 {
    dontUsePerl510
    export PERL5LIB='/isitools/perl5.18.2/lib/5.18.2/lib/perl5:/isitools/perl5.18.2/lib/5.18.2/x86_64-linux:/isitools/perl5.18.2/lib/5.18.2:/isitools/perl5.18.2/lib/5.18.2/x86_64-linux-thread-multi-ld'
    export PERL5LIB="$PERL5LIB:$PERL_LOCAL_LIB_ROOT:$PERL_LOCAL_LIB_ROOT/lib/perl5"
    export PERL_MB_OPT="--install_base $PERL_LOCAL_LIB_ROOT"
    export PERL_MM_OPT="INSTALL_BASE=$PERL_LOCAL_LIB_ROOT" 
    export PATH="$PATH:$PERL_LOCAL_LIB_ROOT/bin"
    alias cpan="/isitools/perl5.18.2/bin/cpan"
    alias perl="/isitools/perl5.18.2/bin/perl"
    PS1='\A  \h(perl5.18)  \W > '
}
export -f use_perl_518
envp
