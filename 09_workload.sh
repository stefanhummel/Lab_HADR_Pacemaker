#!/bin/sh
clear
MAXI=100
db2 +o connect to sample user db2inst1 using 4711think_db2inst1
echo "Cleanup tables.... "
sleep 2
db2 +o DELETE FROM app2
db2 +o DELETE FROM status
for (( i=1; i < $MAXI; ++i))
do
  db2 +o connect to sample user db2inst1 using 4711think_db2inst1
  db2 +o DELETE FROM app2
  db2 +o "INSERT INTO app2 ( SELECT * FROM SYSCAT.COLUMNS )"
  db2 +o DELETE FROM app2
  db2 "INSERT INTO status VALUES ( $i )"
  db2 +o connect reset
  echo "Workload running at Iteration " $i "of" $MAXI "- Break with ctrl-c"
  sleep 3
#  clear
done
echo "Workload completed!"
