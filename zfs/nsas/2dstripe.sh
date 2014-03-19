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
/sbin/zpool create storage0 /dev/gpt/disk23 /dev/gpt/disk22
/sbin/zpool create storage1 /dev/gpt/disk21 /dev/gpt/disk20
/sbin/zpool create storage2 /dev/gpt/disk19 /dev/gpt/disk18
/sbin/zpool create storage3 /dev/gpt/disk16 /dev/gpt/disk17

/sbin/zpool create storage4 /dev/gpt/disk16 /dev/gpt/disk15
/sbin/zpool create storage5 /dev/gpt/disk13 /dev/gpt/disk14
/sbin/zpool create storage6 /dev/gpt/disk12 /dev/gpt/disk11
/sbin/zpool create storage7 /dev/gpt/disk9 /dev/gpt/disk10

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
