#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 2dstripe.sh                                        #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

#da88
#da89
#da90
#da91
#da92
#da93
#da94
#da95
#da96
#da97
#da98
#da99
#da100
#da101
#da102


# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/da88 /dev/da89
/sbin/zpool create storage1 /dev/da90 /dev/da91
/sbin/zpool create storage2 /dev/da92 /dev/da93
/sbin/zpool create storage3 /dev/da94 /dev/da95

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
