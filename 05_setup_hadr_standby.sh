#!/bin/sh

# Setting up HADR cfg parameters on standby database
db2 update db cfg for sample using HADR_LOCAL_HOST server2              #<IP ADDRESS ON STANDBY>
db2 update db cfg for sample using HADR_LOCAL_SVC 5005                  # ON STANDBY>
db2 update db cfg for sample using HADR_REMOTE_HOST server1     #<IP ADDRESS ON PRIM>
db2 update db cfg for sample using HADR_REMOTE_SVC 5005                 # ON PRIM>
db2 update db cfg for sample using HADR_REMOTE_INST db2inst1    # <INSTNAME ON PRIM>
# Prerequisites for db2cm
db2 update db cfg for sample using HADR_SYNCMODE NEARSYNC       # or SYNC
db2 update db cfg for sample using HADR_PEER_WINDOW 120
