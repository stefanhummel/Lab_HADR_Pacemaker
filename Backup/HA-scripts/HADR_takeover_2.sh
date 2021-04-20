### Stop HADR

# Stop primary database
db2 stop hadr on database sample
db2stop

# stop standy database
db2 deactivate db sample
db2 stop hadr on database sample 
db2stop

### HADR Takeover
db2 takeover hadr on database sample