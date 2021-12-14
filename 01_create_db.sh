#!/bin/sh

# do a few prep tasks 
./00_prep_tasks.sh

# Setup db sample
rm -rf /home/db2inst1/sample_backup
rm -rf /home/db2inst1/sample_arch1

mkdir /home/db2inst1/sample_backup
mkdir /home/db2inst1/sample_arch1

db2stop force
db2start

# Create database "sample"
# make sure that you drop db sample before you run the script
db2 -v "create database sample PAGESIZE 16 K"
db2 -v update db cfg for sample using LOGFILSIZ 40000 LOGPRIMARY 10 LOGSECOND 0
db2 -v activate db sample
db2 -v connect to sample
db2 -v "create table app1 ( t timestamp )"
db2 -v "create table app1b ( t timestamp )"
db2 -v "create table status ( I integer )"
db2 -v "create table app2 like syscat.columns"
db2 -v "create variable app2_count integer default 0"
db2 -v connect reset
