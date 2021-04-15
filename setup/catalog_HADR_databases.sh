# create database

see /home/db2inst1/ALSM_app/setup.sh

# catalog database on server3
db2 catalog TCPIP NODE srv1 REMOTE server1 SERVER 50000
db2 CATALOG DATABASE sample AS db_srv1 AT NODE srv1
db2 update alternate server for database DB_SRV1  using hostname server2  port 50000

# uncatalog
db2 UNCATALOG DATABASE db_srv1
# db2 uncatalog TCPIP NODE srv1

db2 connect to db_srv1 user db2inst1 using db2inst1
# ...
db2 connect reset

# dsmtop
dsmtop -d DB_SRV1 -j 4 -u db2inst1 -p db2inst1


Exception java.net.ConnectException:                    
Error opening socket to server localhost/127.0.0.1 on port 50,000 with                      
message: Connection refused (Connection refused). ERRORCODE=-4499,                
SQLSTATE=08001 

db2set DB2COMM=tcpip
db2stop

Db2start