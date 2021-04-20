### Configuring a clustered environment using the Db2 cluster manager (db2cm) utility
# https://www.ibm.com/docs/en/db2/11.5?topic=pacemaker-configuring-clustered-environment-using-db2cm-utility

# primary
# ip -172-31-15-79 
# server1

# secondary
# ip -172-31-10-145
# server2

# Create the Pacemaker cluster and the public network resources by running the following command.
# run as root:
/home/db2inst1/sqllib/adm/db2cm -create -cluster -domain hadom -host server1 -publicEthernet ens33 -host server2 -publicEthernet ens33

# Create the instance resource model
/home/db2inst1/sqllib/adm/db2cm -create -instance db2inst1 -host server1
/home/db2inst1/sqllib/adm/db2cm -create -instance db2inst1 -host server2

# Verify the cluster by using the crm status command
crm status

# Create a new database. For example, a database called SAMPLE. Then configure HADR on that new database. For more information on configuring HADR
# done

# Create the HADR database resources
/home/db2inst1/sqllib/adm/db2cm -create -db SAMPLE -instance db2inst1

# Create the VIP resources for the newly created database
/home/db2inst1/sqllib/adm/db2cm -create -primaryVIP 10.0.0.201 -db SAMPLE –instance db2inst1

# Verify the cluster again using crm status
crm status

# Verify that the associated constraints have been created by running the crm config show command
crm config show

### Install and configure a QDevice quorum
https://www.ibm.com/docs/en/db2/11.5?topic=utility-install-configure-qdevice-quorum

# As a root user, run
/home/db2inst1/sqllib/adm/db2cm -create -qdevice server3

# Run the following corosync command on the primary and standby hosts to verify that the quorum was setup correctly.
corosync-qdevice-tool -s

# Run the following corosync command on the QDevice host to verify that the quorum device is running correctly
corosync-qnetd-tool -l

# Verify that both the hosts, and the cluster resources are online. As a root user run the following command
/home/db2inst1/sqllib/adm/db2cm -list

### Associate a primary VIP with an existing HADR database of an instance
# As a root user, run
/home/db2inst1/sqllib/adm/db2cm -create -primaryVIP 10.0.0.101 -db SAMPLE -instance db2inst1

crm status



