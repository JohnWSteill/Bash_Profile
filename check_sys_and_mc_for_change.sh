#!/bin/bash
cd ~/bin/Bash_Profile
diff ReferenceProfiles/isitools_mirror/.bash_profile /isitools/.bash_profile
printf "\n --------     ISITOOLS  -------- \n\n"
ls -lart /isitools/.bash_*

printf "\n --------     MC  -------- \n\n"
ls -lart ~mikec/.bash_*

