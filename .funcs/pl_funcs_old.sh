#
# #=========================================
# # FUN WITH FUNCTIONS
# #
# # These functions are aliased here rather
# #  than in the .aliases dir
# #=========================================
#
# function clean_stat_reports()
# {
#     a=$PWD
#
#     PPM_LITE_FILES=("Refresh_status_report_dialog"
# 	     "Status_report_do_snapshot"
# 	     "Custom_status_report_top_fields"
# 	     "Confirm_status_report_refresh_items")
#
#     VISN_FILES=("Refresh_status_report_dialog"
# 	     "Custom_status_report_top_fields")
#
#
#     PARKLAND_FILES=("Refresh_status_report_dialog")
#
#
#     cd ~/dev/dat/ppm_lite
#     echo "In ppm_lite"
#     for P in ${PPM_LITE_FILES[@]}
#     do
# 	echo "Removing ${P}.dat"
# 	rm -f ${P}.dat
#     done
#
#     unset P
#
#     cd ~/dev/dat/client/visn9
#     echo "In visn9"
#     for P in ${VISN_FILES[@]}
#     do
# 	echo "Removing ${P}.dat"
# 	rm -f ${P}.dat
#     done
#
#     unset P
#
#     cd ~/dev/dat/client/parkland/it_pmo
#     echo "In parkland"
#     for P in ${PARKLAND_FILES[@]}
#     do
# 	echo "Removing ${P}.dat"
# 	rm -f ${P}.dat
#     done
#
#     cd ${a}
#     unset a PPM_LITE_FILES VISN_FILES PARKLAND_FILES P
# }
#
# # POP OPEN A NEW SHELL WINDOW. OPTIONAL: OPEN ONE WINDOW PER COMMAND STRING:
# #    $ pop 'cd ../config' 'ls' 'cd ~/dev/dat; rupdate -r'
# function pop()
# {
#     a='Using "$@" string: '
#     if [ $# == 0 ]; then
# 	xterm -bg ${BG4} -e bash -c "exec bash" -hold &
#     else
# 	NUM=$1
# 	for p in "$@"
# 	do
# 	    xterm -e bash -c "$p; exec bash" -hold &
# 	done
#
# 	# # you could also take the second arg as the # of windows to open:
# 	# NUM=$1
# 	# for j in `seq 1 ${NUM}`
# 	# do
# 	#     xterm -bg ${BG4} -e bash -c "exec bash" -hold &
# 	# done
#
#     fi
#     unset a NUM p
# #    xterm -geometry 80x50+50+0 -e bash -c "exec bash" -hold &  #-- make pop open quarter-screen sized -- doesn't work
# }
#
# function mnt()
# {
#     #mintty -t hello -e /bin/bash - &
#     mintty -i /Cygwin-Terminal.ico - &
# }
#
#
#
# # FOR MINTTY
# # GET ALL OUR WINDOWS SET UP, RUPDATE AND CHECK FOR FILES WE NEED
# function hello()
# {
#     a=$PWD
#     #mintty -ha -t sidecar bash &
#     mintty -i /Cygwin-Terminal.ico - &
#
#     i=0
#     while [ "$i" -lt 3 ]
#     do
#     	ssh_devlnx
#     	let "i+=1"
#     done
#
#     #cd ~/docs
#     #emacs *.txt *.org &
#     #check_files
#     #cd $a
#     unset a
# }
#
#
#
# # FOR XTERM
# # GET ALL OUR WINDOWS SET UP, RUPDATE AND CHECK FOR FILES WE NEED
# function hi()
# {
#     a=$PWD
#     xterm -bg ${BG3} -e bash -c "cd ~/test; rupdate -r; cd ~/dev; rupdate -r; exec bash" -hold &
#
#     i=0
#     while [ "$i" -lt 3 ]
#     do
#     	ssh_devlnx
#     	let "i+=1"
#     done
#
#     cd ~/docs
#     emacs *.txt &
#     check_files
#     cd $a
#     unset a
# }
#
# #rebase all
# function reball()
# {
#     # to do:
#     # send in an arg for the feature branch you want to update to?
#     # treat an arg as curr_repo. if no arg sent in, get curr_repo
#     #
#     # if [ ${#} -gt 0 ]; then
#     #     CURR_REPO
#     # fi
#
#
#     a=$PWD
#     cd ~/dev
#     CURR_REPO=`git symbolic-ref --short HEAD`
#     echo "----------------------------------------------------------------------"
#     echo ">>> checking out master branch"
#     git checkout master
#     echo ">>> pulling origin master"
#     git pull origin master
#     echo "----------------------------------------------------------------------"
#     echo ">>> checking out roll branch"
#     git checkout roll
#     git stash
#     echo ">>> rebasing with master"
#     git rebase master
#     git stash pop
#     echo "----------------------------------------------------------------------"
#     echo ">>> checking out feature branch"
#     git checkout proj-perms
#     git stash
#     echo ">>> rebasing with roll"
#     git rebase roll
#     git stash pop
#     git co ${CURR_REPO}
#     cd $a
#     unset a CURR_REPO
# }
#
# #roll out packages on roll branch
# alias ro='roll_to_roll'
# function roll_to_roll()
# {
#     if [ ${#} -gt 0 ]; then
#         a=$PWD
#         cd ~/dev
#         CURR_REPO=`git symbolic-ref --short HEAD`
#         git co roll
#         roll_out "$@"
#         git co ${CURR_REPO}
#         cd $a
#         unset a CURR_REPO
#     else
#         echo gimme some packages to roll, yo
#     fi
# }
#
#
# # RUPDATE ALL OF /DAT RECURSIVELY
# function rup()
# {
#     a=$PWD
#     cd /c/UserData/ryman.amanda/olddev/
#     rupdate -r
#     # cd ~/test/
#     # rupdate -r
#     cd $a
#     unset a
# }
#
# function ssh_devlnx()
# {
#     mintty -t dev-lnx -e /bin/bash -c 'read -pusername\($USERNAME\):\  SSHUSER; export DISPLAY=:$((UID%10000)).0; exec /usr/bin/ssh -XY ${SSHUSER:-$USERNAME}@dev-lnx.portland.perflogic.com' -hold &
# }
#
# # Reads through a text document and checks to see if any files in the document are available to check out.
# # If they're not, the RCS data is displayed.
# function check_files()
# {
#     b=$PWD
#     cd //dev-lnx/sites/dev.perflogic.com/__lib__/dat
#
#     TARGET_FILE=~/docs/check_files.txt
#     SMILE="ʕ•ᴥ•ʔ"
#     FROWN="ಠ_ಠ"
#     SHRUG="¯\_(ツ)_/¯"
#     FILL=">  "
#
#     echo "Let's find us some files to check out...."
#
#     while read FILE; do
#
# 	# check to see if the line is a comment or whitespace:
# 	TMP=${FILE:0:2}
#
# 	if [ "${TMP}" != "//" ] && [ "${FILE}" != "" ]; then
#
# 	    if [ -f ${FILE} ]; then
#
# 		RESULT=$(rlog -L -R ${FILE})
#
# 		if [[ -z "${RESULT// }" ]] ; then
# 		    echo "${FILL} ${SMILE} can haz ${FILE}" #echo "${FILL} [${FILE}] is available ${SMILE}"
# 		else
# 		    #rlog -N -h -l ${FILE}
# 		    echo "${FILL} ${FROWN} no can haz ${FILE}" #echo "${FILL} [${FILE}] is checked out by someone ${FROWN}"
# 		fi
# 	    else
# 		echo "${FILL} ${SHRUG} what can be ${FILE}" #echo "${FILL} [${FILE}] could not be found ${SHRUG}"
#
# 	    fi
# 	fi
#
#     done <${TARGET_FILE}
#
#     cd $b
#
#     unset b TARGET_FILE SMILE FROWN SHRUG FILL FILE TMP RESULT
# }
#
# # LOOK THROUGH TXT FILES IN DOCS
# function sdocs()
# {
#     if [ $# -gt 0 ] ; then
# 	cd ~/docs
#         find .  -name "*.txt" | xargs grep -n --color -i "$@"
# 	cd -
#     fi
# }
#
# # LOOK THROUGH ALL .DAT FILES FOR A CASE-INSENSITIVE REGEX
# function sdat()
# {
#     if [ $# -gt 0 ] ; then
# 	#grep -ni --color "$@" *.dat
#         find .  -name "*.dat" | xargs grep -n --color -i "$@"
#     fi
# }
#
# # LOOK THROUGH ALL .DAT FILES FOR A CASE-SENSITIVE REGEX
# function Sdat()
# {
#     if [ $# -gt 0 ] ; then
# 	#grep -n --color "$@" *.dat
#         find . -name "*.dat" | xargs grep -n --color "$@"
#     fi
# }
#
# # LOOK THROUGH LOG FILES
# function sapp()
# {
#     if [ $# -gt 0 ] ; then
# 	grep -ln --color "$@" *app_log
#     fi
# }
#
# # INC, ROLL PACKAGES TO DEV
# # to do: add bot, do in separate window
# alias rod='roll_out_dev'
# function roll_out_dev()
# {
#     a=$PWD
#     cd ~/dev/build
#
#     for p in "$@";
#     do
# 	inc_version $p
# 	roll_out $p DEV
#     done
#
#     cd $a
#
#     unset a
# }
#
# # INC, ROLL PACKAGES TO TEST
# alias rot='roll_out_test'
# function roll_out_test()
# {
#     a=$PWD
#     cd ~/dev/build
#
#     for p in "$@";
#     do
# 	inc_version $p
# 	roll_out $p TEST
#     done
#
#     cd $a
# }
#
# # ROLL PACKAGES TO DEV WITH MY TAG
# alias rodme='roll_out_dev_me'
# function roll_out_dev_me()
# {
#     a=$PWD
#     cd ~/dev/build
#
#     if [ "${1}" == "-n" ]; then
# 	NO_STRIP="--no-strip"
# 	DIR="${2}"
#     else
# 	DIR="${1}"
#     fi
#
#     inc_version $DIR
#     roll_out $DIR -t amanda $NO_STRIP
#
#     ### Option for handling multiple packages:
#     # for p in "$@";
#     # do
#     # 	inc_version $p
#     # 	roll_out $p DEV -t amanda
#     # done
#
#     cd $a
#
#     unset a NO_STRIP DIR
# }
#
# # ROLL PACKAGES TO TEST WITH MY TAG
# alias rotme='roll_out_test_me'
# function roll_out_test_me()
# {
#     a=$PWD
#     cd ~/dev/build
#
#
#     for p in "$@";
#     do
# 	inc_version $p
# 	roll_out $p TEST -t amanda
#     done
#
#     cd $a
#     unset a
# }
#
# # SYNC CONFIG FILES WITH //DEV-LNX
# function sync_config()
# {
#     DST_BASE="//dev-lnx/home/ryman.amanda/"
#     DST_DIR="config"
#     FILES=".aliases .bash_profile .bashrc bin .emacs .emacs.d .funcs .profile .xemacs"
#
#     a=$PWD
#     cd ${DST_BASE}
#     if [ ! -e ${DST_DIR} ]; then
#         echo "making ${DST_DIR}"
#         mkdir ${DST_DIR}
#     else
#         echo "already have ${DST_DIR}"
#     fi
#
#     DST_PATH=${DST_BASE}${DST_DIR}"/"
#
#     echo "using ${DST_PATH}"
#
#     cd ~/config
#
#     for FILE in $FILES
#     do
#         echo "syncing file $FILE"
#         if [ -d $FILE ]; then
#             cp -r $FILE $DST_PATH
#         elif [ -f $FILE ]; then
#             cp $FILE $DST_PATH
#         fi
#     done
#
#     cd ${a}
#     unset a FILE FILES DST_BASE DST_DIR DST_PATH
# }
#
# # CHECK FOR MY LOCKS
# function slocks()
# {
#     rlocks -r -u -f
#     #rlocks -r | grep "ryman.amanda"
# }
#
# # CHECK FOR NEW FILES THAT AREN'T CHECKED IN
# function snew()
# {
#     #    find . -user ryman.amanda -name '*.dat' -or -name '*.cpp' -or -name '*.h' -or -name '*.pls' | xargs ls -la --color=auto
#     find . -perm /u+w -name '*.dat' -or -name '*.cpp' -or -name '*.h' | xargs ls -la --color=auto
# }
#
# # INC A PACKAGE (not super useful)
# function inc()
# {
#     a=$PWD
#     cd ~/dev/build
#     inc_version $1
#     cd $a
#     unset a
# }
