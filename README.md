# Db2 & Pacemaker cluster manager

The combination of Pacemaker and HADR enables high availability and disaster recovery for DB2 databases. It is currently supported for Db2 HADR clusters on Linux for on-prem deployments and is installed manually on top of Db2.  Pacemaker is planned to become the future cluster solution for all types of Db2 deployments including pureScale, DPF, and containerized Db2 deployments in the cloud. The Pacemaker software installation will be part of the Db2 installation in the future. One important difference to TSA is the usage of a quorum device that is supposed to run a separate server. 

HADR on its own provides mainly Disaster Recovery, by maintaining one or more synchronised copies of a DB2 database. If the primary DB2 server fails, there is a database copy (a standby database) that can be used instead of the primary database. The failover process (switching from a primary to standby database) must be initiated manually by a database administrator.

Pacemaker automates the failover process and helps to minimize the database downtime. It actively monitors the health of the databases and their host servers and in case of a failure automatically performs the switch to the standby server.
 
