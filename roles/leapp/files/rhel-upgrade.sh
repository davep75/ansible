#!/bin/bash
/usr/bin/yum install -y leapp-upgrade 
echo $?
leapp answer --section remove_pam_pkcs11_module_check.confirm=True
echo $?
