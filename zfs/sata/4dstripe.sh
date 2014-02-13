#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-4dstripe.sh                                    #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3


# create zpool STRIPE 4 disk
/sbin/zpool create storage0 /dev/da90 /dev/da91 /dev/da92 /dev/da93
/sbin/zpool create storage1 /dev/da94 /dev/da95 /dev/da96 /dev/da97
/sbin/zpool create storage2 /dev/da98 /dev/da99 /dev/da88 /dev/da89
/sbin/zpool create storage3 /dev/da100 /dev/da101 /dev/da102 /dev/da103

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
