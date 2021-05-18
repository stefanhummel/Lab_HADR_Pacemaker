#!/bin/sh
#########################################################################
#  This script is to setup a database for use with HADR on two server.
#
# primary host:		server2
# standby host:		server1
# database name: 	TRAINING
# HADR port:			5007
#
# perform all commands on server2
#########################################################################

# directories
rm -rf /home/db2inst1/training_backup
rm -rf /home/db2inst1/training_arch1
mkdir /home/db2inst1/training_backup
mkdir /home/db2inst1/training_arch1
ssh db2inst1@server1 ' mkdir /home/db2inst1/training_backup'
ssh db2inst1@server1 ' rm /home/db2inst1/training_backup/*'
ssh db2inst1@server1 ' mkdir /home/db2inst1/training_arch1'

# start Db2 instance just in case it is not started yet
db2start

db2 -v "drop database training"
ssh db2inst1@server1 'db2 deactivate db training '
ssh db2inst1@server1 'db2 stop hadr on database training '
ssh db2inst1@server1 'db2 drop database training '

### Create database "training"
# make sure that you drop db training before you run the script
db2 -v "create database training PAGESIZE 16 K"
db2 -v activate db training
db2 -v connect to training
db2 -v "create table T1 ( ts timestamp )"
db2 -v "insert into T1 values current timestamp"
db2 -v "commit"
db2 -v connect reset

# log settings
db2 -v update db cfg for training using LOGFILSIZ 10000 LOGPRIMARY 4 LOGSECOND 0
db2 -v update db cfg for training using LOGARCHMETH1 "DISK:/home/db2inst1/training_arch1/"

### create backup of database "training"
# make sure all db connections are stopped
db2 -v deactivate db training

# Create a database backup
db2 -v backup database training to /home/db2inst1/training_backup

# Copy the backup to server1
cd /home/db2inst1/training_backup
scp -p `ls -Art /home/db2inst1/training_backup | tail -n 1` db2inst1@server1:/home/db2inst1/training_backup

ssh db2inst1@server1 'ls -l /home/db2inst1/training_backup'
ssh db2inst1@server1 'db2 -v restore database training from /home/db2inst1/training_backup '

# Setting up HADR cfg parameters on primary database
db2 -v update db cfg for training using HADR_LOCAL_HOST server2 
db2 -v update db cfg for training using HADR_LOCAL_SVC 5007 
db2 -v update db cfg for training using HADR_REMOTE_HOST server1  
db2 -v update db cfg for training using HADR_REMOTE_SVC 5007  
db2 -v update db cfg for training using HADR_REMOTE_INST db2inst1  
db2 -v update db cfg for training using LOGINDEXBUILD ON
db2 -v update db cfg for training using HADR_SYNCMODE NEARSYNC      
db2 -v update db cfg for training using HADR_PEER_WINDOW 120

# Setting up HADR cfg parameters on standby database
ssh db2inst1@server1 'db2 -v update db cfg for training using LOGARCHMETH1 DISK:/home/db2inst1/training_arch1/  '
ssh db2inst1@server1 'db2 -v update db cfg for training using HADR_LOCAL_HOST server1  '
ssh db2inst1@server1 'db2 -v update db cfg for training using HADR_LOCAL_SVC 5007    '
ssh db2inst1@server1 'db2 -v update db cfg for training using HADR_REMOTE_HOST server2  '
ssh db2inst1@server1 'db2 -v update db cfg for training using HADR_REMOTE_SVC 5007  '
ssh db2inst1@server1 'db2 -v update db cfg for training using HADR_REMOTE_INST db2inst1  '
ssh db2inst1@server1 'db2 -v update db cfg for training using LOGINDEXBUILD ON '
ssh db2inst1@server1 'db2 -v update db cfg for training using HADR_SYNCMODE NEARSYNC  '
ssh db2inst1@server1 'db2 -v update db cfg for training using HADR_PEER_WINDOW 120 '

# start HADR processes
ssh db2inst1@server1 'db2 -v start hadr on database training as standby '
db2 -v start hadr on database training as primary
