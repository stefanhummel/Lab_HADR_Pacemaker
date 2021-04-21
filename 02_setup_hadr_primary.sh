#!/bin/sh

# Enable log archiving
db2 update db cfg for sample using LOGARCHMETH1 "DISK:/home/db2inst1/sample_arch1/"

# Take an offline backup
# db2 backup database sample to /home/db2inst1/sample_backup

# Setting up HADR cfg parameters on Primary database
db2 update db cfg for sample using HADR_LOCAL_HOST server1       # server name of HADR primary 
db2 update db cfg for sample using HADR_LOCAL_SVC 5005           # port of HADR primary
db2 update db cfg for sample using HADR_REMOTE_HOST server2      # server name of HADR standby
db2 update db cfg for sample using HADR_REMOTE_SVC 5005          # port of HADR standby
db2 update db cfg for sample using HADR_REMOTE_INST db2inst1     # Db2 instance name on standby
db2 update db cfg for sample using LOGINDEXBUILD ON
db2 update db cfg for sample using HADR_SYNCMODE NEARSYNC        # or SYNC
db2 update db cfg for sample using HADR_PEER_WINDOW 120
