#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 2dstripe.sh                                        #
#################################################################

# delete zpool
for i in {0..7}
do
    /sbin/zpool destroy storage$i
done

# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/gpt/disk0 /dev/gpt/disk1
/sbin/zpool create storage1 /dev/gpt/disk2 /dev/gpt/disk3
/sbin/zpool create storage2 /dev/gpt/disk4 /dev/gpt/disk5
/sbin/zpool create storage3 /dev/gpt/disk6 /dev/gpt/disk7

/sbin/zpool create storage4 /dev/gpt/disk8 /dev/gpt/disk9
/sbin/zpool create storage5 /dev/gpt/disk10 /dev/gpt/disk11
/sbin/zpool create storage6 /dev/gpt/disk12 /dev/gpt/disk13
/sbin/zpool create storage7 /dev/gpt/disk14 /dev/gpt/disk15

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
