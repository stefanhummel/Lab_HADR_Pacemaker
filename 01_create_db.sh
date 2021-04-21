#!/bin/sh

# Setup db sample
rm -rf /home/db2inst1/sample_backup
rm -rf /home/db2inst1/sample_arch1

mkdir /home/db2inst1/sample_backup
mkdir /home/db2inst1/sample_arch1

db2stop force
db2start

# Create database "sample"
# make sure that you drop db sample before you run the script
db2 "create database sample PAGESIZE 16 K"
db2 update db cfg for sample using LOGFILSIZ 40000 LOGPRIMARY 10 LOGSECOND 0
db2 activate db sample
db2 connect to sample
db2 "create table app1 ( t timestamp )"
db2 "create table app1b ( t timestamp )"
db2 "create table status ( I integer )"
db2 "create table app2 like syscat.columns"
db2 "create variable app2_count integer default 0"
db2 connect reset
