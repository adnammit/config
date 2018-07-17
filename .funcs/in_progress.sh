
#=========================================
# FUNCTIONS THAT DON'T WORK OR THAT I DON'T USE YET
#=========================================


function quick_test()
{
    BSUCCESS=$1
    MSUCCESS=$2

    # if [[ $BSUCCESS -eq 1 && $MSUCCESS -eq 1 ]] ; then
    if [[ $BSUCCESS == 1 && $MSUCCESS == 1 ]] ; then
        echo "return 1"
    else
        echo "return 0"
    fi

    if [[ $MSUCCESS ]] ; then
        echo "we have m success"
    else
        echo "we do not have m success"
    fi

}


# A func just for playing with things
function test_funcs()
{
    local SUCCESS=0

    function parse_result()
    {
        local SUCCESS=0
        local RESULT="${1}"

        local TMP=$(echo $RESULT | head -n1 | sed -e 's/ *\([a-zA-Z]*\).*/\1/')

        if [ "$TMP" == "Error" ] ; then
            echo "$RESULT"
            echo "Unsuccessful update ಠ╭╮ಠ"
        elif [ "$TMP" == "none" ] ; then
            SUCCESS=1
            echo "$RESULT"
            echo "Nothing to roll out ¯\_(ツ)_/¯"
        else
            SUCCESS=1
            echo "$RESULT"
            echo "Successful update! ~(˘▾˘~)"
        fi

        return $SUCCESS
    }

    parse_result $(echo "Error: we have one")
    SUCCESS=$?
    echo ">>> Success of error is ${SUCCESS}"
    echo "-------------------------------------"

    parse_result "none"
    SUCCESS=$?
    echo ">>> Success of none is ${SUCCESS}"
    echo "-------------------------------------"

    parse_result "some packages were rolled"
    SUCCESS=$?
    echo ">>> Success of successful roll is ${SUCCESS}"
    echo "-------------------------------------"

    parse_result
    SUCCESS=$?
    echo ">>> Success of null is ${SUCCESS}"
    echo "-------------------------------------"

    function get_return()
    {
        local BSUCCESS=0
        local MSUCCESS

        if [[ $BSUCCESS -eq 1 && $MSUCCESS -eq 1 ]] ; then
            echo "successes are equal"
        else
            echo "successes are not equal"
        fi
    }

    # get_return
    # local FINAL=$? # must be stored otherwise this next 'echo' statement will change $? to 0
    # echo "get_return's return is: "
    # echo $FINAL

    local result=$(get_return)
    echo "result is $result"


    function greater_than_five()
    {
        if [[ $1 -gt 5 ]] ; then
            return 1
        else
            return 0
        fi

    }
    # local my_result=$(greater_than_five 3)
    greater_than_five 6
    my_result=$?
    echo "my result is $my_result"


    function equal_to_five()
    {
        if [[ $1 -eq 5 ]] ; then
            echo "Your number is equal to five. Huzzah!"
        else
            echo "Whomp whomp, your number is not equal to five. Better luck next time."
        fi

    }
    local my_other_result=$(equal_to_five 5)
    echo "equal to five is: $my_other_result"
}

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
