### Stop HADR

# Stop primary database first 

# stop standy database
db2 deactivate db sample
db2 stop hadr on database sample 
db2stop
