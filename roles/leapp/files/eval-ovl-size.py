#!/usr/libexec/platform-python
#
# DISCLAIMER: this script is not supported by Red Hat.
# Usage: ./eval-ovl-size.py
# Give a rough estimate of the required available space to in-place upgrade.

MIN_SIZE = 1024   # MB
EXTRA_MARGIN = 15 # %

import os, os.path, subprocess

def _shell(command):
    # works with python2.7 (el7) as well as python3 (el8)
    p = subprocess.Popen(command,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE,
                     close_fds=True,
                     shell=True,
                     universal_newlines=True)
    output = []
    while True:
        line = p.stdout.readline().rstrip('\n')
        if line:
            output.append(line)
        else:
            break
    return output

def get_rpms_size():
    rpms_size = 0
    for size in _shell("rpm -qa --queryformat '%{SIZE}\n'"):
        rpms_size += int(size)
    return rpms_size

def get_xfs_ftype(mp):
    return int(_shell("xfs_info %s | grep -o ftype=." % mp)[0].split('=')[1])

def find_mnt(path):
    path = os.path.abspath(path)
    while not os.path.ismount(path):
        path = os.path.dirname(path)
    return path

def get_partitions():
    parts = []
    with open('/proc/mounts', 'r') as f:
        mounts = f.readlines()
    for mount in mounts:
        if not mount.startswith('/'):
            continue
        dev, mp, fstype, opts, _5, _6 = mount.split(' ')
        if mp.startswith('/run'):
            continue
        p = os.statvfs(mp)
        parts.append({
          'mp': mp,
          'fstype': fstype,
          'ftype': get_xfs_ftype(mp) if fstype == 'xfs' else -1,
          'avail': p.f_bavail * p.f_frsize
        })
    return parts

def iter_parts(lmp):
    avail = 0
    xfs_parts = 0
    ftype_case = 0
    for p in get_partitions():
        if p['mp'] == lmp:
            avail = int(p['avail'] / 1024**2)
        if p['fstype'] == 'xfs':
            xfs_parts += 1
        if p['ftype'] == 0:
            ftype_case += 1
    return avail, xfs_parts, ftype_case

def show_eval(lmp, avail, xfs_parts, ftype_case, rpms_size):
    print("== Summary ==")
    print("`/var/lib/leapp` resides on the `%s` partition" % lmp)
    print("Current available space in `%s`: %s MB" % (lmp, avail))
    print("Installed size for all RPMs: %s MB" % rpms_size)
    if xfs_parts and ftype_case:
        ovl_size = int(rpms_size + (rpms_size * EXTRA_MARGIN / 100))
        ovl_size = max(ovl_size, 2048) # don't use less than the default
        required = (ftype_case * ovl_size) + MIN_SIZE
        print("\n== XFS ftype=0 case ==")
        if ovl_size > 2048:
            print("-> Adjust $LEAPP_OVL_SIZE before running Leapp:\n" \
                  "\t# export LEAPP_OVL_SIZE=%s" % ovl_size)
        print("-> Required space in the `%s` partition is:\n" \
              "\tNumberOfXfsMountedPartitions * LEAPP_OVL_SIZE = %s MB" % (lmp, required))
        if avail < required:
            estimated = required - avail + 1
            print("There is not enough space in `%s`, extend it at least by %s MB" % (lmp, estimated))
        print("-> If Leapp/DNF requires again more space:\n" \
              "\t- adjust $LEAPP_OVL_SIZE with a bigger size\n" \
              "\t- AND extend the `%s` partition accordingly." % lmp)
    else:
        required = int(rpms_size + (rpms_size * EXTRA_MARGIN / 100) + MIN_SIZE)
        print("\n== Standard case ==")
        if avail < required:
            estimated = required - avail + 1
            print("There is not enough space in `%s`, extend it at least by %s MB" % (lmp, estimated))
        print("-> If Leapp/DNF requires again more space, you need to extend the `%s` partition." % lmp)
    print("\nFor more information, please read https://access.redhat.com/solutions/5057391")

if __name__ == '__main__':
    lmp = find_mnt('/var/lib/leapp')
    avail, xfs_parts, ftype_case = iter_parts(lmp)
    rpms_size = int(get_rpms_size() / 1024**2)
    show_eval(lmp, avail, xfs_parts, ftype_case, rpms_size)
