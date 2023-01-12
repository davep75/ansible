#!/bin/bash

set -eu

# Install storcli
if [ ! -h /usr/sbin/storcli ] ; then
  cd /tmp
  wget http://va32lubunturepo01.mot.com/moto/megaraid/MegaRAID_Storage_Manager-16.05.04-01.deb
  apt install libstdc++5 libxrender1 libxtst6 libxi6 x11-common
  dpkg -i MegaRAID_Storage_Manager-16.05.04-01.deb
  ln -s '/usr/local/MegaRAID Storage Manager/StorCLI/storcli64' /usr/sbin/storcli
fi

# apt dist-upgrade
echo "deb [trusted=yes] http://va32lubunturepo01.mot.com/moto-custom/ubuntu focal upgrade" > /etc/apt/sources.list.d/moto.list 
apt update 
apt dist-upgrade -y

# change uid ad gid of systemd-coredump from 999 to 996
sed -i 's/:999:/:996:/' /etc/group
sed -i 's/:999:/:996:/' /etc/passwd

# Configure SWAP
if [ $(storcli /c0 show | grep UGood | grep -c SSD) -eq 2 ] ; then
  storcli /c0 add vd type=r0 drives=68:2-3
  dev=sdb
  while :
  do
    sleep 5
    if [ -b /dev/${dev} ] ; then
      break
    fi
  done
  parted -s /dev/${dev} mklabel gpt
  parted -s /dev/${dev} mkpart primary linux-swap 2048s 100%
  mkswap /dev/${dev}1
  uuid=$(blkid /dev/${dev}1 | grep -ioP '(?<= UUID=")[^"]*')
  echo "UUID=${uuid}  none swap sw,pri=3  0  0" >>/etc/fstab
  swapon -a
fi

