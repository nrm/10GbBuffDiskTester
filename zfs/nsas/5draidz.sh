#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-5draidz.sh                                     #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

# create zpool RAIDZ 5 disk
/sbin/zpool create storage0 raidz /dev/gpt/disk0 /dev/gpt/disk1 /dev/gpt/disk2 /dev/gpt/disk3 /dev/gpt/disk4
/sbin/zpool create storage1 raidz /dev/gpt/disk5 /dev/gpt/disk6 /dev/gpt/disk7 /dev/gpt/disk8 /dev/gpt/disk9
/sbin/zpool create storage2 raidz /dev/gpt/disk10 /dev/gpt/disk11 /dev/gpt/disk12 /dev/gpt/disk13 /dev/gpt/disk14
/sbin/zpool create storage3 raidz /dev/gpt/disk15 /dev/gpt/disk16 /dev/gpt/disk17 /dev/gpt/disk18 /dev/gpt/disk19

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
