#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-3draidz.sh                                     #
#################################################################

# delete zpool
for i in {0..7}
do
    /sbin/zpool destroy storage$i
done

# create zpool RAIDZ 3 disk
/sbin/zpool create -f storage0 raidz /dev/gpt/sata1d0 /dev/gpt/sata1d1 /dev/gpt/sata1d2
/sbin/zpool create -f storage1 raidz /dev/gpt/sata1d3 /dev/gpt/sata1d4 /dev/gpt/sata1d5
/sbin/zpool create -f storage2 raidz /dev/gpt/sata1d6 /dev/gpt/sata1d7 /dev/gpt/sata1d8
/sbin/zpool create -f storage3 raidz /dev/gpt/sata1d9 /dev/gpt/sata1d10 /dev/gpt/sata1d11

/sbin/zpool create -f storage4 raidz /dev/gpt/sata2d0 /dev/gpt/sata2d1 /dev/gpt/sata2d2
/sbin/zpool create -f storage5 raidz /dev/gpt/sata2d3 /dev/gpt/sata2d4 /dev/gpt/sata2d5
/sbin/zpool create -f storage6 raidz /dev/gpt/sata2d6 /dev/gpt/sata2d7 /dev/gpt/sata2d8
/sbin/zpool create -f storage7 raidz /dev/gpt/sata2d9 /dev/gpt/sata2d10 /dev/gpt/sata2d11

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
