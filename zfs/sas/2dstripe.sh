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


# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/gpt/md2d0 /dev/gpt/md2d1
/sbin/zpool create storage1 /dev/gpt/md2d2 /dev/gpt/md2d3
/sbin/zpool create storage2 /dev/gpt/md2d4 /dev/gpt/md2d5
/sbin/zpool create storage3 /dev/gpt/md2d6 /dev/gpt/md2d7

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
