#!/bin/bash


# each arg is a dir.
# for each dir
#    check that it exists
#    for each file in that dir, do rcsdiff -b {file}



if [ "${#}" != 0 ]; then

    for DIR in "${@}"
    do
	echo " >>> Checking dir ${DIR}"
	
	if [ -d ${DIR} ]; then
	    FILES="${DIR}*"
	    for FILE in $FILES; do
		echo " --- Checking file ${FILE}"
		if [ "${FILE}" != "." ] && [ "${FILE}" != ".." ]; then
		    rcsdiff -b "${FILE}"
		fi
	    done
	else
	    echo "!!! Directory ${p} could not be found."
	fi
    done
fi



# while [ "$i" -lt "$ARG_NUM" ]
# do
#     p=
#     echo "doing arg ${i} "
#     if [ $p == "-r" ]; then
# done
