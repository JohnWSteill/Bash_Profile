#!/bin/bash
cd ~/bin/Bash_Profile
diff ReferenceProfiles/isitools_mirror/.bash_profile /isitools/.bash_profile
printf "\n --------     ISITOOLS  -------- \n\n"
ls -lart /isitools/.bash_*

printf "\n --------     MC  -------- \n\n"
ls -lart ~mikec/.bash_*
# cd ReferenceProfiles/isitools_mirror/ ; cp /isitools/.bash* .; git add .bash_profile*
# cd ../MC; cp ~mikec/.bash_profile_DIR/.bash_profile* .; git add .bash_profile_*
# git commit -am "good msg"
