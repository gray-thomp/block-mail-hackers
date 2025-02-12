#!/bin/bash
# To regularly scan maillog and block brute force attacks

# make file of iptables rules
/usr/sbin/iptables -L -n > /root/iptables_output

# Get a list of ip addresses
IP_ADDRESSES=`/usr/bin/cat  /var/log/maillog | /usr/bin/grep 'authentication failed' | /usr/bin/grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | /usr/bin/sort -n `
# List the unique ip addresses
UNIQUE_IP_ADDRESSES=`echo "$IP_ADDRESSES" | uniq `

# For each one of the ip addresses count the number of 'authentication failed' messages
# A low number may be just mistake, but high number is a break-in attempt

for i in `echo "$UNIQUE_IP_ADDRESSES"`
do
    COUNT=`/usr/bin/grep "$i" /var/log/maillog | wc -l ` 
    if [ "$COUNT" -gt 5 ]
    then
    ## We now need to insert into iptables if it not already there
         /usr/bin/grep "$i" /root/iptables_output || /usr/sbin/iptables -I INPUT 1  -s $i  -j DROP         
    

    fi 



 
done

