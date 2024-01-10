#!/bin/bash -x
# to save typing
# subscription-manager status
# subscription-manager list --consumed
# subscription-manager repos --enable rhel-7-server-rpms
# subscription-manager repos --enable rhel-7-server-extras-rpms
# subscription-manager release --unset
/usr/bin/yum install -y leapp-upgrade 
echo $?
# leapp answer --section remove_pam_pkcs11_module_check.confirm=True
# modprobe -r pata_acpi
# rm /etc/systemd/system/multi-user.target.wants/vncserver@:1.service
# rpm -e --nodeps `rpm -qa | egrep 'el7\.' `

