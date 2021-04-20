# Setup db sample
mkdir /home/db2inst1/sample_backup
mkdir /home/db2inst1/sample_arch1
mkdir /home/db2inst1/mirrorlog



# Setup Db2 HADR

# Step 1
# Create sample db 


# Step 2
# Enable log archiving
db2 update db cfg for sample using LOGARCHMETH1 "DISK:/home/db2inst1/sample_arch1/"


# Step 3
# Setting up HADR cfg parameters on Primary database
db2 update db cfg for sample using HADR_LOCAL_HOST server1 			# <IP ADDRESS OF PRIM>
db2 update db cfg for sample using HADR_LOCAL_SVC 5005 				# on PRIM>
db2 update db cfg for sample using HADR_REMOTE_HOST server2  		#<IP ADDRESS OF STNDBY>
db2 update db cfg for sample using HADR_REMOTE_SVC 5005 			# on STNDBY>
db2 update db cfg for sample using HADR_REMOTE_INST db2inst1 		# <INSTNAME OF STNDBY>
db2 update db cfg for sample using LOGINDEXBUILD ON
# Prerequisites for db2cm
db2 update db cfg for sample using HADR_SYNCMODE NEARSYNC 	# or SYNC
db2 update db cfg for sample using HADR_PEER_WINDOW 120



# Step 4
# Take an offline backup
# db2 list applications 
db2 backup database sample to /home/db2inst1/sample_backup


# Step 5
# FTP the backup image (from the primary machine) to the STANDBY MACHINE
scp -p `ls -Art /home/db2inst1/sample_backup | tail -n 1` db2inst1@server2:/home/db2inst1/sample_backup

# Step 6
# Restore db on standby server
# user db2inst1:
su - db2inst1
db2start
db2 restore database sample from /home/db2inst1/sample_backup


# Step 7
# Setting up HADR cfg parameters on standby database
db2 update db cfg for sample using HADR_LOCAL_HOST server2 		#<IP ADDRESS ON STANDBY>
db2 update db cfg for sample using HADR_LOCAL_SVC 5005 			# ON STANDBY>
db2 update db cfg for sample using HADR_REMOTE_HOST server1 	#<IP ADDRESS ON PRIM>
db2 update db cfg for sample using HADR_REMOTE_SVC 5005 		# ON PRIM>
db2 update db cfg for sample using HADR_REMOTE_INST db2inst1 	# <INSTNAME ON PRIM>

# Step 8
# Starting up HADR on the standby server
db2 start hadr on database sample as standby


# Step 9
# Starting up HADR on the primary server
db2 start hadr on database sample as primary


##### Verification ##### 
# Verifing HADR is up and running
db2pd -db sample -hadr -repeat 1 120


### run sample scripts:
db2 connect to sample
db2 -td@ -f /home/db2inst1/ALSM_app/app2.sql
