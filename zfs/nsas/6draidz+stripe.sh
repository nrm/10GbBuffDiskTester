#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-3dstripe.sh                                    #
#################################################################

# check pool status before destroy pools
echo -e "\n\t\tcheck pool status before destroy pools\n"
/sbin/zpool list
echo -e "\n"
zpool status
echo -e "\n"
df -h
echo -e "\n"

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

# check pool status after destroy pools
echo -e "\n\t\tcheck pool status after destroy pools\n"
/sbin/zpool list
echo -e "\n"
zpool status
echo -e "\n"
df -h
echo -e "\n"

# create zpool raidz+stripe 6 disk
/sbin/zpool create storage0 raidz /dev/gpt/disk0 /dev/gpt/disk1 /dev/gpt/disk2 raidz /dev/gpt/disk3 /dev/gpt/disk4 /dev/gpt/disk5
/sbin/zpool create storage1 raidz /dev/gpt/disk6 /dev/gpt/disk7 /dev/gpt/disk8 raidz /dev/gpt/disk9 /dev/gpt/disk10 /dev/gpt/disk11
/sbin/zpool create storage2 raidz /dev/gpt/disk12 /dev/gpt/disk13 /dev/gpt/disk14 raidz /dev/gpt/disk15 /dev/gpt/disk16 /dev/gpt/disk17
/sbin/zpool create storage3 raidz /dev/gpt/disk18 /dev/gpt/disk19 /dev/gpt/disk20 raidz /dev/gpt/disk21 /dev/gpt/disk22 /dev/gpt/disk23

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
zpool status
echo -e "\n"
df -h
echo -e "\n"


