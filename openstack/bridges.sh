#!/bin/bash
set -x
lastoctet=$(( $(/bin/hostname | /bin/sed -e 's/va32losnova2//') + 20 ))
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
            - 10.62.166.${lastoctet}/22
            gateway4: 10.62.167.254
            mtu: 1500
            nameservers:
                addresses:
                - 100.65.130.34
                - 100.64.118.133
            parameters:
                forward-delay: 15
                stp: false

        br-data:
            addresses:
            - 10.62.162.${lastoctet}/24
            mtu: 1500
            nameservers:
                addresses:
                - 100.62.163.15
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
                - 100.62.163.15
                - 100.65.130.34
                - 100.64.118.131
                search:
                - maas
            parameters:
                forward-delay: 15
                stp: false
" >> net.yaml
