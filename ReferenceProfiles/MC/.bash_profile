# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=/isitools/boost_1_60_0:/isitools/boost_1_60_0/bin:/opt:/opt/apache2:/opt/apache2/bin:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local:/usr/local/bin:/usr/local/lib64:/isitools/rshiny_server/shiny-server/bin

#source /w4home/mikec/.bash_profile
#source /isitools/.bash_profile

export BOOST_ROOT=/isitools/boost_1_60_0
export BOOST_INCLUDEDIR="$BOOST_ROOT/include"
export BOOST_LIBRARYDIR="$BOOST_ROOT/lib"

export PERL_LOCAL_LIB_ROOT=/isitools/perl5.18.2/lib/5.18.2
export PERL_MB_OPT=/isitools/perl5.18.2/lib/5.18.2
export PERL_MM_OPT=INSTALL_BASE=/isitools/perl5.18.2/lib/5.18.2
#export PERL5LIB='/isitools/perl5.18.2/lib/5.18.2/lib/perl5:/isitools/perl5.18.2/lib/5.18.2/x86_64-linux:/isitools/perl5.18.2/lib/5.18.2:/isitools/perl5.18.2/lib/5.18.2/x86_64-linux-thread-multi-ld'
export PERL5LIB=/isitools/perl5.18.2/lib/5.18.2/lib/perl5
export PATH=/isitools/perl5.18.2:/isitools/perl5.18.2/bin:/isitools/perl5.18.2/lib/5.18.2/lib/perl5:$PATH:

#export PERL_LOCAL_LIB_ROOT=/isitools/perl5.22.2/lib/5.22.2
#export PERL_MB_OPT=/isitools/perl5.22.2/lib/5.22.2
#export PERL_MM_OPT=INSTALL_BASE=/isitools/perl5.22.2/lib/5.22.2
##export PERL5LIB='/isitools/perl5.22.2/lib/5.22.2/lib/perl5:/isitools/perl5.22.2/lib/5.22.2/x86_64-linux:/isitools/perl5.22.2/lib/5.22.2:/isitools/perl5.22.2/lib/5.22.2/x86_64-linux-thread-multi-ld'
#export PERL5LIB=/isitools/perl5.22.2/lib/5.22.2/lib/perl5
#export PATH=/isitools/perl5.22.2:/isitools/perl5.22.2/bin:/isitools/perl5.22.2/lib/5.22.2/lib/perl5:$PATH:

#export PERL_LOCAL_LIB_ROOT=/isitools/perl5.10.1/lib/5.10.1 
#export PERL_MB_OPT=/isitools/perl5.10.1/lib/5.10.1
#export PERL_MM_OPT=INSTALL_BASE=/isitools/perl5.10.1/lib/5.10.1
#export PERL5LIB='/isitools/perl5.10.1/lib/5.10.1/lib/perl5:/isitools/perl5.10.1/lib/5.10.1/x86_64-linux:/isitools/perl5.10.1/lib/5.10.1:/isitools/perl5.10.1/lib/5.10.1/x86_64-linux-thread-multi-ld:/usr/lib64/perl5'
#export PATH=/isitools/CentOS-5:/isitools/CentOS-5/perl5.10.1/bin:/isitools/CentOS-5/perl5.10.1/lib:$PATH:

##Ron's PCA stuff:
#export R_HOME=/isitools/R-3.1.3_PCA/lib64/R
#export RHOMES=/isitools/R-3.1.3_PCA/lib64/R
#export RHOME=/isitools/R-3.1.3_PCA/lib64/R
#export PATH=/isitools/R-3.1.3_PCA/lib64/R:/isitools/R-3.1.3_PCA/bin:$PATH
#export R_LIBS=/isitools/R-3.1.3_PCA/lib64/R #DEFAULT SYSTEM R LIBRARY
#export R_LIBS_USER=/isitools/R-packages_3.1.3_PCA:/isitools/R-3.1.3_PCA/lib64/R
#export LD_LIBRARY_PATH=/$LD_LIBRARY_PATH:$R_HOME/bin
#
##export R_HOME=/var/www/PCA-Enrich4.2.1/scripts/R
##export RHOMES=/var/www/PCA-Enrich4.2.1/scripts/R
##export RHOME=/var/www/PCA-Enrich4.2.1/scripts/R
##export PATH=/var/www/PCA-Enrich4.2.1/scripts/R:/isitools/R-3.1.3_PCA/bin:$PATH
##export R_LIBS=/var/www/PCA-Enrich4.2.1/scripts/R #DEFAULT SYSTEM R LIBRARY
##export R_LIBS_USER=/isitools/R-packages_3.1.3_PCA:/var/www/PCA-Enrich4.2.1/scripts/R
##export LD_LIBRARY_PATH=/$LD_LIBRARY_PATH:$R_HOME/bin
##export PATH

## Default R-3.1.3 stuff:
#export R_HOME=/isitools/R-3.1.3/lib64/R
#export RHOMES=/isitools/R-3.1.3/lib64/R
#export RHOME=/isitools/R-3.1.3/lib64/R
#export PATH=/isitools/R-3.1.3/lib64/R:/isitools/R-3.1.3/bin:$PATH
#export R_LIBS=/isitools/R-3.1.3/lib64/R #DEFAULT SYSTEM R LIBRARY
#export R_LIBS_USER=/isitools/R-packages_3.1.3
#export LD_LIBRARY_PATH=/$LD_LIBRARY_PATH:$R_HOME/bin

# Default R-3.2.4 stuff:
export R_HOME=/isitools/R-3.2.4/lib64/R
export RHOMES=/isitools/R-3.2.4/lib64/R
export RHOME=/isitools/R-3.2.4/lib64/R
export PATH=/isitools/R-3.2.4/lib64/R:/isitools/R-3.2.4/bin:$PATH
export R_LIBS=/isitools/R-3.2.4/lib64/R #DEFAULT SYSTEM R LIBRARY
export R_LIBS_USER=/isitools/R-packages_3.2.4
export R_PROFILE=/isitools/R-3.2.4
export LD_LIBRARY_PATH=/$LD_LIBRARY_PATH:$R_HOME/bin

### ALIASES ###
alias glp="git log --pretty=format:\"%cr: %s\""
alias glg="git log --oneline --decorate --graph --all"
alias glgc="git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""

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
alias ss6="sudo ssh 10.129.28.6"

alias netl="netstat -na |grep LIST |grep tcp"
alias nete="netstat -na |grep ESTAB |grep tcp"

alias lrt="ls -ltr "
