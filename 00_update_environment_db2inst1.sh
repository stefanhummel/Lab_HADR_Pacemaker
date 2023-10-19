#!/bin/sh
#################################################################
# Project:	Lab_HADR_pacemaker                                  #
# Skript:	00_update_environment_db2inst1.sh                   #
# Author:   Stefan Hummel                                       #
#           Andreas Christian                                   #
# Company:	IBM Germany                                         #
# Creation: 14.03.2023                                          #
#                                                               #
# Description :                                                 #
# Update the environment for user db2inst1. Run this script     #
# before you start the exercises.                               #
#                                                               #
# History:                                                      #
# --------                                                      #
# 14.03.2023  S.Hummel  first version                           #
#                                                               #
#################################################################


### add Db2 license 
LICFILE=./db2de.lic
if [ -f "$LICFILE" ]; then
    echo "Add $LICFILE to Db2 licenses."
    db2licm -a $LICFILE
    db2stop
    db2start
fi

echo " "
echo "Your environment is up to date. Have fun..."
