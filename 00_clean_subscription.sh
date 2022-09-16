#!/bin/sh

# run as root
echo "clean subscriptions"
dnf clean all
rm -frv /var/cache/dnf
subscription-manager refresh
dnf update
echo "done!"
echo ""

