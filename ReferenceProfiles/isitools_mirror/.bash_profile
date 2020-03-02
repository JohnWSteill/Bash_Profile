#!/bin/bash

REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
echo "This is a CentOS $REV machine"

# Even for non-interactive, non-login shells.
if [ $UID -gt 99 ] && [ "`id -gn`" = "`id -un`" ]; then
        umask 002
else
        umask 022
fi

##### User-specific environment and startup programs #####
if [ "$USER" != "shiny" ]; then export HOME=/w5home/$USER
fi
if [ "$USER" = "shiny" ]; then export HOME=/mnt/isi5shared/Shiny
fi
export SVN_EDITOR=vi
PATH=/usr/bin:/bin:/usr/lib64:/usr/include:$HOME/bin:$PATH
umask 0002

#####CENTOS-6+7#####
if [ "$USER" = "root" ]; then export HOME=/root
export PATH=/usr/sbin:/usr/bin:/bin:/usr/lib64:$PATH
fi

if [ "$USER" != "root" ] && [ "$USER" != "shiny" ]; then export HOME=/w5home/$USER
export PATH=/isitools/anaconda3/bin:/isitools/anaconda3:/isitools/orca/orca:/isitools/singularity3.2/bin:/isitools/go/bin:/isitools/jdk-10:/isitools/jdk-10/bin:/isitools/jdk-10/lib:/isitools/apache-ant-1.10.5:/isitools/apache-ant-1.10.5/bin:/isitools/apache-ant-1.10.5/bin:/isitools/apache-ant-1.10.5/lib:/isitools/MATLAB/R2018b:/isitools/julia-1.0.3/bin:/isitools/julia-1.0.3:/isitools:/isitools/maker-2.31.10:/isitools/maker-2.31.10/bin:/isitools/hal/bin:/isitools/hdf5/bin:/isitools/cactus:/isitools/cactus/bin:/isitools/PCAME-4.2.3:/isitools/bam2fastx/build:/isitools/cmake3.8.1/bin:/isitools/bowtie-0.12.9:/isitools/trinityrnaseq-Trinity-v2.3.2:/isitools/ncbi-blast-2.7.1+/bin:/isitools/blat:/isitools:/isitools/FastQC:/isitools/rsem_eval_1.3:/isitools/STAR_2.3.0e:/isitools/CASAVA_v1.8.2/bin:/isitools/meme/bin:/isitools/novocraft-3.02:/isitools/samtools-1.9/bin:/isitool/samtools-1.9/share:/isitools/bedtools-2.27/bin:/isitools/matrix2png_1.2.2/bin:/isitools/bowtie2-2.3.4.1:/isitools/bwa-0.7.5a:/isitools/clustalw2.1:/isitools/boost_1_65_1:/isitools/boost_1_65_1/lib:/isitools/boost_1_65_1/include/boost:/isitools/cufflinks:/isitools/miRanda3.3a/bin:/isitools/454/bin:/isitools/454/apps:/isitools/MaSuRCA2.2.1:/isitools/MaSuRCA2.2.1/lib:/isitools/MaSuRCA2.2.1/lib:/isitools/ucsc/linux.x86_64:/isitools/fftw3.3.4:/isitools/fftw3.3.4/bin:/isitools/fftw3.3.4/lib:/isitools/csem-2.4:/isitools/sratoolkit.2.8.2-1-centos_linux64/bin:/isitools/swig-3.0.5:/isitools/hp-bootstrap/bin:/isitools/.cabal/bin:/isitools/fasta-36.3.8c/bin:/isitools/illumina/bcl2fastq2-v2.17.1.14/bin:/isitools/usearch:/isitools/cdhit-master:/isitools/SOAPdenovo2-src-r240:/isitools/FALCON-integrate:/isitools/FALCON-integrate/scripts:/isitools/FALCON-integrate/fc_env/bin:/isitools/canu-1.5/Linux-amd64/bin:/isitools/tabix-0.2.6:/isitools/FALCON_unzip-master:/isitools/mummer4.0beta2/bin:/isitools/Reapr_1.0.18:/isitools/bamtools:/isitools/bamtools/bin:/isitools/bamtools/lib64:/isitools/augustus-3.3.2:/isitools/augustus-3.3.2/bin:/isitools/hmmer3.1b2/bin:/isitools/supernova-2.0.1:/isitools/jellyfish-2.2.10:/isitools/ncbi-magicblast-1.5.0/bin:/isitools/trf:/isitools/hisat2-2.1.0:/isitools/Scaff10X/src/scaff-bin:/isitools/homer_4.11/bin:/isitools/kyoto/bin:/isitools/lastz_1.0.4/bin:/isitools/reg-gen:/isitools/IGV_2.7.2:/isitools/IGV_2.7.2/lib:/isitools/MashMap/bin:/isitools/libcerf:$PATH 
export ISIHOME=/isitools
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$R_HOME/bin:/isitools/gcc4.8/isl0.12.2/lib:/isitools/Python2.7.4/lib
#export LD_LIBRARY_PATH=/isitools/gcc4.9.4/lib64:/isitools/Python2.7.4/lib:$R_HOME/bin:$LD_LIBRARY_PATH
export JAVA_HOME=/isitools/jdk-10
export ANT_HOME=/isitools/apache-ant-1.10.5
export GOROOT=/isitools/go
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/.bds/
fi

