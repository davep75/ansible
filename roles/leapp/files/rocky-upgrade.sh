#!/bin/bash -x
/usr/bin/yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el7.noarch.rpm
echo $?
/usr/bin/yum install -y leapp-upgrade leapp-data-rocky
echo $?
# leapp answer --section remove_pam_pkcs11_module_check.confirm=True
# modprobe -r pata_acpi
#  rpm -e --nodeps `rpm -qa | egrep 'el7\.' `