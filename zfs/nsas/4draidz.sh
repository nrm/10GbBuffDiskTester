#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-4dstripe.sh                                    #
#################################################################

# delete zpool
for i in {0..7}
do
    /sbin/zpool destroy storage$i
done

# create zpool STRIPE 4 disk
/sbin/zpool create -f storage0 raidz /dev/gpt/disk0 /dev/gpt/disk1 /dev/gpt/disk2 /dev/gpt/disk3
/sbin/zpool create -f storage1 raidz /dev/gpt/disk4 /dev/gpt/disk5 /dev/gpt/disk6 /dev/gpt/disk7
/sbin/zpool create -f storage2 raidz /dev/gpt/disk8 /dev/gpt/disk9 /dev/gpt/disk10 /dev/gpt/disk11
/sbin/zpool create -f storage3 raidz /dev/gpt/sata1d12 /dev/gpt/sata1d13 /dev/gpt/sata1d14 /dev/gpt/sata1d15

/sbin/zpool create -f storage4 raidz /dev/gpt/disk12 /dev/gpt/disk13 /dev/gpt/disk14 /dev/gpt/disk15
/sbin/zpool create -f storage5 raidz /dev/gpt/disk16 /dev/gpt/disk17 /dev/gpt/disk18 /dev/gpt/disk19
/sbin/zpool create -f storage6 raidz /dev/gpt/disk20 /dev/gpt/disk21 /dev/gpt/disk22 /dev/gpt/disk23
/sbin/zpool create -f storage7 raidz /dev/gpt/sata2d12 /dev/gpt/sata2d13 /dev/gpt/sata2d14 /dev/gpt/sata2d15

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool status
echo -e "\n"
