#!/bin/sh

LICFILE=./db2de.lic
if [ -f "$LICFILE" ]; then
    echo "Add $LICFILE to Db2 licenses."
    db2licm -a $LICFILE
    db2stop
    db2start
fi


