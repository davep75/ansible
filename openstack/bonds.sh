#!/bin/bash
#set -x
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
                up-delay: 0" >> net.yaml
