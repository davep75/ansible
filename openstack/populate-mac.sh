#!/bin/bash
#set -x
for INT in ens6f0v0 ens6f0v1 ens6f0v2
do
MAC=$( ip l show dev $INT | grep link/ether | awk '{print $2}' )
echo "        $INT:
            link: ens6f0np0
            match:
                macaddress: $MAC" >> net.yaml
done

for INT in ens9f0v0 ens9f0v1 ens9f0v2
do
MAC=$( ip l show dev $INT | grep link/ether | awk '{print $2}' )
echo "        $INT:
            link: ens9f0np0
            match:
                macaddress: $MAC" >> net.yaml
done
