# Here's the steps on switching roles (PRIMARY/STANDBY) between the two machine (server1 and server2).

# 1. ON PRIMARY (server1): 
db2 connect to <dbname>

# 2. ON PRIMARY (server1): 
db2 "create table tab1 (col1 int)"

# 3. ON PRIMARY (server1): db2 "insert into tab1 values (1)" -insert 20 rows

# 4. ON PRIMARY (server1): power down the Primary --> 
db2stop force

# 5. ON STANDBY (server2): 
db2 takeover hadr on database <dbname> by force

# 6. The STANDBY instance on server2 (DB2) is now the primary

# 7. ON server2: 
db2pd -db <dbname> -hadr (the ROLE should state: PRIMARY)

# 8. ON server2: 
db2 connect to <dbname>

# 9. ON server2: 
db2 "select * from tab1" -You should see the 20 rows inserted

# 10. ON server2: db2 "create table tab2 (col1 int)"

# 11. ON server2 db2 "insert into tab2 values (1)" -insert about 20 rows

# 12. ON server1: 
db2 start hadr on database <dbname> as standby

# 13. ON server1: 
db2pd -db <dbname> -hadr (the ROLE should state: STANDBY)

# 14. on server1: 
db2 takeover hadr on database <dbname>

# 15. on server1: 
db2pd -db <dbname> -hadr (the ROLE should state: PRIMARY)

# 16. ON server1: 
db2 "select * from tab2" -you should be able to see the 20 rows inserted

# 17. on server2: 
db2pd -db <dbname> -hadr (the ROLE should state; STANDBY)  
