#!/bin/sh

# do a few prep tasks 
echo "do a few prep tasks ..."
./00_prep_tasks.sh

# Setup db sample
echo "Prepare some directories ..."
ssh db2inst1@server1 ' rm -rf /home/db2inst1/sample_backup/* '
ssh db2inst1@server1 ' rm -rf /home/db2inst1/sample_arch1 '

ssh db2inst1@server1 'if [ ! -d /home/db2inst1/sample_backup ];then mkdir /home/db2inst1/sample_backup;fi' 
ssh db2inst1@server1 'if [ ! -d /home/db2inst1/sample_arch1 ];then mkdir /home/db2inst1/sample_arch1;fi' 

# restart database on server1
echo "Restart database on server1 ..."
ssh db2inst1@server1 ' db2stop force '
ssh db2inst1@server1 ' db2start '

# Create database "sample"
# make sure that you drop db sample before you run the script
echo "Create sample database ..."
ssh db2inst1@server1 ' db2 -v "create database sample PAGESIZE 16 K" '
ssh db2inst1@server1 ' db2 -v update db cfg for sample using LOGFILSIZ 40000 LOGPRIMARY 10 LOGSECOND 0 '
ssh db2inst1@server1 ' db2 -v activate db sample '
echo "Create some objects in sample database ..."
ssh db2inst1@server1 ' db2 -tvf /home/db2inst1/Lab_HADR_Pacemaker/91_HADR_database_objects.db2 '

# Enable log archiving
echo "Enable log archiving ..."
ssh db2inst1@server1 ' db2 -v update db cfg for sample using LOGARCHMETH1 "DISK:/home/db2inst1/sample_arch1/" '

# Setting up HADR cfg parameters on Primary database
echo "Setting up HADR cfg parameters on Primary database ..."
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_TARGET_LIST "server2:5005|server3:5005" '        
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_LOCAL_HOST server1 '       # server name of HADR primary 
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_LOCAL_SVC 5005 '           # port of HADR primary
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_REMOTE_HOST server2 '      # server name of HADR standby
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_REMOTE_SVC 5005  '         # port of HADR standby
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_REMOTE_INST db2inst1  '    # Db2 instance name on standby
ssh db2inst1@server1 ' db2 -v update db cfg for sample using LOGINDEXBUILD ON '
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_SYNCMODE NEARSYNC '        # or SYNC
ssh db2inst1@server1 ' db2 -v update db cfg for sample using HADR_PEER_WINDOW 120 '

# make sure all db connections are stopped
echo "Deactivate sample database ..."
ssh db2inst1@server1 ' db2 -v deactivate db sample '

# Create a database backup
echo "Create a database backup ..."
ssh db2inst1@server1 ' db2 -v backup database sample to /home/db2inst1/sample_backup '

# Copy the backup to server2
echo "Copy the backup to server2 ..."
ssh db2inst1@server2 'if [ ! -d /home/db2inst1/sample_backup ];then mkdir /home/db2inst1/sample_backup;fi' 
ssh db2inst1@server2 ' rm -rf /home/db2inst1/sample_backup/* '
ssh db2inst1@server1 ' scp -p `find /home/db2inst1/sample_backup | tail -n 1` db2inst1@server2:/home/db2inst1/sample_backup '

# Copy the backup to server3
echo "Copy the backup to server3 ..."
ssh db2inst1@server3 'if [ ! -d /home/db2inst1/sample_backup ];then mkdir /home/db2inst1/sample_backup;fi' 
ssh db2inst1@server3 ' rm -rf /home/db2inst1/sample_backup/* '
ssh db2inst1@server1 ' scp -p `find /home/db2inst1/sample_backup | tail -n 1` db2inst1@server3:/home/db2inst1/sample_backup '

# restore database on server2
echo "Restore database on server2 ..."
ssh db2inst1@server2 ' db2start '
ssh db2inst1@server2 ' db2 -v restore database sample from /home/db2inst1/sample_backup '

# restore database on server3
echo "Restore database on server3 ..."
ssh db2inst1@server3 ' db2start '
ssh db2inst1@server3 ' db2 -v restore database sample from /home/db2inst1/sample_backup '

# Setting up HADR cfg parameters on standby database
echo "Setting up HADR cfg parameters on primary standby database (server2)..."
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_TARGET_LIST "server1:5005|server3:5005" '        
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_LOCAL_HOST server2  '             #<IP ADDRESS ON STANDBY>
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_LOCAL_SVC 5005  '                 # ON STANDBY>
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_REMOTE_HOST server1  '    #<IP ADDRESS ON PRIM>
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_REMOTE_SVC 5005   '               # ON PRIM>
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_REMOTE_INST db2inst1  '   # <INSTNAME ON PRIM>
# Prerequisites for db2cm
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_SYNCMODE NEARSYNC  '      # NEARSYNC or SYNC
ssh db2inst1@server2 ' db2 -v update db cfg for sample using HADR_PEER_WINDOW 120 '

# Setting up HADR cfg parameters on standby database
echo "Setting up HADR cfg parameters on auxiliary standby database (server3) ..."
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_TARGET_LIST "server2:5005|server1:5005" '        
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_LOCAL_HOST server3  '             #<IP ADDRESS ON STANDBY>
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_LOCAL_SVC 5005  '                 # ON STANDBY>
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_REMOTE_HOST server1  '    #<IP ADDRESS ON PRIM>
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_REMOTE_SVC 5005   '               # ON PRIM>
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_REMOTE_INST db2inst1  '   # <INSTNAME ON PRIM>
# Prerequisites for db2cm
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_SYNCMODE superasync  '      
ssh db2inst1@server3 ' db2 -v update db cfg for sample using HADR_PEER_WINDOW 120 '


# starting up HADR on the standby server2
echo "Starting up HADR on the standby database on server2 ..."
ssh db2inst1@server2 ' db2 -v start hadr on database sample as standby '

# starting up HADR on the standby server3
echo "Starting up HADR on the standby database on server3 ..."
ssh db2inst1@server3 ' db2 -v start hadr on database sample as standby '

# starting up HADR on the primary server
echo "Starting up HADR on the primary server ..."
ssh db2inst1@server1 ' db2 -v start hadr on database sample as primary '

# Catalog database on server3:
echo "Catalog database on server3 ..."
ssh db2inst1@server3 ' db2start '
ssh db2inst1@server3 ' db2 catalog TCPIP NODE srv1 REMOTE 10.0.0.101 SERVER 25010 '
ssh db2inst1@server3 ' db2 CATALOG DATABASE sample AS db_srv1 AT NODE srv1 '

# Set alternate server for sample database
echo "Set alternate server for sample database ..."
ssh db2inst1@server1 ' db2 update alternate server for database sample using hostname 10.0.0.101 port 25010 '
ssh db2inst1@server2 ' db2 update alternate server for database sample using hostname 10.0.0.101 port 25010 '
ssh db2inst1@server3 ' db2 update alternate server for database sample using hostname 10.0.0.101 port 25010 '

echo "done."
echo " "

# Verifing HADR is up and running
# db2pd -db sample -hadr -repeat 1 120
echo "Finally, check the HADR configuration with the following commands. You need Db2 instance privileges."
echo "  db2pd -db sample -hadr "
echo "  db2pd -db sample -hadr -repeat 1 120 "
echo " "

