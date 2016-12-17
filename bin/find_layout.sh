#!/bin/bash

if [ -a ~/rel/dat/common/layout/Make_$1.dat ] ; then
   emacs ~/rel/dat/common/layout/Make_$1.dat &
elif [ -a ~/rel/dat/common/layout/Create_$1.dat ] ; then  
   emacs ~/rel/dat/common/layout/Create_$1.dat &
fi
