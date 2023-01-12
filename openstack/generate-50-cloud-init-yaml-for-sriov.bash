#!/bin/bash

set -eu

cd /etc/netplan
cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.orig


sed -n '0,/^network:/p' /etc/netplan/50-cloud-init.yaml >/tmp/net.yaml
sed -n '$p' /etc/netplan/50-cloud-init.yaml >>/tmp/net.yaml
sed -n '/ethernets:/,$p' /etc/netplan/50-cloud-init.yaml | sed '$d'  >>/tmp/net.yaml

for INT in ens6f0v0 ens6f0v1 ens6f0v2
do
MAC=$( ip l show dev $INT  | grep link/ether | awk '{print $2}' )
echo "        $INT:
            link: ens6f0np0
            match:
                macaddress: $MAC" >> /tmp/net.yaml
done
for INT in ens9f0v0 ens9f0v1 ens9f0v2
do
MAC=$( ip l show dev $INT  | grep link/ether | awk '{print $2}' )
echo "        $INT:
            link: ens9f0np0
            match:
                macaddress: $MAC" >> /tmp/net.yaml
done

echo "    bonds:
        bond1:
            interfaces:
            - ens6f0np0
            - ens9f0np0
            mtu: 1500
            parameters:
                down-delay: 0
                lacp-rate: fast
                mii-monitor-interval: 100
                mode: 802.3ad
                transmit-hash-policy: layer2
                up-delay: 0" >> /tmp/net.yaml

lastoctet=$(( $(hostname  | sed -e 's/va32losnova2//') + 20 ))
if [ "$(hostname)" = "va32losnova276" ] ; then lastoctet=201 ; fi
if [ "$(hostname)" = "va32losnova277" ] ; then lastoctet=202 ; fi
if [ "$(hostname)" = "va32losnova278" ] ; then lastoctet=203 ; fi
if [ "$(hostname)" = "va32losnova279" ] ; then lastoctet=204 ; fi

echo "    bridges:
        br-mgt:
            addresses:
            - 10.62.161.${lastoctet}/24
            mtu: 1500
            nameservers:
                addresses:
                - 10.62.161.15
                search:
                - maas
            parameters:
                forward-delay: 15
                stp: false
        br-ex:
            addresses:
            - 10.62.166.${lastoctet}/23
            gateway4: 10.62.167.254
            mtu: 1500
            nameservers:
                addresses:
                - 100.65.130.34
                - 100.64.118.131
            parameters:
                forward-delay: 15
                stp: false
        br-data:
            addresses:
            - 10.62.162.${lastoctet}/24
            mtu: 1500
            nameservers:
                addresses:
                - 10.62.163.15
                - 100.65.130.34
                - 100.64.118.131
                search:
                - maas
            parameters:
                forward-delay: 15
                stp: false
        br-stg:
            addresses:
            - 10.62.163.${lastoctet}/24
            mtu: 1500
            nameservers:
                addresses:
                - 10.62.163.15
                - 100.65.130.34
                - 100.64.118.131
                search:
                - maas
            parameters:
                forward-delay: 15
                stp: false" >> /tmp/net.yaml

exit 0
