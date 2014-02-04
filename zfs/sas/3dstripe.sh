#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 3dstripe.sh                                        #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

#md2d0
#md2d1
#md2d10
#md2d11
#md2d12
#md2d13
#md2d14
#md2d15
#md2d16
#md2d17
#md2d18
#md2d19
#md2d2
#md2d20
#md2d21
#md2d22
#md2d23
#md2d3
#md2d4
#md2d5
#md2d6
#md2d7
#md2d8
#md2d9

# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/gpt/md2d0 /dev/gpt/md2d1 /dev/gpt/md2d2
/sbin/zpool create storage1 /dev/gpt/md2d3 /dev/gpt/md2d4 /dev/gpt/md2d5
/sbin/zpool create storage2 /dev/gpt/md2d6 /dev/gpt/md2d7 /dev/gpt/md2d8
/sbin/zpool create storage3 /dev/gpt/md2d9 /dev/gpt/md2d10 /dev/gpt/md2d11

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
