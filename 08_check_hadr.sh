#!/bin/sh

# Verifing HADR is up and running
# db2pd -db sample -hadr -repeat 1 120
db2pd -db sample -hadr 
