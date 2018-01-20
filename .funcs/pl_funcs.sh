
#=========================================
# FUN WITH FUNCTIONS
#
# These functions are aliased here rather
#  than in the .aliases dir
#=========================================

function mnt()
{
    #mintty -t hello -e /bin/bash - &
    mintty -i /Cygwin-Terminal.ico  - &
}

# GET ALL OUR MINTTY WINDOWS SET UP
function hello()
{
    local COL1_X=1913
    local COL2_X=2870
    local ROW1_Y=0
    local ROW2_Y=540

    # Open our helper local window right below the first one:
    mintty -i /Cygwin-Terminal.ico -p ${COL1_X},${ROW2_Y} - &

    # Open a couple of dev-lnx windows in the right column:
    ssh_devlnx ${COL2_X} ${ROW1_Y}
    ssh_devlnx ${COL2_X} ${ROW2_Y}

    ### TO DO
    ### - sync_config
    ### - backup thing like denny does

    #update_all_repos

}

function update_all_repos
{
    local REPOS="f1 f2 f3 f4"
    local MASTER=master

    #local FEATURE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    #local GIT_ROOT=$(git rev-parse --show-toplevel)
    local DIVERGE_REV=$(git merge-base master master)

    local TREE_DIRTY=$(git status --porcelain)

    # do master first
    TREE_DIRTY=$(git status --porcelain)
    if [ -n "$TREE_DIRTY" ]; then
        git stash -u
    fi

    git rebase $TRUNK_BRANCH

    if [ -n "$TREE_DIRTY" ]; then
        git stash pop
    fi


    for REPO in ${REPOS}
    do
        echo "doing repo ${REPO}"

        DIVERGE_REV=$(git merge-base $REPO $TRUNK_BRANCH)
        TREE_DIRTY=$(git status --porcelain)
        if [ -n "$TREE_DIRTY" ]; then
            git stash -u
        fi

        git rebase $TRUNK_BRANCH

        if [ -n "$TREE_DIRTY" ]; then
            git stash pop
        fi

        $GIT_ROOT/build/roll_changed_pkgs --revs $DIVERGE_REV HEAD
    done
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

# SYNC CONFIG FILES WITH //DEV-LNX
function sync_config()
{
    local DST_BASE="//dev-lnx/home/ryman.amanda/"
    local DST_DIR="config"
    local FILES=".aliases .bash_profile .bashrc bin .emacs .emacs.d .funcs .profile .xemacs"

    local a=$PWD
    cd ${DST_BASE}
    if [ ! -e ${DST_DIR} ]; then
        echo "making ${DST_DIR}"
        mkdir ${DST_DIR}
    else
        echo "already have ${DST_DIR}"
    fi

    local DST_PATH=${DST_BASE}${DST_DIR}"/"

    echo "using ${DST_PATH}"

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
                      LINK_REPO="${2}"   # You may want to check validity of $2
                      shift 2
                      ;;
                  -h | --help)
                      display_help
                      break
                      ;;
                  -n|--dry-run)
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

# Invoke while on a feature branch to rebase in changes from master and
# roll associated packages
function update_feature_branch_site
{
    local TRUNK_BRANCH=master
    local FEATURE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    local GIT_ROOT=$(git rev-parse --show-toplevel)
    local DIVERGE_REV=$(git merge-base $FEATURE_BRANCH $TRUNK_BRANCH)
    local TREE_DIRTY=$(git status --porcelain)
    if [ -n "$TREE_DIRTY" ]; then
        git stash -u
    fi
    git rebase $TRUNK_BRANCH
    if [ -n "$TREE_DIRTY" ]; then
        git stash pop
    fi
    $GIT_ROOT/build/roll_changed_pkgs --revs $DIVERGE_REV HEAD
}
