
#=========================================
# FUNCTIONS THAT DON'T WORK OR THAT I DON'T USE YET
#=========================================

if [ "${WORK_ENV}" ] ; then

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
        if [ $b == $a ] && [ $c == $a ] ; then
        	b=$(echo $a | sed "s/\/test.perflogic.com/\/dev.perflogic.com/")
        	c=$(echo $a | sed "s/\/dev.perflogic.com/\/test.perflogic.com/")
        fi

        if [ $b == $a ] ; then
        	diff $@ $c/$@
        else
        	diff $@ $b/$@
        fi
    }

    function prop_list()
    {
        if [ $# -eq 1 ] ; then
            PROP_FILE=$1;
            TMP_FILE=~/.alr_tmp_file
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


fi