# modify /etc/hosts
grep "END OPENSTACK-ANSIBLE MANAGED BLOCK" /etc/hosts >/dev/null 2>&1 || echo "### BEGIN OPENSTACK-ANSIBLE MANAGED BLOCK ###
10.62.161.13 va32losctlr203.maas va32losctlr203
10.62.161.12 va32losctlr202.maas va32losctlr202
10.62.161.11 va32losctlr201.maas va32losctlr201
10.62.161.132 va32losctlr203-aodh-container-52d6cc26.maas va32losctlr203-aodh-container-52d6cc26 va32losctlr203_aodh_container-52d6cc26
10.62.161.103 va32losctlr202-aodh-container-04870773.maas va32losctlr202-aodh-container-04870773 va32losctlr202_aodh_container-04870773
10.62.161.122 va32losctlr201-aodh-container-41f48ba5.maas va32losctlr201-aodh-container-41f48ba5 va32losctlr201_aodh_container-41f48ba5
10.62.161.168 va32losctlr203-barbican-container-09c759e7.maas va32losctlr203-barbican-container-09c759e7 va32losctlr203_barbican_container-09c759e7
10.62.161.151 va32losctlr202-barbican-container-20d91e69.maas va32losctlr202-barbican-container-20d91e69 va32losctlr202_barbican_container-20d91e69
10.62.161.141 va32losctlr201-barbican-container-48b98eec.maas va32losctlr201-barbican-container-48b98eec va32losctlr201_barbican_container-48b98eec
10.62.161.133 va32losctlr203-ceilometer-central-container-4749c9c3.maas va32losctlr203-ceilometer-central-container-4749c9c3 va32losctlr203_ceilometer_central_container-4749c9c3
10.62.161.138 va32losctlr202-ceilometer-central-container-1597f34d.maas va32losctlr202-ceilometer-central-container-1597f34d va32losctlr202_ceilometer_central_container-1597f34d
10.62.161.118 va32losctlr201-ceilometer-central-container-827c736e.maas va32losctlr201-ceilometer-central-container-827c736e va32losctlr201_ceilometer_central_container-827c736e
10.62.161.159 va32losctlr203-cinder-api-container-e51cd341.maas va32losctlr203-cinder-api-container-e51cd341 va32losctlr203_cinder_api_container-e51cd341
10.62.161.111 va32losctlr202-cinder-api-container-c09df014.maas va32losctlr202-cinder-api-container-c09df014 va32losctlr202_cinder_api_container-c09df014
10.62.161.154 va32losctlr201-cinder-api-container-46863ff0.maas va32losctlr201-cinder-api-container-46863ff0 va32losctlr201_cinder_api_container-46863ff0
10.62.161.161 va32losctlr203-nova-api-container-f1334498.maas va32losctlr203-nova-api-container-f1334498 va32losctlr203_nova_api_container-f1334498
10.62.161.104 va32losctlr202-nova-api-container-3cd0a18c.maas va32losctlr202-nova-api-container-3cd0a18c va32losctlr202_nova_api_container-3cd0a18c
10.62.161.182 va32losctlr201-nova-api-container-4579e17d.maas va32losctlr201-nova-api-container-4579e17d va32losctlr201_nova_api_container-4579e17d
10.62.161.39 va32losnova219.maas va32losnova219
10.62.161.38 va32losnova218.maas va32losnova218
10.62.161.37 va32losnova217.maas va32losnova217
10.62.161.36 va32losnova216.maas va32losnova216
10.62.161.35 va32losnova215.maas va32losnova215
10.62.161.34 va32losnova214.maas va32losnova214
10.62.161.33 va32losnova213.maas va32losnova213
10.62.161.32 va32losnova212.maas va32losnova212
10.62.161.46 va32losnova226.maas va32losnova226
10.62.161.21 va32losnova201.maas va32losnova201
10.62.161.44 va32losnova224.maas va32losnova224
10.62.161.45 va32losnova225.maas va32losnova225
10.62.161.24 va32losnova204.maas va32losnova204
10.62.161.25 va32losnova205.maas va32losnova205
10.62.161.26 va32losnova206.maas va32losnova206
10.62.161.27 va32losnova207.maas va32losnova207
10.62.161.28 va32losnova208.maas va32losnova208
10.62.161.29 va32losnova209.maas va32losnova209
10.62.161.43 va32losnova223.maas va32losnova223
10.62.161.48 va32losnova228.maas va32losnova228
10.62.161.49 va32losnova229.maas va32losnova229
10.62.161.47 va32losnova227.maas va32losnova227
10.62.161.22 va32losnova202.maas va32losnova202
10.62.161.23 va32losnova203.maas va32losnova203
10.62.161.50 va32losnova230.maas va32losnova230
10.62.161.30 va32losnova210.maas va32losnova210
10.62.161.31 va32losnova211.maas va32losnova211
10.62.161.40 va32losnova220.maas va32losnova220
10.62.161.41 va32losnova221.maas va32losnova221
10.62.161.51 va32losnova231.maas va32losnova231
10.62.161.52 va32losnova232.maas va32losnova232
10.62.161.53 va32losnova233.maas va32losnova233
10.62.161.54 va32losnova234.maas va32losnova234
10.62.161.55 va32losnova235.maas va32losnova235
10.62.161.56 va32losnova236.maas va32losnova236
10.62.161.57 va32losnova237.maas va32losnova237
10.62.161.58 va32losnova238.maas va32losnova238
10.62.161.59 va32losnova239.maas va32losnova239
10.62.161.60 va32losnova240.maas va32losnova240
10.62.161.61 va32losnova241.maas va32losnova241
10.62.161.62 va32losnova242.maas va32losnova242
10.62.161.63 va32losnova243.maas va32losnova243
10.62.161.64 va32losnova244.maas va32losnova244
10.62.161.65 va32losnova245.maas va32losnova245
10.62.161.66 va32losnova246.maas va32losnova246
10.62.161.67 va32losnova247.maas va32losnova247
10.62.161.68 va32losnova248.maas va32losnova248
10.62.161.69 va32losnova249.maas va32losnova249
10.62.161.70 va32losnova250.maas va32losnova250
10.62.161.71 va32losnova251.maas va32losnova251
10.62.161.72 va32losnova252.maas va32losnova252
10.62.161.73 va32losnova253.maas va32losnova253
10.62.161.74 va32losnova254.maas va32losnova254
10.62.161.75 va32losnova255.maas va32losnova255
10.62.161.76 va32losnova256.maas va32losnova256
10.62.161.77 va32losnova257.maas va32losnova257
10.62.161.78 va32losnova258.maas va32losnova258
10.62.161.79 va32losnova259.maas va32losnova259
10.62.161.80 va32losnova260.maas va32losnova260
10.62.161.81 va32losnova261.maas va32losnova261
10.62.161.82 va32losnova262.maas va32losnova262
10.62.161.83 va32losnova263.maas va32losnova263
10.62.161.84 va32losnova264.maas va32losnova264
10.62.161.85 va32losnova265.maas va32losnova265
10.62.161.86 va32losnova266.maas va32losnova266
10.62.161.87 va32losnova267.maas va32losnova267
10.62.161.88 va32losnova268.maas va32losnova268
10.62.161.89 va32losnova269.maas va32losnova269
10.62.161.90 va32losnova270.maas va32losnova270
10.62.161.91 va32losnova271.maas va32losnova271
10.62.161.92 va32losnova272.maas va32losnova272
10.62.161.93 va32losnova273.maas va32losnova273
10.62.161.94 va32losnova274.maas va32losnova274
10.62.161.95 va32losnova275.maas va32losnova275
10.62.161.201 va32losnova276.maas va32losnova276
10.62.161.202 va32losnova277.maas va32losnova277
10.62.161.203 va32losnova278.maas va32losnova278
10.62.161.204 va32losnova279.maas va32losnova279
10.62.161.142 va32losctlr203-horizon-container-5a0e3809.maas va32losctlr203-horizon-container-5a0e3809 va32losctlr203_horizon_container-5a0e3809
10.62.161.174 va32losctlr202-horizon-container-324cdd74.maas va32losctlr202-horizon-container-324cdd74 va32losctlr202_horizon_container-324cdd74
10.62.161.167 va32losctlr201-horizon-container-e4845765.maas va32losctlr201-horizon-container-e4845765 va32losctlr201_horizon_container-e4845765
10.62.161.116 va32losctlr203-panko-container-1da03f6b.maas va32losctlr203-panko-container-1da03f6b va32losctlr203_panko_container-1da03f6b
10.62.161.102 va32losctlr202-panko-container-3f2d9372.maas va32losctlr202-panko-container-3f2d9372 va32losctlr202_panko_container-3f2d9372
10.62.161.183 va32losctlr201-panko-container-bdbeb47b.maas va32losctlr201-panko-container-bdbeb47b va32losctlr201_panko_container-bdbeb47b
10.62.161.179 va32losctlr203-galera-container-86378c3b.maas va32losctlr203-galera-container-86378c3b va32losctlr203_galera_container-86378c3b
10.62.161.146 va32losctlr202-galera-container-13f3259e.maas va32losctlr202-galera-container-13f3259e va32losctlr202_galera_container-13f3259e
10.62.161.148 va32losctlr201-galera-container-b02d0c0d.maas va32losctlr201-galera-container-b02d0c0d va32losctlr201_galera_container-b02d0c0d
10.62.161.114 va32losctlr203-gnocchi-container-69f0e7ec.maas va32losctlr203-gnocchi-container-69f0e7ec va32losctlr203_gnocchi_container-69f0e7ec
10.62.161.199 va32losctlr202-gnocchi-container-8d551866.maas va32losctlr202-gnocchi-container-8d551866 va32losctlr202_gnocchi_container-8d551866
10.62.161.143 va32losctlr201-gnocchi-container-e2bcb8ae.maas va32losctlr201-gnocchi-container-e2bcb8ae va32losctlr201_gnocchi_container-e2bcb8ae
10.62.161.200 va32losctlr203-heat-api-container-d2ea8e42.maas va32losctlr203-heat-api-container-d2ea8e42 va32losctlr203_heat_api_container-d2ea8e42
10.62.161.106 va32losctlr202-heat-api-container-ff49850d.maas va32losctlr202-heat-api-container-ff49850d va32losctlr202_heat_api_container-ff49850d
10.62.161.139 va32losctlr201-heat-api-container-dda7f792.maas va32losctlr201-heat-api-container-dda7f792 va32losctlr201_heat_api_container-dda7f792
10.62.161.129 va32losctlr203-keystone-container-6a442102.maas va32losctlr203-keystone-container-6a442102 va32losctlr203_keystone_container-6a442102
10.62.161.192 va32losctlr202-keystone-container-070d1edd.maas va32losctlr202-keystone-container-070d1edd va32losctlr202_keystone_container-070d1edd
10.62.161.155 va32losctlr201-keystone-container-8caa33ac.maas va32losctlr201-keystone-container-8caa33ac va32losctlr201_keystone_container-8caa33ac
10.62.161.7 va32loshost201.maas va32loshost201
10.62.161.8 va32loshost202.maas va32loshost202
10.62.161.9 va32loshost203.maas va32loshost203
10.62.161.18 va32loslog203.maas va32loslog203
10.62.161.189 va32losctlr203-memcached-container-285ede00.maas va32losctlr203-memcached-container-285ede00 va32losctlr203_memcached_container-285ede00
10.62.161.101 va32losctlr202-memcached-container-d774758b.maas va32losctlr202-memcached-container-d774758b va32losctlr202_memcached_container-d774758b
10.62.161.160 va32losctlr201-memcached-container-beead442.maas va32losctlr201-memcached-container-beead442 va32losctlr201_memcached_container-beead442
10.62.161.17 va32losnagios202.maas va32losnagios202
10.62.161.97 va32losnagios201.maas va32losnagios201
10.62.161.127 va32losctlr203-neutron-server-container-a4ca9072.maas va32losctlr203-neutron-server-container-a4ca9072 va32losctlr203_neutron_server_container-a4ca9072
10.62.161.140 va32losctlr202-neutron-server-container-cd45104c.maas va32losctlr202-neutron-server-container-cd45104c va32losctlr202_neutron_server_container-cd45104c
10.62.161.119 va32losctlr201-neutron-server-container-0cba1d64.maas va32losctlr201-neutron-server-container-0cba1d64 va32losctlr201_neutron_server_container-0cba1d64
10.62.161.178 va32losctlr203-neutron-agents-container-d4088b73.maas va32losctlr203-neutron-agents-container-d4088b73 va32losctlr203_neutron_agents_container-d4088b73
10.62.161.187 va32losctlr202-neutron-agents-container-064e3898.maas va32losctlr202-neutron-agents-container-064e3898 va32losctlr202_neutron_agents_container-064e3898
10.62.161.173 va32losctlr201-neutron-agents-container-ff00ee5c.maas va32losctlr201-neutron-agents-container-ff00ee5c va32losctlr201_neutron_agents_container-ff00ee5c
10.62.161.134 va32losctlr201-placement-container-955729a6.maas va32losctlr201-placement-container-955729a6 va32losctlr201_placement_container-955729a6
10.62.161.166 va32losctlr202-placement-container-06ecb8a5.maas va32losctlr202-placement-container-06ecb8a5 va32losctlr202_placement_container-06ecb8a5
10.62.161.149 va32losctlr203-placement-container-688d8d15.maas va32losctlr203-placement-container-688d8d15 va32losctlr203_placement_container-688d8d15
10.62.161.177 va32losctlr203-rabbit-mq-container-a512c3b3.maas va32losctlr203-rabbit-mq-container-a512c3b3 va32losctlr203_rabbit_mq_container-a512c3b3
10.62.161.147 va32losctlr202-rabbit-mq-container-aa19aa48.maas va32losctlr202-rabbit-mq-container-aa19aa48 va32losctlr202_rabbit_mq_container-aa19aa48
10.62.161.137 va32losctlr201-rabbit-mq-container-3609f546.maas va32losctlr201-rabbit-mq-container-3609f546 va32losctlr201_rabbit_mq_container-3609f546
10.62.161.107 va32losctlr203-repo-container-e580dcb3.maas va32losctlr203-repo-container-e580dcb3 va32losctlr203_repo_container-e580dcb3
10.62.161.172 va32losctlr202-repo-container-610cfc1f.maas va32losctlr202-repo-container-610cfc1f va32losctlr202_repo_container-610cfc1f
10.62.161.188 va32losctlr201-repo-container-0e402971.maas va32losctlr201-repo-container-0e402971 va32losctlr201_repo_container-0e402971
10.62.161.176 va32losctlr203-utility-container-2878fd79.maas va32losctlr203-utility-container-2878fd79 va32losctlr203_utility_container-2878fd79
10.62.161.120 va32losctlr202-utility-container-7be46650.maas va32losctlr202-utility-container-7be46650 va32losctlr202_utility_container-7be46650
10.62.161.184 va32losctlr201-utility-container-fcc017ae.maas va32losctlr201-utility-container-fcc017ae va32losctlr201_utility_container-fcc017ae
### END OPENSTACK-ANSIBLE MANAGED BLOCK ###
10.62.161.10 va32cloud2    ctlr_vip
10.62.32.100 USIAD01.lenovo.com
100.65.159.100 va32fil01.mot.com
100.65.142.131 varana91-gen.mot.com varana91-gen" >> /etc/hosts

