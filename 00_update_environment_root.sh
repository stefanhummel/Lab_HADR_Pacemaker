#!/bin/sh
#################################################################
# Project:	Lab_HADR_pacemaker                                  #
# Skript:	00_update_environment_root.sh                       #
# Author:   Stefan Hummel                                       #
#           Andreas Christian                                   #
# Company:	IBM Germany                                         #
# Creation: 14.03.2023                                          #
#                                                               #
# Description :                                                 #
# Update the environment for user root. Run this script         #
# before you start the exercises.                               #
#                                                               #
# History:                                                      #
# --------                                                      #
# 14.03.2023  S.Hummel  first version                           #
#                                                               #
#################################################################


### add centOS repository 
REPOFILE=./centos7.repo
REPODIR=/etc/yum.repos.d
if [ -f "$REPOFILE" ]; then
    echo "Add $REPOFILE to OS repositories in $REPODIR."
    mv $REPOFILE $REPODIR/$REPOFILE
fi

### reset dependencies
yum module reset perl-DBD-SQLite -y
yum module reset perl-DBI -y
yum module reset perl-IO-Socket-SSL -y
yum module reset perl-libwww-perl -y


