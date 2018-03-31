
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

        if [ ${1} ] ; then
            X=${1}
        fi
        if [ ${2} ] ; then
            Y=${2}
        fi

        if [ ${X} ] && [ ${Y} ] ; then
            POS_STR="-p ${X},${Y}"
        fi
        # TO DO:
        # put X and Y in a str: "-p ${X},${Y}"

        #mintty -t hello -e /bin/bash - &
        mintty -i /Cygwin-Terminal.ico ${POS_STR} - &
    }

    function ssh_devlnx()
    {
        local X=0
        local Y=0

        if [ ${1} ] ; then
            X=${1}
        fi
        if [ ${2} ] ; then
            Y=${2}
        fi

        mintty -p ${X},${Y} -t dev-lnx -e /bin/bash -c 'read -pusername\($USERNAME\):\  SSHUSER; export DISPLAY=:$((UID%10000)).0; exec /usr/bin/ssh -XY ${SSHUSER:-$USERNAME}@dev-lnx.portland.perflogic.com' -hold &
    }

    function hello()
    {
        local COL1_X=1913
        local COL2_X=2870
        local ROW1_Y=0
        local ROW2_Y=540
        local a=$PWD

        if [[ "${1}" == "-s" || "${1}" == "--skip-update" ]] ; then
            local SKIP_UPDATE=1
        fi

        # Open our helper local window right below the first one:
        mnt ${COL1_X} ${ROW2_Y}
        # mintty -i /Cygwin-Terminal.ico -p ${COL1_X},${ROW2_Y} - &

        # Open a couple of dev-lnx windows in the right column:
        ssh_devlnx ${COL2_X} ${ROW1_Y}
        ssh_devlnx ${COL2_X} ${ROW2_Y}

        sync_config

        cd ~
        atom ./config ./.atom ./docs/notes

        cd /c/UserData/ryman.amanda
        atom ./dev

        cd ${a}

        if [ -z "${SKIP_UPDATE}" ] ; then
            update_pl
            local SUCCESS=$?
            if [ "${SUCCESS}" == 1 ] ; then
                show_me_a_kitty
            else
                echo "FAIL"
            fi
        else
            echo "update skipped"
        fi
    }

    # UPDATE MASTER, CURRENT FEATURE BRANCH AND ROLL ALL RELEVANT PACKAGES
    # tried splitting this out into a separate script but rebase is broken again
    # TO DO:
    # - check rebase etc more rigorously for failure and return
    function update_pl
    {
        echo ">> UPDATING DEV"
        cd ~/dev/

        local TRUNK=master
        local BRANCH=$(git rev-parse --abbrev-ref HEAD)
        local BRANCH_DIRTY=$(git status --porcelain)
        local OLD_HASH
        local SUCCESS=0

        if [ "${BRANCH_DIRTY}" ] ; then
            echo ">> ${BRANCH} is dirty ಠ_ಠ"
            echo ">> Stash or commit before pulling."
        else
            if [ ${BRANCH} == ${TRUNK} ] ; then
                OLD_HASH=$(git rev-parse ${TRUNK})
                git pull
                echo ">> Rolling changes to master since ${OLD_HASH}"
                roll_changed_pkgs --revs $OLD_HASH HEAD
                SUCCESS=1
            else
                git co ${TRUNK}

                local TRUNK_DIRTY=$(git status --porcelain)

                if [ "${TRUNK_DIRTY}" ]; then
                    echo ">> ${TRUNK} is dirty ಠ_ಠ"
                    echo ">> Stash or commit before pulling."
                else
                    OLD_HASH=$(git rev-parse ${TRUNK})
                    git pull
                    echo ">> Rolling changes to master since ${OLD_HASH}"
                    roll_changed_pkgs --revs $OLD_HASH HEAD

                    git co ${BRANCH}
                    OLD_HASH=$(git merge-base $BRANCH $TRUNK)
                    echo ">> 5x sleeping (∪｡∪)｡｡｡zzz"
                    sleep 5
                    git rebase master
                    echo ">> Rolling changes to ${BRANCH} since ${OLD_HASH}"
                    roll_changed_pkgs --revs $OLD_HASH HEAD
                    SUCCESS=1
                fi
            fi
        fi
        cd -
        return ${SUCCESS}
    }

    # Invoke while on a feature branch to rebase in changes from master and roll associated packages
    function update_branch
    {
        local ARG_STR
        if [ "${1}" == "-n" ] ; then
            ARG_STR=${1}
        fi

        local TRUNK=master
        local BRANCH=$(git rev-parse --abbrev-ref HEAD)
        local GIT_ROOT=$(git rev-parse --show-toplevel)
        local DIVERGE_REV=$(git merge-base $BRANCH $TRUNK)
        local TREE_DIRTY=$(git status --porcelain)
        if [ "$TREE_DIRTY" ]; then
            echo ">> ${BRANCH} is dirty ಠ_ಠ"
            echo ">> Stash or commit before pulling."
        else
            if [ "${ARG_STR}" ] ; then
                echo ">> DRY_RUN: not really rebasing"
            else
                git rebase ${TRUNK}
            fi
            echo ">> Rolling changes since ${DIVERGE_REV}"
            $GIT_ROOT/build/roll_changed_pkgs --revs $DIVERGE_REV HEAD ${ARG_STR}
        fi
    }


    # # UPDATE MASTER, CURRENT FEATURE BRANCH AND ROLL ALL RELEVANT PACKAGES
    # function update_dev
    # {
    #     cd ~/dev
    #
    #     local GIT_ROOT=$(git rev-parse --show-toplevel)
    #     local TRUNK=master
    #     # local TRUNK_DIRTY
    #     local BRANCH=$(git rev-parse --abbrev-ref HEAD)
    #     local BRANCH_DIRTY=$(git status --porcelain)
    #     local OLD_HASH
    #     local ARG_STR
    #     local DRY_RUN
    #
    #     # lazy. add more args?
    #     if [ "${1}" == "-n" ] ; then
    #         echo ">> Mode set to DRY_RUN"
    #         DRY_RUN=1;
    #         ARG_STR="-n"
    #     fi
    #
    #
    #     # STASHING FAILS IF MMAP FAILS, WHICH IT DOES ALL THE TIME.
    #     # JUST ABORT IF BRANCH IS DIRTY.
    #     # REINTRODUCE STASHING IF YOU ARE WORKING ON A COMPUTER THAT DOESN'T SUCK.
    #     if [ "$BRANCH_DIRTY" ]; then
    #         echo ">> ${BRANCH} is dirty ಠ_ಠ"
    #         echo ">> Stash or commit before updating master."
    #         # echo ">> Stashing ${BRANCH} before updating master"
    #         # git stash -u
    #     else
    #         echo ">> ${BRANCH} was clean -- now updating master"
    #
    #         git co ${TRUNK}
    #
    #         BRANCH_DIRTY=$(git status --porcelain)
    #
    #         if [ "$BRANCH_DIRTY" ]; then
    #             echo ">> ${TRUNK} is dirty ಠ_ಠ"
    #             echo ">> Stash or commit before pulling."
    #         else
    #             # for master, we just need whatever it's at before we pull
    #             OLD_HASH=$(git rev-parse ${TRUNK})
    #             echo ">> Old ${TRUNK} hash is ${OLD_HASH}"
    #
    #             if [ "${DRY_RUN}" ] ; then
    #                 echo ">> DRY_RUN: not really pulling"
    #             else
    #                 git pull
    #             fi
    #
    #             $GIT_ROOT/build/roll_changed_pkgs --revs $OLD_HASH HEAD ${ARG_STR}
    #
    #             # update the branch you were on:
    #             git co ${BRANCH}
    #
    #             OLD_HASH=$(git merge-base $BRANCH $TRUNK)
    #             echo ">> Rolling out changes on ${BRANCH} since ${OLD_HASH}"
    #
    #             if [ "${DRY_RUN}" ] ; then
    #                 echo ">> DRY_RUN: not really rebasing"
    #             else
    #                 git rebase ${TRUNK}
    #             fi
    #
    #             # if [ -n "$BRANCH_DIRTY" ]; then
    #             #     echo ">> Popping stash for ${BRANCH}"
    #             #     git stash pop
    #             # else
    #             #     echo ">> ${BRANCH} was clean -- no pop"
    #             # fi
    #
    #             $GIT_ROOT/build/roll_changed_pkgs --revs $OLD_HASH HEAD ${ARG_STR}
    #
    #         fi
    #     fi
    #
    #     cd -
    # }

    # SYNC CONFIG FILES WITH //DEV-LNX
    function sync_config()
    {
        local DST_BASE="//dev-lnx/home/ryman.amanda/"
        local DST_DIR="config"
        local FILES=".aliases .bash_profile .bashrc bin .funcs .profile"
        # local FILES=".aliases .bash_profile .bashrc bin .emacs .emacs.d .funcs .profile .xemacs"

        local a=$PWD
        cd ${DST_BASE}
        if [ ! -e ${DST_DIR} ]; then
            mkdir ${DST_DIR}
        fi

        local DST_PATH=${DST_BASE}${DST_DIR}"/"

        echo ">>> copying config files to ${DST_PATH}"

        cd ~/config

        for FILE in $FILES
        do
            echo "syncing file $FILE"
            if [ -d $FILE ]; then
                cp -r $FILE $DST_PATH
            elif [ -f $FILE ]; then
                cp $FILE $DST_PATH
            fi
        done

        cd ${a}
    }

    # LOOK THROUGH TXT FILES IN DOCS
    function sdocs()
    {
        if [ $# -gt 0 ] ; then
    	cd ~/docs
            stxt $@
            #find . -name "*.txt" | xargs grep -n --color -i "$@"
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

        if [ "${DIR_TWO}" ] ; then
            echo "Diffing ${DIR_ONE} with ${DIR_TWO}"

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
        local CLIENTS=
        local FILE_NAME=process_flow_request.pls
        local GIT_ROOT=$(git rev-parse --show-toplevel)
        local FILES=$(find ${GIT_ROOT} -name ${FILE_NAME})
        local PATH_STR=

        for FILE in ${FILES}
        do
            PATH_STR=$(dirname ${FILE})
            PATH_STR=$(echo ${PATH_STR##*/})
            CLIENTS=${CLIENTS}" "${PATH_STR}
        done

        CLIENTS=$(echo "$CLIENTS" | sort | uniq)

        for CLIENT in ${CLIENTS}
        do
            echo ${CLIENT}
        done
    }


    function sync_pf_clients
    {
        local CLIENTS=$(find_pf_clients)
        local OPTS_STR

        function display_help
        {
            echo "HALP!"
        }

        while  [ "${#}" != 0 ]
        do
            case "${1}" in
                  -l | --link)
                      OPTS_STR=${OPTS_STR}" --link "${2}
                      shift 2
                      ;;
                  -h | --help)
                      display_help
                      break
                      ;;
                  -n|--dry-run)
                      OPTS_STR=${OPTS_STR}" -n"
                      #DRY_RUN=1
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
                  # *)
                  #     ORGS+=(${1})
                  #     shift
                  #     ;;
            esac
        done

        #echo OPTSTR IS: ${OPTS_STR}

        sync_client_data ${OPTS_STR} ${CLIENTS}
    }

    # handle multiple clients w/ --link arg and dry run options
    alias scd='sync_client_data'
    function sync_client_data
    {
        local ORGS
        local LINK_REPO
        local LINK_STR=
        local DRY_RUN=

        function display_help
        {
            echo "HALP!"
        }

        if [ "${#}" == 0 ] ; then
            display_help
        else
            while  [ "${#}" != 0 ]
            do
                case "${1}" in
                      -l | --link)
                          LINK_REPO="${2}"
                          shift 2
                          ;;
                      -h | --help)
                          display_help
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
                          ORGS+=(${1})
                          shift
                          ;;
                esac
            done
        fi

        if [ ${LINK_REPO} ] ; then
            LINK_STR="--link ${LINK_REPO}"
            #echo "MAKE LINK STR: "${LINK_STR}" FROM LINK REPO: "${LINK_REPO}
        fi

        if [ ${#ORGS[@]} -gt 0 ] ; then
            for ORG in ${ORGS[@]}
            do
                if [ ${DRY_RUN} ] ; then
                    echo "DRY RUN: copy_org ${ORG} ${LINK_STR}"
                else
                    copy_org ${ORG} ${LINK_STR}
                fi
            done
        else
            display_help
        fi
    }

    # NAH, YOU GOTTA BE PL_BLD. JUST ROLL_OUT
    # function ropf()
    # {
    #     local DST="pl_bld@dev-lnx.portland.perflogic.com:/var/www/repo_sites/alr-opp-req"
    #     local SRC="~/dev/web"
    #     local SBDIR="__maint__/util/process_flow/"
    #     local EXCLUDE_FLAGS="--exclude w32/ --exclude w32.9/ --exclude w64.9/ --exclude build/DEV/ --exclude build/TEST/ --exclude *.ncb --exclude *.suo --exclude *vcproj*"
    #
    #     echo "rsync -ltvr -e ssh --delete ${SRC}/${SBDIR} ${DST}/${SBDIR} ${EXCLUDE_FLAGS}"
    # }



    ### mmm, not quite. second to last commit is not necess
    # function reset_branch
    # {
    #     local BRANCH=$(git rev-parse --abbrev-ref HEAD)
    #     if [ "${BRANCH}" != "master" ] ; then
    #         local PENULTIMATE_COMMIT=$(git reflog show --pretty='format:%H %gs' | awk '/.* reset: moving to .*/{getline; print $1; exit;}')
    #         echo "penultimate commit ${PENULTIMATE_COMMIT}"
    #         roll_changed_pkgs --revs ${PENULTIMATE_COMMIT} HEAD
    #         # do some kind of clean
    #     else
    #         echo "Don't reset master, fool! ╚(ಠ_ಠ)=┐"
    #     fi
    # }



    # JUST PLAYING AROUND STUFF
    function test_conds
    {
        local FOO
        local BAR=1
        local BAZ=""
        local QUX=0


        echo ""
        echo ">> if [ !null ]"
        if [ ! "${FAKE}" ] ; then
            echo "fake has no value"
        else
            echo "fake has value"
        fi

        echo ""
        echo ">> if [ -z null ]"
        if [ -z "${FAKE}" ] ; then
            echo "string length of fake is zero"
        else
            echo "string length of fake is not zero"
        fi

        echo ""
        echo ">> if [ 1 == 1 ]"
        if [ "${BAR}" == 1 ] ; then
            echo "1 is 1"
        else
            echo "1 is not 1"
        fi



        echo ""
        echo ">> if [ 1 ]"
        if [ ${BAR} ] ; then
            echo "1 is true"
        else
            echo "1 is false"
        fi

        echo ""
        echo ">> if [ !1 ]"
        if [ !${BAR} ] ; then
            echo "!1 is true"
        else
            echo "!1 is false"
        fi

        echo ""
        echo ">> if [ -z 1 ]"
        if [ -z ${BAR} ] ; then
            echo "-z 1 is true"
        else
            echo "-z 1 is false"
        fi

        echo ""
        echo ">> if [ 0 ]"
        if [ ${QUX} ] ; then
            echo "0 is true"
        else
            echo "0 is false"
        fi

        echo ""
        echo ">> if [ foo || bar ]"
        if [[ ${FOO} || ${BAR} ]] ; then
            echo "foo!"
        else
            echo "not foo"
        fi




        echo ""
        echo ">> if [ \$\{foo\} ]"
        if [ ${FOO} ] ; then
            echo "foo!"
        else
            echo "not foo"
        fi

        echo ""
        echo ">> if [ \$foo ]"
        if [ $FOO ] ; then
            echo "foo!"
        else
            echo "not foo"
        fi

        echo ""
        echo ">> if [ \"\$foo\" ]"
        if [ "$FOO" ] ; then
            echo "foo!"
        else
            echo "not foo"
        fi

        echo ""
        echo ">> if [ \"foo\" ]"
        if [ "${FOO}" ] ; then
            echo "foo!"
        else
            echo "not foo"
        fi


        echo ""
        echo ">> bar=0; zero value in a simple 'if' statement is truthy:"
        echo ">> if [ \"bar\" ]"
        if [ "${BAR}" ] ; then
            echo "bar!"
        else
            echo "not bar"
        fi


        echo ""
        echo ">> no quotes, Conditional: == \"\""
        if [ ${FOO} == "" ] ; then
            echo "foo is equal to empty str"
        else
            echo "foo is not equal to empty str"
        fi

        echo ""
        echo ">> using quotes, Conditional: == \"\""
        if [ "${FOO}" == "" ] ; then
            echo "foo is equal to empty str"
        else
            echo "foo is not equal to empty str"
        fi

        echo ""
        echo ">> Conditional: != \"\""
        if [ ${FOO} != "" ] ; then
            echo "foo is not equal to empty str"
        else
            echo "foo is equal to empty str"
        fi

        echo ""
        echo ">> Conditional: -n"
        if [ -n ${FOO} ] ; then
            echo "the length of foo is greater than zero"
        else
            echo "the length of foo is not greater than zero"
        fi

        ###ARGS
        echo ""
        echo ">> Conditional: == \"\""
        if [ "${1}" == "" ] ; then
            echo "ARG1 is equal to empty str"
        else
            echo "ARG1 is not equal to empty str"
        fi

        echo ""
        echo ">> Conditional: -n"
        if [ -n ${1} ] ; then
            echo "the length of ARG1 is greater than zero"
        else
            echo "the length of ARG1 is not greater than zero"
        fi
    }


    function generate_dev_links
    {
        local ORGS="abington ahi advocate ashland bhset bayhealth baybluffs bswqa cfhp cmc cnycc contracosta covenanthealth epsg flpps grmc harriscenter healthquest hendry jhs jps lchp medproject missouri mhs nci northwell nqp nypq om om-qvp rideout riverside sanantonio sbhny scvhhs scvmc sg sharp sickkids skf ski2 sipps scc texasrhp6 uhs va-eoc vcu visn9 wcmc wellmont wellspan"
        # local ORGS="abington ahi advocate jhs"

        for ORG in ${ORGS}
        do
            if [[ -e "${ORG}" && ! -L ${ORG} ]] ; then
                echo "${ORG} exists and is not a symlink, cannot overwrite"
            else
                if [ -L "${ORG}" ] ; then
                    unlink ${ORG}
                fi
                echo ${ORG}
                ln -s /var/www/sites/dev.perflogic.com/__client__/${ORG}/
            fi
        done
    }



fi
