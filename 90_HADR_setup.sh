#!/bin/sh

# do a few prep tasks 
./00_prep_tasks.sh

# Setup db sample
ssh db2inst1@server1 ' rm -rf /home/db2inst1/sample_backup/* '
ssh db2inst1@server1 ' rm -rf /home/db2inst1/sample_arch1 '

ssh db2inst1@server1 ' mkdir /home/db2inst1/sample_backup '
ssh db2inst1@server1 ' mkdir /home/db2inst1/sample_arch1 '

# restart database on server1
ssh db2inst1@server1 ' db2stop force '
ssh db2inst1@server1 ' db2start '

# Create database "sample"
# make sure that you drop db sample before you run the script
ssh db2inst1@server1 ' db2 -v "create database sample PAGESIZE 16 K" '
ssh db2inst1@server1 ' db2 -v update db cfg for sample using LOGFILSIZ 40000 LOGPRIMARY 10 LOGSECOND 0 '
ssh db2inst1@server1 ' db2 -v activate db sample '
ssh db2inst1@server1 ' db2 -v connect to sample '
ssh db2inst1@server1 ' db2 -v "create table app1 ( t timestamp )" '
ssh db2inst1@server1 ' db2 -v "create table app1b ( t timestamp )" '
ssh db2inst1@server1 ' db2 -v "create table status ( I integer )" '
ssh db2inst1@server1 ' db2 -v "create table app2 like syscat.columns" '
ssh db2inst1@server1 ' db2 -v "create variable app2_count integer default 0" '
ssh db2inst1@server1 ' db2 -v connect reset '

# Enable log archiving
ssh db2inst1@server1 ' db2 -v update db cfg for sample using LOGARCHMETH1 "DISK:/home/db2inst1/sample_arch1/" '

# Setting up HADR cfg parameters on Primary database
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_LOCAL_HOST server1 '       # server name of HADR primary 
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_LOCAL_SVC 5005 '           # port of HADR primary
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_REMOTE_HOST server2 '      # server name of HADR standby
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_REMOTE_SVC 5005  '         # port of HADR standby
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_REMOTE_INST db2inst1  '    # Db2 instance name on standby
ssh db2inst1@server1 ' db2 -v update db cfg for sample using LOGINDEXBUILD ON '
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_SYNCMODE NEARSYNC '        # or SYNC
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_PEER_WINDOW 120 '

# make sure all db connections are stopped
ssh db2inst1@server1 ' db2 -v deactivate db sample '

# Create a database backup
ssh db2inst1@server1 ' db2 -v backup database sample to /home/db2inst1/sample_backup '

# Copy the backup to server2
ssh db2inst1@server2 'if [ ! -d /home/db2inst1/sample_backup ];then mkdir /home/db2inst1/sample_backup;fi' 
ssh db2inst1@server2 ' rm -rf /home/db2inst1/sample_backup/* '
ssh db2inst1@server1 ' scp -p `ls -Art /home/db2inst1/sample_backup | tail -n 1` db2inst1@server2:/home/db2inst1/sample_backup '

