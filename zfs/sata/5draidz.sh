#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-5draidz.sh                                     #
#################################################################

# delete zpool
for i in {0..7}
do
    /sbin/zpool destroy storage$i
done

# create zpool RAIDZ 5 disk
/sbin/zpool create -f storage0 raidz /dev/gpt/sata1d0 /dev/gpt/sata1d1 /dev/gpt/sata1d2 /dev/gpt/sata1d3 /dev/gpt/sata1d4
/sbin/zpool create -f storage1 raidz /dev/gpt/sata1d5 /dev/gpt/sata1d6 /dev/gpt/sata1d7 /dev/gpt/sata1d8 /dev/gpt/sata1d9
/sbin/zpool create -f storage2 raidz /dev/gpt/sata1d10 /dev/gpt/sata1d11 /dev/gpt/sata1d12 /dev/gpt/sata1d13 /dev/gpt/sata1d14
/sbin/zpool create -f storage3 raidz /dev/gpt/disk0 /dev/gpt/disk1 /dev/gpt/disk2 /dev/gpt/disk3 /dev/gpt/disk4

/sbin/zpool create -f storage4 raidz /dev/gpt/sata2d0 /dev/gpt/sata2d1 /dev/gpt/sata2d2 /dev/gpt/sata2d3 /dev/gpt/sata2d4
/sbin/zpool create -f storage5 raidz /dev/gpt/sata2d5 /dev/gpt/sata2d6 /dev/gpt/sata2d7 /dev/gpt/sata2d8 /dev/gpt/sata2d9
/sbin/zpool create -f storage6 raidz /dev/gpt/sata2d10 /dev/gpt/sata2d11 /dev/gpt/sata2d12 /dev/gpt/sata2d13 /dev/gpt/sata2d14
/sbin/zpool create -f storage7 raidz /dev/gpt/disk23 /dev/gpt/disk22 /dev/gpt/disk21 /dev/gpt/disk20 /dev/gpt/disk19

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
