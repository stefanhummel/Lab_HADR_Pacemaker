[root@server2 ~]$ /home/db2inst1/sqllib/adm/db2cm -create -db TRAINING -instance db2inst1
[root@server2 ~]$ /home/db2inst1/sqllib/adm/db2cm -create -primaryVIP 10.0.0.102 -db TRAINING -instance db2inst1

[db2inst1@server1 ~]$ db2 update alternate server for database TRAINING using hostname 10.0.0.102  port 50000
[db2inst1@server2 ~]$ db2 update alternate server for database TRAINING using hostname 10.0.0.102  port 50000



[root@server2 ~]# crm status
Cluster Summary:
  * Stack: corosync
  * Current DC: server2 (version 2.0.4-1.db2pcmk.el8-2deceaa3ae) - partition with quorum
  * Last updated: Thu Apr 29 16:54:40 2021
  * Last change:  Thu Apr 29 16:38:53 2021 by db2inst1 via crm_resource on server1
  * 2 nodes configured
  * 10 resource instances configured

Node List:
  * Online: [ server1 server2 ]

Full List of Resources:
  * db2_server1_ens33	(ocf::heartbeat:db2ethmon):	 Started server1
  * db2_server2_ens33	(ocf::heartbeat:db2ethmon):	 Started server2
  * db2_server1_db2inst1_0	(ocf::heartbeat:db2inst):	 Started server1
  * db2_server2_db2inst1_0	(ocf::heartbeat:db2inst):	 Started server2
  * Clone Set: db2_db2inst1_db2inst1_SAMPLE-clone [db2_db2inst1_db2inst1_SAMPLE] (promotable):
    * Masters: [ server1 ]
    * Slaves: [ server2 ]
  * db2_db2inst1_db2inst1_SAMPLE-primary-VIP	(ocf::heartbeat:IPaddr2):	 Started server1
  * Clone Set: db2_db2inst1_db2inst1_TRAINING-clone [db2_db2inst1_db2inst1_TRAINING] (promotable):
    * Masters: [ server1 ]
    * Slaves: [ server2 ]
  * db2_db2inst1_db2inst1_TRAINING-primary-VIP	(ocf::heartbeat:IPaddr2):	 Started server1


