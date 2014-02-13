#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-3draidz.sh                                     #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

# create zpool RAIDZ 3 disk
/sbin/zpool create storage0 raidz /dev/da90 /dev/da91 /dev/da92
/sbin/zpool create storage1 raidz  /dev/da93 /dev/da94 /dev/da95
/sbin/zpool create storage2 raidz /dev/da96 /dev/da97 /dev/da98
/sbin/zpool create storage3 raidz /dev/da99 /dev/da910 /dev/da911

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
