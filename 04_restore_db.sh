#!/bin/sh
db2start
db2 -v restore database sample from /home/db2inst1/sample_backup