if [ "$USER" = "mikec" ]; then export HOME=/w5home/mikec 
HISTFILESIZE=500000
export PS1='\n[\u@\h \! \w]\n\[\e[32m\]$ \[\e[0m\]'

### use pigz
gzip() {
 pigz "$@"
}
export -f gzip
gunzip() {
 unpigz "$@"
}
export -f gunzip
fi


##### PERL virtual env #####
if  [ "$USER" = "root" ]; then
echo "Logging on as root user"
fi

if  [ "$USER" != "root" ] && [ "$USER" != "mikec" ]; then
source /isitools/.bash_profile_perl5.24.4
fi

if  [ "$USER" = "mikec" ]; then
source /isitools/.bash_profile_perl5.24.4
fi

echo $PATH

##### PYTHON virtual envs #####
if  [ "$USER" != "mikec" ]; then
source /isitools/.bash_profile_python2.7.12
fi

if  [ "$USER" = "mikec" ]; then
source /isitools/.bash_profile_python3.7.2
fi

##### R env variables #####
if [ "$USER" != "galaxy" ]; then
source /isitools/.bash_profile_R-3.5.1
fi
if [ "$USER" = "galaxy" ]; then
# R-3.0.2
export R_HOME=/isitools/R-3.0.2
export PATH=/isitools/R-3.0.2/lib64/R:/isitools/R-3.0.2/bin:$PATH
export R_LIBS=/isitools/R-3.0.2/lib64/R #DEFAULT SYSTEM R LIBRARY
export R_LIBS_USER=/isitools/R-packages_3.0.2
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$R_HOME/bin
fi

if [ "$USER" = "shiny" ]; then
export HOME=/mnt/isi5shared/Shiny
export R_HOME=/isitools/R-3.2.4
export PATH=/isitools/R-3.2.4/lib64/R:/isitools/R-3.2.4/bin:$PATH
export R_LIBS=/isitools/R-3.2.4/lib64/R #DEFAULT SYSTEM R LIBRARY
export R_LIBS_USER=/isitools/R-3.2.4/lib64/R #DEFAULT SYSTEM R LIBRARY
#export R_LIBS_USER=/isitools/R-packages_3.2.4
export R_PROFILE=/isitools/R-3.2.4
export R_PROFILE_USER=/w5home/shiny/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$R_HOME/bin
fi

source /isitools/.bash_profile_sge

##### VIM8 env variables #####
#if [ "$USER" = "mikec" ]; then
#source /isitools/.bash_profile_vim8
#fi

echo $PATH
export PATH
unset USERNAME

