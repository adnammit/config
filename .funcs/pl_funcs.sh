
#=========================================
# FUN WITH FUNCTIONS
#
# These functions are aliased here rather
#  than in the .aliases dir
#=========================================

if [ "${WORK_ENV}" ] ; then

    function mnt()
    {
        local POS_STR

        if [[ $1 ]] ; then
            X=$1
        fi
        if [[ $2 ]] ; then
            Y=$2
        fi
        if [[ $X && $Y ]] ; then
            POS_STR="-p $X,$Y"
        fi

        mintty -i /Cygwin-Terminal.ico $POS_STR - &
    }

    function ssh_devlnx()
    {
        local X=0
        local Y=0

        if [ $1 ] ; then
            X=$1
        fi
        if [ $2 ] ; then
            Y=$2
        fi

        mintty -p $X,$Y -t dev-lnx -e /bin/bash -c 'read -pusername\($USERNAME\):\  SSHUSER; export DISPLAY=:$((UID%10000)).0; exec /usr/bin/ssh -XY ${SSHUSER:-$USERNAME}@dev-lnx.portland.perflogic.com' -hold &
    }

    alias oa='open_atoms'
    function open_atoms()
    {
        local a=$PWD

        if [[ $1 == "-n" || $1 == "--notes" ]] ; then
            local NOTES_ONLY=1
        elif [[ $1 == "-d" || $1 == "--dev" ]] ; then
            local DEV_ONLY=1
        fi

        if [ ! $DEV_ONLY ] ; then
            cd ~
            atom ./config ./.atom ./docs/notes
        fi

        if [ ! $NOTES_ONLY ] ; then
            cd /c/UserData/ryman.amanda
            atom ./dev
        fi

        cd $a
    }

    function hello()
    {
        local COL1_X=1913
        local COL2_X=2870
        local ROW1_Y=0
        local ROW2_Y=540

        if [[ $1 == "-s" || $1 == "--skip-update" ]] ; then
            local SKIP_UPDATE=1
        fi

        # Open our helper local window right below the first one:
        mnt $COL1_X $ROW2_Y

        # Open a couple of dev-lnx windows in the right column:
        ssh_devlnx $COL2_X $ROW1_Y
        ssh_devlnx $COL2_X $ROW2_Y

        # sync_config

        open_atoms

        if [[ -z $SKIP_UPDATE ]] ; then
            update_dev
            local SUCCESS=$?
            if [[ $SUCCESS == 1 ]] ; then
                show_me_a_kitty
            else
                echo ">> FAIL"
            fi
        else
            echo ">> update skipped"
        fi
    }

    # #### HELPER FUNC FOR UPDATE FUNCS
    # #### roll_changed_pkgs --porcelain returns one of the following:
    # # * `Error: <error>` on errors with exit 1 status
    # # * `none`: if no packages are to be rolled
    # # * a list of packages readable by build/roll_out
    # function parse_result()
    # {
    #     local SUCCESS=0
    #     local RESULT="$@"
    #     local RESULT_STR=""
    #
    #     for RES in $RESULT
    #     do
    #         if [[ $RES =~ [^\#*] ]] ; then
    #             RESULT_STR=$RESULT_STR$RES" "
    #         else
    #             break
    #         fi
    #     done
    #
    #     echo ">> $RESULT_STR"
    #
    #     local TMP=$(echo $RESULT | head -n1 | sed -e 's/ *\([a-zA-Z]*\).*/\1/')
    #
    #     if [[ $TMP == "Error" ]] ; then
    #         echo "Unsuccessful update ಠ╭╮ಠ"
    #     elif [[ $TMP == "none" ]] ; then
    #         SUCCESS=1
    #         echo "Nothing to roll out ¯\_(ツ)_/¯"
    #     else
    #         SUCCESS=1
    #         echo ">> Successful update! ~(˘▾˘~)"
    #     fi
    #
    #     return $SUCCESS
    # }


    # # UPDATE MASTER, CURRENT FEATURE BRANCH AND ROLL ALL RELEVANT PACKAGES
    # # tried splitting this out into a separate script but rebase is broken again
    # function update_pl()
    # {
    #     echo ">> UPDATING DEV"
    #     cd ~/dev/
    #
    #     local TRUNK=master
    #     local BRANCH=$(git rev-parse --abbrev-ref HEAD)
    #     local BRANCH_DIRTY=$(git status --porcelain)
    #     local OLD_HASH
    #     local MSUCCESS=0
    #     local BSUCCESS=0
    #
    #     if [[ $BRANCH_DIRTY ]] ; then
    #         echo ">> $BRANCH is dirty ಠ_ಠ"
    #         echo ">> Stash or commit before pulling."
    #     else
    #         if [ $BRANCH == $TRUNK ] ; then
    #             OLD_HASH=$(git rev-parse $TRUNK)
    #             git pull
    #             echo ">> Rolling changes to master since $OLD_HASH"
    #
    #             parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
    #             MSUCCESS=$?
    #             BSUCCESS=1
    #         else
    #             git co $TRUNK
    #
    #             local TRUNK_DIRTY=$(git status --porcelain)
    #
    #             if [[ $TRUNK_DIRTY ]] ; then
    #                 echo ">> $TRUNK is dirty ಠ_ಠ"
    #                 echo ">> Stash or commit before pulling."
    #             else
    #                 OLD_HASH=$(git rev-parse $TRUNK)
    #                 git pull # appears to always return '0'
    #                 echo ">> Rolling changes to master since $OLD_HASH"
    #                 parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
    #                 MSUCCESS=$?
    #                 # MSUCCESS=$? # returns 0 if nothing was updated. what if there's an error?
    #                 # echo ">> git pull result after pulling master is $MSUCCESS"
    #
    #                 # if [[ $MSUCCESS != 0 ]] ; then
    #                 #     echo ">> Rolling changes to master since $OLD_HASH"
    #                 #     parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
    #                 #     MSUCCESS=$?
    #                 # else
    #                 #     echo ">> Skipping roll_changed_pkgs -- nothing to update"
    #                 #     MSUCCESS=1
    #                 # fi
    #
    #                 # if update of master fails, do not update branch
    #                 if [[ $MSUCCESS == 1 ]] ; then
    #                     git co ${BRANCH}
    #                     OLD_HASH=$(git merge-base $BRANCH $TRUNK)
    #                     # echo ">> 5x sleeping (∪｡∪)｡｡｡zzz"
    #                     # sleep 5
    #                     git rebase master
    #                     # BSUCCESS=$? # returns 0 if nothing was updated. what if there's an error?
    #                     # echo ">> git pull result after pulling $BRANCH is $BSUCCESS"
    #                     echo ">> Rolling changes to $BRANCH since $OLD_HASH"
    #                     parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
    #                     BSUCCESS=$?
    #
    #                     # if [[ $BSUCCESS != 0 ]] ; then
    #                     #     echo ">> Rolling changes to $BRANCH since $OLD_HASH"
    #                     #     parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
    #                     #     BSUCCESS=$?
    #                     # else
    #                     #     echo ">> Skipping roll_changed_pkgs -- nothing to update"
    #                     #     BSUCCESS=1
    #                     # fi
    #                 fi
    #             fi
    #         fi
    #     fi
    #     cd -
    #
    #     echo "Branch Success: $BSUCCESS and Master Success: $MSUCCESS"
    #
    #     if [[ $BSUCCESS == 1 && $MSUCCESS == 1 ]] ; then
    #         return 1
    #     else
    #         return 0
    #     fi
    # }


    # # Invoke while on a feature branch to rebase in changes from master and roll associated packages
    # function update_branch()
    # {
    #     local TRUNK=master
    #     local BRANCH=$(git rev-parse --abbrev-ref HEAD)
    #     local GIT_ROOT=$(git rev-parse --show-toplevel)
    #     local DIVERGE_REV=$(git merge-base $BRANCH $TRUNK)
    #     local TREE_DIRTY=$(git status --porcelain)
    #     local SUCCESS=0
    #
    #     if [[ $TREE_DIRTY ]]; then
    #         echo ">> $BRANCH is dirty ಠ_ಠ"
    #         echo ">> Stash or commit before pulling."
    #     else
    #         git rebase $TRUNK
    #         echo ">> Rolling changes since $DIVERGE_REV"
    #         parse_result $(roll_changed_pkgs --porcelain --revs $DIVERGE_REV HEAD)
    #         SUCCESS=$?
    #     fi
    #
    #     return $SUCCESS
    # }


    function reset_branch()
    {
        local OLD_HASH=$(git rev-parse HEAD)
        local GIT_ROOT=$(git rev-parse --show-toplevel)

        git reset --hard master
        local NEW_HASH=$(git rev-parse HEAD)
        echo ">>> Rolling out all changes between $OLD_HASH and $NEW_HASH"
        $GIT_ROOT/build/roll_changed_pkgs --revs $OLD_HASH HEAD
    }

    # # SYNC CONFIG FILES WITH //DEV-LNX
    # function sync_config()
    # {
    #     local DST_BASE="//dev-lnx/home/ryman.amanda/"
    #     local DST_DIR="config"
    #     local FILES=".aliases .bash_profile .bashrc bin .funcs .profile"
    #     # local FILES=".aliases .bash_profile .bashrc bin .emacs .emacs.d .funcs .profile .xemacs"
    #
    #     local a=$PWD
    #     cd $DST_BASE
    #     if [ ! -e $DST_DIR ]; then
    #         mkdir $DST_DIR
    #     fi
    #
    #     local DST_PATH=$DST_BASE$DST_DIR"/"
    #
    #     echo ">>> copying config files to $DST_PATH"
    #
    #     cd ~/config
    #
    #     for FILE in $FILES
    #     do
    #         echo "syncing file $FILE"
    #         if [[ -d $FILE ]] ; then
    #             cp -r $FILE $DST_PATH
    #         elif [[ -f $FILE ]] ; then
    #             cp $FILE $DST_PATH
    #         fi
    #     done
    #
    #     cd $a
    # }

    # LOOK THROUGH TXT FILES IN DOCS
    function sdocs()
    {
        if [ $# -gt 0 ] ; then
    	cd ~/docs
            stxt $@
    	cd -
        fi
    }

    # LOOK THROUGH ALL .DAT FILES FOR A CASE-INSENSITIVE REGEX
    function sdat()
    {
        if [ $# -gt 0 ] ; then
    	#grep -ni --color "$@" *.dat
            find .  -name "*.dat" | xargs grep -n --color -i "$@"
        fi
    }

    # LOOK THROUGH ALL .DAT FILES FOR A CASE-SENSITIVE REGEX
    function Sdat()
    {
        if [ $# -gt 0 ] ; then
    	#grep -n --color "$@" *.dat
            find . -name "*.dat" | xargs grep -n --color "$@"
        fi
    }

    # LOOK THROUGH LOG FILES
    function sapp()
    {
        if [ $# -gt 0 ] ; then
        	grep -ln --color "$@" *app_log
        fi
    }

    function diff_dirs
    {
        local DIR_ONE=${1}
        local DIR_TWO=${2}
        local FILENAME

        # TO DO: slice off / from dir names

        if [[ $DIR_TWO ]] ; then
            echo "Diffing $DIR_ONE with $DIR_TWO"

            for FILE in ${DIR_ONE}/* ; do
                FILENAME=$(basename ${FILE})
                echo "diff -Bw ${FILE} ${DIR_TWO}/${FILENAME}"
                diff -Bw ${FILE} ${DIR_TWO}/${FILENAME}
                read -n 1 -s
            done
        else
            echo "enter two args for the directories you want to compare the contents of"
        fi
    }

    # Find all process_flow clients
    function find_pf_clients
    {
        local a=$PWD
        cd ~/dev/

        local CLIENTS=
        local FILE_NAME=process_flow_request.pls
        local GIT_ROOT=$(git rev-parse --show-toplevel)
        local FILES=$(find $GIT_ROOT -name $FILE_NAME)
        local PATH_STR=

        for FILE in $FILES
        do
            PATH_STR=$(dirname $FILE)
            PATH_STR=$(echo ${PATH_STR##*/})
            CLIENTS=$CLIENTS" "$PATH_STR
        done

        CLIENTS=$(echo $CLIENTS | sort | uniq)

        for CLIENT in $CLIENTS
        do
            echo $CLIENT
        done

        cd $a
    }


    function sync_pf_clients
    {
        local CLIENTS=$(find_pf_clients)
        local OPTS_STR
        local HELP_FLAG

        function display_help
        {
            echo "Call to sync client data for all process_flow clients."
            echo "Cues off of a search for the process_flow_request.pls script for generating process flows."
            echo "Options include '--link <repo>' and '--dry-run'."
            echo "Sync client data for all process_flow clients by linking to master repo site:"
            echo "  $ sync_pf_clients --link alr "
        }

        while [ "${#}" != 0 ] ; do
            case "${1}" in
                  -l | --link)
                      OPTS_STR=${OPTS_STR}" --link "${2}
                      shift 2
                      ;;
                  -h | --help)
                      HELP_FLAG=1
                      break
                      ;;
                  -n|--dry-run)
                      OPTS_STR=${OPTS_STR}" -n"
                      shift
                      ;;
                  -*)
                      echo "Error: Unknown option: $1"
                      display_help
                      break
                      ;;
                  *)
                      break
                      ;;
            esac
        done

        if [[ $HELP_FLAG ]] ; then
            display_help
        else
            sync_client_data ${OPTS_STR} ${CLIENTS}
        fi
    }

    # handle multiple clients w/ --link arg and dry run options
    alias scd='sync_client_data'
    function sync_client_data
    {
        local ORGS
        local LINK_STR=
        local SITE_STR=
        local DRY_RUN=
        local HELP_FLAG=

        function display_help
        {
            echo "Sync data for multiple clients using copy_org."
            echo "All the usual copy_org options apply."
            echo "Link data in f3 to master when in a different repo:"
            echo "   $ sync_client_data --link alr --site alr-f3 jhs uhs epsg"
        }

        if [ "${#}" == 0 ] ; then
            HELP_FLAG=1
        else
            while  [ "${#}" != 0 ] ; do
                case "${1}" in
                    -l | --link)
                        # LINK_REPO="${2}"
                        LINK_STR="--link ${2}"
                        shift 2
                        ;;
                    -s | --site)
                        SITE_STR="--site ${2}"
                        shift 2
                        ;;
                    -h | --help)
                        HELP_FLAG=1
                        break
                        ;;
                    -n | --dry-run)
                        DRY_RUN=1
                        shift
                        ;;
                    -*)
                        echo "Error: Unknown option: $1"
                        echo ""
                        HELP_FLAG=1
                        break
                        ;;
                    *)
                        ORGS+=(${1})
                        shift
                        ;;
                esac
            done
        fi

        if [[ ${#ORGS[@]} -gt 0 && ! $HELP_FLAG ]] ; then
            for ORG in ${ORGS[@]}
            do
                if [ ${DRY_RUN} ] ; then
                    echo "DRY RUN: copy_org ${ORG} ${LINK_STR} ${SITE_STR}"
                else
                    copy_org ${ORG} ${LINK_STR} ${SITE_STR}
                fi
            done
        else
            display_help
        fi
    }

    # Would love to have this as a script but it relies on sync_client_data which needs to be made stand-alone first
    function setup_clients()
    {
        local a=$PWD
        local ORGS=
        local LINK_STR=
        local SITE_STR=
        local DRY_RUN=
        local HELP_FLAG=
        local DO_COMMON=
        local SKIP_DATA=
        local CLIENT_PKGS="abington advocate advocate_demo ashland barrett bayhealth bbtrails bswqa cadence cfhp cmc contracosta covenanthealth demo demo2 fintrack forrestgeneral grmc healthquest hendry htpn jhs leadership lifebridge mercy mhs northvalley northwell nshs om om-qvp oumc oums parkland perflogic rcrmc riverside rounding sanantonio scvmc sfgh sg sharp sickkids skf ski ski2 sni solutions supplychain teletracking texas texasrhp14 texasrhp15 texasrhp3 texasrhp6 texasrhp7 tha thr tjuh tpc tracer transformation uhs umhs va-eoc vaco vcu visn10 visn22 visn4 visn9 wellmont wellspan"

        function display_help
        {
            echo "SETUP_CLIENTS:"
            echo ""
            echo "Sync data and roll out any packages listed in Additional Modules and"
            echo "Search Modules."
            echo ""
            echo "------------------------------------------------------------------------"
            echo "OPTIONS:"
            echo "Link synced data to another repo using '--link'. This will pull data to"
            echo "the repo being linked to. This might be broken when trying to link to"
            echo "non-master repos (if you have a branch repo linked to another branch repo)."
            echo ""
            echo "    $ setup_client jhs uhs epsg --link alr"
            echo ""
            echo "If you think your data is reasonably up to date, use '--skip' to just "
            echo "roll packages and skip pulling down data."
            echo ""
            echo "Take note that extracting client packages with the flag '--dry-run' "
            echo "won't work unless there is some client data already pulled down. ¯\_(ツ)_/¯"
            echo ""
            echo "Use '--common' to include common in the packages being rolled out."
            echo ""
            echo "------------------------------------------------------------------------"
            echo "NOTE:"
            echo "This script creates a ~/temp/ directory in which to store the client"
            echo "data for parsing. If you don't like it, change it."
            echo ""
            echo "The list of CLIENT_PKGS will need to be manually updated when new "
            echo "clients are added, so that's annoying."
            # echo "Use the '--all' flag to run setup for all clients."
            echo "Current list of client packages is: "
            echo ""
            echo $@
        }

        if [ "${#}" == 0 ] ; then
            HELP_FLAG=1
        else
            while  [ "${#}" != 0 ] ; do
                case "${1}" in
                    -k | --skip)
                        SKIP_DATA=1
                        shift
                        ;;
                    -l | --link)
                        LINK_STR="--link $2"
                        SITE_STR="--site $2"
                        shift 2
                        ;;
                    # -a | --all
                    #     ORGS=$CLIENT_PKGS
                    #     shift
                    #     ;;
                    -c | --common)
                        DO_COMMON=1
                        break
                        ;;
                    -h | --help)
                        HELP_FLAG=1
                        break
                        ;;
                    -n | --dry-run)
                        DRY_RUN="-n"
                        shift
                        ;;
                    -*)
                        echo "Error: Unknown option: $1"
                        display_help
                        break
                        ;;
                    *)
                        ORGS=$ORGS$1" "
                        shift
                        ;;
                esac
            done
        fi

        if [[ $HELP_FLAG || ! $ORGS ]] ; then
            display_help $CLIENT_PKGS
        elif [[ $ORGS ]] ; then

            cd ~/dev/

            local BRANCH=$(git rev-parse --abbrev-ref HEAD)
            local TMP_DIR="temp"
            local PKGS=
            local FILENAME=
            local VERSION=
            local MAX=
            local MAXFILE=
            local BZFILE=
            local LINEARR=
            local LINE=

            if [[ $BRANCH == "master" ]] ; then
                local CLIENT_DIR="//dev-lnx/repo_sites/alr/__client__/"
            else
                local CLIENT_DIR="//dev-lnx/repo_sites/alr-$BRANCH/__client__/"
            fi

            cd ~

            if [[ ! -d $TMP_DIR ]] ; then
                mkdir $TMP_DIR
            fi

            if [[ ! $SKIP_DATA ]] ; then
                # If we're linking to another site, make sure that site's data is up to date first
                if [[ $LINK_STR ]] ; then
                    sync_client_data $SITE_STR $DRY_RUN $ORGS
                fi
                sync_client_data $LINK_STR $DRY_RUN $ORGS
            else
                echo "Skipping data"
            fi



            # # If we're linking to another site, make sure that site's data is up to date first
            # if [[ ! $SKIP_DATA || $LINK_STR ]] ; then
            #
            #     sync_client_data $SITE_STR $DRY_RUN $ORGS
            # fi
            #
            # if [[ $LINK_STR ]] ; then
            #     echo "Skipping data, but make sure all dirs are linked:"
            #     sync_client_data $LINK_STR $DRY_RUN $ORGS
            # else
            #     echo "Skipping data"
            # fi

            for ORG in ${ORGS}
            do
                MAX=0
                MAXFILE=

                # If the client has its own package, add it to the roll list
                if [[ $CLIENT_PKGS =~ "$ORG" ]] ; then
                    PKGS=$PKGS$ORG" "
                else
                    echo "WARN: $ORG was not added to package list"
                fi

                # Copy all the org.dat* files to temp/ and then look for the most recent one
                rsync -ta --delete-excluded --exclude='*.lock' --include='org.dat*' --exclude='*' $CLIENT_DIR$ORG/ $TMP_DIR/

                for FILE in ${TMP_DIR}/* ; do
                    FILENAME=$(basename ${FILE})
                    VERSION="${FILENAME: -2}"

                    # Check for annoying files ending in org.dat.2 instead of org.dat.02
                    if [[ $VERSION =~ "." ]] ; then
                        VERSION="${VERSION: -1}"
                    fi

                    if [ $VERSION -gt $MAX ] ; then
                        MAX=$VERSION
                        MAXFILE=$FILENAME
                    fi
                done

                # Unzip the file if needed
                if [[ "$MAXFILE" =~ "bz2" ]] ; then
                    BZFILE=$MAXFILE".out"
                    # echo "Pulling $ORG data from bz file $MAXFILE, decompressing to $BZFILE"
                    bzip2 -dfq $TMP_DIR/$MAXFILE > $TMP_DIR/$BZFILE
                    MAXFILE=$BZFILE
                # else
                    # echo "Pulling $ORG org data from $MAXFILE"
                fi

                # Store the file lines in an array so we can iterate through them in a weird-ass way:
                mapfile -t LINEARR < $TMP_DIR/$MAXFILE

                for ((i=0; i<${#LINEARR[*]}; i++)) ; do
                    LINE=${LINEARR[i]}

                    # If we find Additional or Search Modules, walk through the subsequent lines
                    #   until we come to the closing Val_list tag looking for anything that doesn't
                    #   start with a tag opener '<' and isn't fake package 'it_pmo'
                    if [[ $LINE =~ "additional_modules" || $LINE =~ "search_modules" ]] ; then
                        while [[ $LINE ]]; do
                            LINE=${LINEARR[i]}
                            if [[ $LINE =~ "</Val_list>" ]] ; then
                                LINE=
                            else
                                if [[ ${LINE:0:1} != "<" && $LINE != "it_pmo" ]] ; then
                                    PKGS=$PKGS$LINE" "
                                fi
                            fi
                            ((i++))
                        done
                    fi
                done
            done

            # Create a unique list of packages to roll:
            if [[ $DO_COMMON ]] ; then
                PKGS=$PKGS"common"
            fi
            PKGS=$(echo "$PKGS" | tr ' ' '\n' | sort -u | tr '\n' ' ')
            # PKGS=$(echo "$PKGS" | sort | uniq) # y u no work??

            echo "ROLLING: $PKGS"

            if [[ ! $DRY_RUN ]] ; then
                roll_out $PKGS
            fi

            echo "ROLLED: $PKGS"

        fi

        cd $a
    }

    function generate_dev_links
    {
        local ORGS="abington ahi advocate ashland bhset bayhealth baybluffs bswqa cfhp cmc cnycc contracosta covenanthealth epsg flpps grmc harriscenter healthquest hendry jhs jps lchp medproject missouri mhs nci northwell nqp nypq om om-qvp rideout riverside sanantonio sbhny scvhhs scvmc sg sharp sickkids skf ski2 sipps scc texasrhp6 uhs va-eoc vcu visn9 wcmc wellmont wellspan"
        # local ORGS="abington ahi advocate jhs"

        for ORG in ${ORGS}
        do
            if [[ -e $ORG && ! -L $ORG ]] ; then
                echo "$ORG exists and is not a symlink, cannot overwrite"
            else
                if [ -L $ORG ] ; then
                    unlink $ORG
                fi
                echo $ORG
                ln -s /var/www/sites/dev.perflogic.com/__client__/$ORG/
            fi
        done
    }

    alias grlf='grep_launch_files'
    function grep_launch_files()
    {
        local a=$PWD
        local OBSOLETE="
        client/skf
        client/fintrack
        "
        local FILES="
        *_actions
        *_customize_launch
        Add_project_team_member
        Audit_rollup_page_spec
        Classify_project_step
        Complete_new_project
        Complete_project_func
        Complete_request_launch
        Customize_project_launch_specs
        Customize_request_project
        Customize_request_project_step
        Customize_template
        Customize_template_step
        Do_complete_new_project
        Generate_project_steps
        Init_repository
        Launch_*_request
        Legacy_request_proj_launch
        Merge_repositories
        Name_project
        Name_project_step
        New_proj_steps
        New_proj_script
        New_proj_wizard
        New_project_launch_func
        New_project_step
        On_proj_launch_func
        Open_project
        Populate_new_project_roster
        Proj_launch_team_member_func
        Project_list_buttons
        Project_report
        Quick_setup
        Quick_setup_step
        Request_customize_setup_steps
        Request_launch_script
        Request_launch_specs
        Request_types
        Roster_selection_table
        Select_audit_step
        Select_audit
        Select_content_support_step
        Select_schedule
        Select_schedule_step
        Select_template
        Select_template_step
        Setup_roster_buttons
        Setup_step_dialog
        Setup_view
        Start_up_template
        Step_2
        Step_3
        "

        cd ~/dev/dat/
        for FILE in ${FILES} ; do
            find . -name $FILE.dat* | xargs grep "${@}" --color
            # find . -name $FILE.dat* | xargs head -1 #look for stupid stuff on the first line


            # find . \( -path dir1 -o -path dir2 -o -path dir3 \) -name $FILE.dat* | xargs grep "${@}" --color
            # find . \( -path client/fintrack -o -path client/skf \) -prune -o -name $FILE.dat*
            # find . -type d \( -path "client/fintrack" -o -path "client/skf" \) -prune -o -name $FILE.dat*
        done
        cd $a
    }


    function clean_underscore_files()
    {
        a=$PWD
        cd ~/dev/dat/
        find . -type f -name '*_' -exec rm -vf {} +
        cd $a
    }


    function sync_site_to_dev()
    {
        local HELP_FLAG=
        local DRY_RUN=
        local SERVER=
        local REPO=
        local ORG=
        local BR_BASE="alr"

        function display_help
        {
            echo ""
            echo "SYNC_SITE_TO_DEV"
            echo "------------------------------------------------------------------------"
            echo ""
            echo "sync_site_to_dev is a wrapper for rsyncing client data to a repo site,"
            echo "handy for demo and demo2 and other orgs that copy_org fails on."
            echo "Requires a server and org at minimum. Optionally specify a repo site."
            echo "Default is to rsync data to the current repo."
            echo ""
            echo "     $ sync_site_to_dev --server 13 --repo f1 demo"
            echo ""
        }

        if [ "${#}" == 0 ] ; then
            HELP_FLAG=1
        else
            while  [ "${#}" != 0 ] ; do
                case "${1}" in
                    -s | --server)
                        SERVER=$2
                        shift 2
                        ;;
                    -r | --repo)
                        REPO=$2
                        shift 2
                        ;;
                    -h | --help)
                        HELP_FLAG=1
                        break
                        ;;
                    -n | --dry-run)
                        DRY_RUN=1
                        shift
                        ;;
                    -*)
                        echo "Error: Unknown option: $1"
                        display_help
                        break
                        ;;
                    *)
                        ORG=$1
                        shift
                        ;;
                esac
            done
        fi

        if [[ ! $HELP_FLAG ]] ; then
            if [[ ! $ORG || ! $SERVER ]] ; then
                echo ""
                echo "*** Missing org or server ***"
                HELP_FLAG=1
            fi
        fi

        if [[ $HELP_FLAG ]] ; then
            display_help
        else
            local RARGS="-e ssh --delete -vltr"

            if [[ $DRY_RUN ]] ; then
                RARGS=$RARGS"n"
            fi

            if [[ ! $REPO ]] ; then
                REPO=$(git rev-parse --abbrev-ref HEAD)
            fi

            if [[ $REPO != $BR_BASE && $REPO != "master" ]] ; then
                BR_BASE=$BR_BASE"-"$REPO
            fi

            rsync $RARGS pl_prod@www$SERVER.perflogic.com:/var/www/sites/www.perflogic.com/__client__/$ORG/ /var/www/repo_sites/$BR_BASE/__client__/$ORG/
            # rsync $RARGS pl_prod@www$SERVER.perflogic.com:/var/www/sites/www.perflogic.com/__client__/$ORG/ pl_bld@dev-lnx.portland.perflogic.com:/var/www/repo_sites/$BR_BASE/__client__/$ORG/

            echo "$RARGS"
        fi

    }

fi