# change Linux Bridge to OpenVSwitch
ip link set dev br-mgt down
brctl delbr br-mgt ; sleep 1
ovs-vsctl add-br br-ex
ovs-vsctl add-br br-data
ovs-vsctl add-br br-stg
ovs-vsctl add-br br-mgt
ovs-vsctl add-port br-ex bond1
ovs-vsctl add-bond br-data bond2 ens6f0v1 ens9f0v1 bond_mode=balance-slb lacp=off
ovs-vsctl add-bond br-stg bond3 ens9f0v2 ens6f0v2 bond_mode=balance-slb lacp=off
ovs-vsctl add-bond br-mgt bond0 ens9f0v0 ens6f0v0 bond_mode=balance-slb lacp=off

# change openvswitch-switch start before network
sed -i '/Before/c\Before=systemd-networkd.service' /lib/systemd/system/openvswitch-switch.service

# Put SR-IOV into /etc/rc.local
echo "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

echo 3 > /sys/class/net/ens6f0np0/device/sriov_numvfs
echo 3 > /sys/class/net/ens9f0np0/device/sriov_numvfs
#
/usr/sbin/ip link set dev ens6f0np0 vf 0 vlan 110 trust on
/usr/sbin/ip link set dev ens9f0np0 vf 0 vlan 110 trust on
/usr/sbin/ip link set dev ens6f0np0 vf 1 vlan 260 trust on
/usr/sbin/ip link set dev ens9f0np0 vf 1 vlan 260 trust on
/usr/sbin/ip link set dev ens6f0np0 vf 2 vlan 310 trust on
/usr/sbin/ip link set dev ens9f0np0 vf 2 vlan 310 trust on" > /etc/rc.local

chmod 755 /etc/rc.local

mv /tmp/net.yaml /etc/netplan/50-cloud-init.yaml

netplan apply

brctl show | grep br-mgt || echo "It's good!"
ovs-vsctl show | grep -E 'br-mgt|br-data|br-stg|br-ex'

exit 0
