#!/bin/bash
set -x
/usr/bin/mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.orig
/usr/bin/sed -n '0,/^network:/p' /etc/netplan/50-cloud-init.yaml.orig > net.yaml
/usr/bin/sed -n '$p' /etc/netplan/50-cloud-init.yaml.orig >> net.yaml
/usr/bin/sed -n '/ethernets:/,$p' /etc/netplan/50-cloud-init.yaml.orig >> net.yaml
