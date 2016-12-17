
#========================================= 
# FUNCTIONS THAT DON'T WORK. YET.
#=========================================




# TO DO :::
# o write a func that operates on the output of $ find to open one of the found files in emacs
#     - optionally take an arg for line number
# o make rod/rot/rodme/rotme the same func -- different aliases call the same func w/ different args




# BUILD FS MOUNTS ON DEV -- doesn't work :(
function dfs()
{
    a=$PWD
    cd ~/ryman.amanda/home/pl_dev/web/
    __maint__/plscript __maint__/util/config/build_fs_mounts.pls $1 amanda $2
    cd $a
}

# BUILD FS MOUNTS ON TEST -- doesn't work :(
function tfs()
{
    a=$PWD
    cd ~/ryman.amanda/home/pl_test/web/
    __maint__/plscript __maint__/util/config/build_fs_mounts.pls $1 amanda $2
    cd $a
}

# FIND FILES THAT I OWN
# -- (not expecially useful since RCS makes the user of everything you update)
alias fme='findmine'
function findmine()
{
    find . -user ryman.amanda
}


#========================================= 
# FUNCTIONS I DON'T USE (YET)
#========================================= 


function sfile()
{
    if [ $# -gt 1 ] ; then
        find . -name "$1" | xargs grep -n --color -i "${*:2}"
    elif
	[ $# -gt 0 ] ; then
	find . -name "*\.*" ! -name "*,v"  | xargs grep -n --color -i "$@"
    fi
}

alias s='switch'
function switch()
{
    a=$PWD
    b=$(echo $a | sed "s/\/rel/\/backup/") 
    c=$(echo $a | sed "s/\/backup/\/rel/")
    if [ $b == $a ] && [ $c == $a ];    then
	b=$(echo $a | sed "s/\/test.perflogic.com/\/dev.perflogic.com/") 
	c=$(echo $a | sed "s/\/dev.perflogic.com/\/test.perflogic.com/")
    fi    
    
    if [ $b == $a ]
    then
	cd $c
    else
	cd $b
    fi
}


#alias cps='copy_switch'
function copy_switch()
{
    a=$PWD
    b=$(echo $a | sed "s/\/rel/\/backup/") 
    c=$(echo $a | sed "s/\/backup/\/rel/")
    if [ $b == $a ] && [ $c == $a ];    then
	b=$(echo $a | sed "s/\/test.perflogic.com/\/dev.perflogic.com/") 
	c=$(echo $a | sed "s/\/dev.perflogic.com/\/test.perflogic.com/")
    fi    
    
    if [ $b == $a ]
    then
	cp -i $@ $c
    else
	cp -i $@ $b
    fi
}

#alias sdiff='switch_diff'
function switch_diff()
{
    a=$PWD
    b=$(echo $a | sed "s/\/rel/\/backup/") 
    c=$(echo $a | sed "s/\/backup/\/rel/")
    if [ $b == $a ] && [ $c == $a ];    then
	b=$(echo $a | sed "s/\/test.perflogic.com/\/dev.perflogic.com/") 
	c=$(echo $a | sed "s/\/dev.perflogic.com/\/test.perflogic.com/")
    fi    
    
    if [ $b == $a ]
    then
	diff $@ $c/$@
    else
	diff $@ $b/$@
    fi
}

function rlocks_all()
{
    # look through ALL relevant directories and check locks as well as norcs
    WD=${PWD}

    

    TMPFILE=~/my_locks.txt;
    echo "My locks:" > $TMPFILE
    echo "" >> $TMPFILE

    # some directories are not included like build/ or RCS/.  Some of these may be irrelevent too
    DIRS=( aspell base bzip cert cgi_base dat element element_base enum export file_util filter haru interp jpeg make manager_model manager_view mspack npapi openssl persist pl_app pl_plugin pl_pm plscript property regex remote zip zlib )

    DAT_DIRS=( admin arra bpa client common custom_spell db eoc health inspection offline pm pt spell strategic_plan template tester texas_dsrip va_eoc )

    COMMON_DIRS=( changes data_sets discussion docs filtering forms goals graphics graphing ideas inspections issues layout lessons library log meetings pdsa phase_2 phase_3 print profile projects reports requests resources risks setup status tabs tasks team todos uber_table updates )

    # # simple things for testing...
    # DIRS=( dat )
    # DAT_DIRS=( client )
    # COMMON_DIRS=( changes )

    CLIENT_DIRS=( abington ashland barrett bbtrails cadence cfhp childrens covenanthealth demo ejgh fintrack forrestgeneral harden hendry hip huron it jhs lansdale lifebridge natividad olmsted om oums parkland perflogic pinnacle rcrmc riverside rounding scvmc sfgh sickkids skf ski sni subsidium teletracking texas texasrhp14 texasrhp15 texasrhp3 texasrhp6 texasrhp7 tpc uhs umhs uthsc va-eoc visn10 visn22 visn4 wellmont wellspan )

    IGNORE_NORCS=( dat/client/ski dat/client/uhs dat/client/childrens dat/client/riverside dat/client/rounding pl_app)

    DIR_LIST=()

    NAME=amanda;
    
    for ii in ${DIRS[*]}
    do
        if [ $ii == "dat" ] ; then
            for jj in ${DAT_DIRS[*]}
            do
                if [ $jj == "client" ] ; then
                    for kk in ${CLIENT_DIRS[*]}
                    do
                        DIR_LIST+="$ii/$jj/$kk "
                    done
                elif [ $jj == "common" ] ; then
                    for kk in ${COMMON_DIRS[*]}
                    do
                        DIR_LIST+="$ii/$jj/$kk "
                    done
                    DIR_LIST+="$ii/$jj "
                else
                    DIR_LIST+="$ii/$jj "
                fi
                
            done
        else
            DIR_LIST+="$ii "
        fi
    done
    for ii in ${DIR_LIST[*]}
    do
        echo $ii
        cd ~/rel/$ii
        GREP_TMP=~/grep_tmp.txt
        if [ $ii == "dat/common" ] ; then
            rlocks | grep $NAME | grep -B1 "$NAME " >> $GREP_TMP
        else
            rlocks -r | grep $NAME | grep -B1 "$NAME " >> $GREP_TMP
        fi
        if [[ -s $GREP_TMP ]]; then
            cat $GREP_TMP >> $TMPFILE
            echo "" >> $TMPFILE
        fi;
        rm $GREP_TMP

        CHECK_NORCS=true;
        for jj in ${IGNORE_NORCS[*]}
        do
            if [ "$ii" == "$jj" ]; then
                CHECK_NORCS=false;
            fi;
        done

        # no square brackets here because it isn't a test
        if $CHECK_NORCS ; then
            NORCS_TMP=~/norcs_tmp.txt
            norcs > $NORCS_TMP
            if [[ -s $NORCS_TMP ]]; then
                echo "~/rel/$ii" >> $TMPFILE
                cat $NORCS_TMP >> $TMPFILE
                echo "" >> $TMPFILE
            fi;
            rm $NORCS_TMP
        fi;
    done

    echo ""
    cat $TMPFILE

    cd $WD
}

function rlocksf()
{
    # determine if a particular file is locked (or multiple files)
    rlocks | grep "$@"
}

function prop_list()
{
    if [ $# -eq 1 ] ; then
        PROP_FILE=$1;
        TMP_FILE=~/.dlj_tmp_file
        find ~/rel/ -name "$PROP_FILE.h" > $TMP_FILE
        echo ""
        echo "directory:  "
        sed -E "s/.*rel\/(.*)$PROP_FILE.*/\1/" $TMP_FILE
        
        if [ $1 == "Str_util" ] || [ $1 == "File_util" ]; then
            REP="_rep";
            PROP_FILE=$PROP_FILE$REP;
            echo ""
            echo " ** ** ** ** ** ** ** ** ** ** ** ** ** ** **"
            echo "        Searching $PROP_FILE.h instead"
            echo " ** ** ** ** ** ** ** ** ** ** ** ** ** ** **"
        fi
        # echo ""
        # echo "Showing commands  -- call with object.command()"
        # find ~/rel/ -name "$PROP_FILE.h" | xargs grep --color DCL_CMD
        # echo ""
        # echo "Showing properties -- call with object.property"
        # find ~/rel/ -name "$PROP_FILE.h" | xargs grep --color DCL_PROP
        
        echo ""
        echo "Showing commands  -- call with object.command()"
        echo ""
        find ~/rel/ -name "$PROP_FILE.h" | xargs sed -n -E "s/.*CMD\((.*)\).*/\1/p"
        echo ""
        echo "Showing commands  -- call with object.property"
        echo ""
        find ~/rel/ -name "$PROP_FILE.h" | xargs sed -n -E "s/.*PROP\((.*)\).*/\1/p"
        echo ""
    fi    
}

