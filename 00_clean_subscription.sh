#!/bin/sh

# run as root
echo "clean subscriptions"
subscription-manager unregister
# subscription-manager register --username ??? --password ??? --auto-attach --force
subscription-manager register --username AndreasChristian3 --auto-attach --force
subscription-manager refresh
subscription-manager attach --auto
echo "done!"
echo ""

