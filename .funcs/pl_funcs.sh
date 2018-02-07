
#=========================================
# FUN WITH FUNCTIONS
#
# These functions are aliased here rather
#  than in the .aliases dir
#=========================================

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

function hello()
{
    local COL1_X=1913
    local COL2_X=2870
    local ROW1_Y=0
    local ROW2_Y=540

    # Open our helper local window right below the first one:
    mnt ${COL1_X} ${ROW2_Y}
    # mintty -i /Cygwin-Terminal.ico -p ${COL1_X},${ROW2_Y} - &

    # Open a couple of dev-lnx windows in the right column:
    ssh_devlnx ${COL2_X} ${ROW1_Y}
    ssh_devlnx ${COL2_X} ${ROW2_Y}

    sync_config
    update_dev
    show_me_a_robot
    echo "HELLO."
}
#
# function goodbye
# {
#     # rsync ~/dev to dev-lnx
#     echo "goodbye"
# }

# JUST PLAYING AROUND STUFF
function test_conds
{
    local FOO
    local BAR=0
    local BAZ=""


    echo ""
    echo ">> if [ foo ]"
    if [ ${FOO} ] ; then
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


# UPDATE MASTER, CURRENT FEATURE BRANCH AND ROLL ALL RELEVANT PACKAGES
function update_dev
{
    cd ~/dev

    local GIT_ROOT=$(git rev-parse --show-toplevel)
    local TRUNK=master
    # local TRUNK_DIRTY
    local BRANCH=$(git rev-parse --abbrev-ref HEAD)
    local BRANCH_DIRTY=$(git status --porcelain)
    local OLD_HASH
    local ARG_STR
    local DRY_RUN

    # lazy. add more args?
    if [ "${1}" == "-n" ] ; then
        echo ">> Mode set to DRY_RUN"
        DRY_RUN=1;
        ARG_STR="-n"
    fi


    # STASHING FAILS IF MMAP FAILS, WHICH IT DOES ALL THE TIME.
    # JUST ABORT IF BRANCH IS DIRTY.
    # REINTRODUCE STASHING IF YOU ARE WORKING ON A COMPUTER THAT DOESN'T SUCK.
    if [ "$BRANCH_DIRTY" ]; then
        echo ">> ${BRANCH} is dirty ಠ_ಠ"
        echo ">> Stash or commit before updating master."
        # echo ">> Stashing ${BRANCH} before updating master"
        # git stash -u
    else
        echo ">> ${BRANCH} was clean -- now updating master"

        git co ${TRUNK}

        BRANCH_DIRTY=$(git status --porcelain)

        if [ "$BRANCH_DIRTY" ]; then
            echo ">> ${TRUNK} is dirty ಠ_ಠ"
            echo ">> Stash or commit before pulling."
        else
            # for master, we just need whatever it's at before we pull
            OLD_HASH=$(git rev-parse ${TRUNK})
            echo ">> Old ${TRUNK} hash is ${OLD_HASH}"

            if [ "${DRY_RUN}" ] ; then
                echo ">> DRY_RUN: not really pulling"
            else
                git pull
            fi

            $GIT_ROOT/build/roll_changed_pkgs --revs $OLD_HASH HEAD ${ARG_STR}

            # update the branch you were on:
            git co ${BRANCH}

            OLD_HASH=$(git merge-base $BRANCH $TRUNK)
            echo ">> Rolling out changes on ${BRANCH} since ${OLD_HASH}"

            if [ "${DRY_RUN}" ] ; then
                echo ">> DRY_RUN: not really rebasing"
            else
                git rebase ${TRUNK}
            fi

            # if [ -n "$BRANCH_DIRTY" ]; then
            #     echo ">> Popping stash for ${BRANCH}"
            #     git stash pop
            # else
            #     echo ">> ${BRANCH} was clean -- no pop"
            # fi

            $GIT_ROOT/build/roll_changed_pkgs --revs $OLD_HASH HEAD ${ARG_STR}

        fi
    fi

    cd -
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

function grepstate()
{
    find . -name "*state.dat" | xargs grep -n "${@}" --color
}

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
        LINK_STR="--link "${LINK_REPO}
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




# Invoke while on a feature branch to rebase in changes from master and roll associated packages
function update_feature
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
    if [ -n "$TREE_DIRTY" ]; then
        git stash -u
    fi


    if [ "${ARG_STR}" ] ; then
        echo ">> DRY_RUN: not really rebasing"
    else
        git rebase ${TRUNK}
    fi

    if [ -n "$TREE_DIRTY" ]; then
        git stash pop
    fi

    $GIT_ROOT/build/roll_changed_pkgs --revs $DIVERGE_REV HEAD ${ARG_STR}
}
