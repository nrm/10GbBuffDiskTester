#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-3dstripe.sh                                    #
#################################################################


#disk0
#disk1
#disk10
#disk11
#disk12
#disk13
#disk14
#disk15
#disk16
#disk17
#disk18
#disk19
#disk2
#disk20
#disk21
#disk22
#disk23
#disk3
#disk4
#disk5
#disk6
#disk7
#disk8
#disk9

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/gpt/disk0 /dev/gpt/disk1 /dev/gpt/disk2
/sbin/zpool create storage1 /dev/gpt/disk3 /dev/gpt/disk4 /dev/gpt/disk5
/sbin/zpool create storage2 /dev/gpt/disk6 /dev/gpt/disk7 /dev/gpt/disk8
/sbin/zpool create storage3 /dev/gpt/disk9 /dev/gpt/disk10 /dev/gpt/disk12

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
