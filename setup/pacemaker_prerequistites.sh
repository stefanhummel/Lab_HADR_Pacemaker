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



### https://www.ibm.com/docs/en/db2/11.5?topic=utility-installing-pacemaker-cluster-software-stack

# 