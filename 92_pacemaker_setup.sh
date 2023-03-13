#!/bin/sh

# do a few prep tasks 
echo "do a few prep tasks ..."

echo "Create the Pacemaker cluster and the public network resources ..."
ssh root@server1 ' db2cm -create -cluster -domain hadom -host server1 -publicEthernet ens33 -host server2 -publicEthernet ens33 '

echo "Create the instance resource model for both, server1 and server2 ..."
ssh root@server1 ' db2cm -create -instance db2inst1 -host server1 '
ssh root@server1 ' db2cm -create -instance db2inst1 -host server2 '

echo "create the HADR database resources ..."
ssh root@server1 ' db2cm -create -db SAMPLE -instance db2inst1 '

echo "Create the virtual IP address (VIP) resources ..."
ssh root@server1 ' db2cm -create -primaryVIP 10.0.0.101 -db SAMPLE -instance db2inst1 '

echo "install the Corosync QNet software ..."
# ssh root@server3 ' dnf localinstall -y /tmp/db2_11.5.7/db2/linuxamd64/pcmk/Linux/rhel/x86_64/corosync-qnetd* '
ssh root@server3 ' dnf localinstall -y /root/Downloads/universal/db2/linuxamd64/pcmk/Linux/rhel/x86_64/corosync-qnetd* '

echo "Create Qdevice ..."
ssh root@server1 ' db2cm -create -qdevice server3 '

echo "done."
echo " "
echo "Finally, check the configuration with the following commands. You need root privileges."
echo "  crm status "
echo "  db2cm -list "
echo " "

