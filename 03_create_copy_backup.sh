#!/bin/sh

# make sure all db connections are stopped
db2 deactivate db sample

# Create a database backup
db2 backup database sample to /home/db2inst1/sample_backup

# Copy the backup to server2
scp -p `ls -Art /home/db2inst1/sample_backup | tail -n 1` db2inst1@server2:/home/db2inst1/sample_backup

