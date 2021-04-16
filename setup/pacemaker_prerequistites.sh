### https://www.ibm.com/docs/en/db2/11.5?topic=pacemaker-prerequisites-integrated-solution-using

# Passwordless SSH for root  user 
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub root@server1
ssh-copy-id -i ~/.ssh/id_rsa.pub root@server2
ssh-copy-id -i ~/.ssh/id_rsa.pub root@server3

# Passwordless SSH for instance user 
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub db2inst1@server1
ssh-copy-id -i ~/.ssh/id_rsa.pub db2inst1@server2
ssh-copy-id -i ~/.ssh/id_rsa.pub db2inst1@server3

cat ~/id_rsa.pub >> ~/.ssh/authorized_keys

	

# Alias db2inst1
alias s1="ssh -X db2inst1@server1"
alias s2="ssh -X db2inst1@server2"
alias s3="ssh -X db2inst1@server3"

# Alias root
alias s1="ssh -X root@server1"
alias s2="ssh -X root@server2"
alias s3="ssh -X root@server3"

# ksh
yum install ksh

# /etc/hosts
10.0.0.1    goofymccarthy.ibmcloud.skytapdns.com    server1
10.0.0.2    stupefiedsammet.ibmcloud.skytapdns.com  server2
10.0.0.3    ecstaticbenz.ibmcloud.skytapdns.com     server3

# Disable the Db2 fault monitor
db2greg -updinstrec instancename=db2inst1 startatboot=0
ps -eaf |grep -i db2fmcu

# VIP server 1
cd /etc/sysconfig/network-scripts/
cp ifcfg-ens33 ifcfg-ens33:0

vi ifcfg-ens33:0
TYPE=Ethernet
DEVICE=ens33:0
IPADDR=10.0.0.201
NETMASK=255.0.0.0
NETWORK=10.0.0.0
BROADCAST=10.255.255.255
ONBOOT=yes

 more /etc/sysconfig/network-scripts/ifcfg-ens33:0


# ifconfig ens33:1 10.0.0.101 netmask 255.255.255.0
# systemctl restart NetworkManager.service
ip addr show
ping 10.0.0.201

# VIP server 2
analog

# VIP server 3
analog




### https://www.ibm.com/docs/en/db2/11.5?topic=utility-installing-pacemaker-cluster-software-stack

# Jupyter
[root@server3 ~]# yum install jupyter
Updating Subscription Management repositories.
Last metadata expiration check: 0:02:15 ago on Fri 16 Apr 2021 02:57:13 AM EDT.
No match for argument: jupyter
Error: Unable to find a match: jupyter
[root@server3 ~]# systemctl enable --now snapd.socket
Created symlink /etc/systemd/system/sockets.target.wants/snapd.socket → /usr/lib/systemd/system/snapd.socket.
[root@server3 ~]# ln -s /var/lib/snapd/snap /snap
[root@server3 ~]# 
[root@server3 ~]# 
[root@server3 ~]# snap install jupyter
error: too early for operation, device not yet seeded or device model not acknowledged
[root@server3 ~]# 
[root@server3 ~]# 
[root@server3 ~]# snap install jupyter
2021-04-16T03:02:02-04:00 INFO Waiting for automatic snapd restart...
Warning: /var/lib/snapd/snap/bin was not found in your $PATH. If you've not restarted your session
         since you installed snapd, try doing that. Please see https://forum.snapcraft.io/t/9469
         for more details.

jupyter 1.0.0 from Jupyter Project (projectjupyter✓) installed
[root@server3 ~]# 




