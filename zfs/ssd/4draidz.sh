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
/sbin/zpool create -f storage0 raidz /dev/gpt/ssd1d0 /dev/gpt/ssd1d1 /dev/gpt/ssd1d2 /dev/gpt/ssd1d3
/sbin/zpool create -f storage1 raidz /dev/gpt/ssd1d4 /dev/gpt/ssd1d5 /dev/gpt/ssd1d6 /dev/gpt/ssd1d7
/sbin/zpool create -f storage2 raidz /dev/gpt/ssd1d8 /dev/gpt/ssd1d9 /dev/gpt/ssd1d10 /dev/gpt/ssd1d11
/sbin/zpool create -f storage3 raidz /dev/gpt/disk0 /dev/gpt/disk1 /dev/gpt/disk2 /dev/gpt/disk3

/sbin/zpool create -f storage4 raidz /dev/gpt/ssd2d0 /dev/gpt/ssd2d1 /dev/gpt/ssd2d2 /dev/gpt/ssd2d3
/sbin/zpool create -f storage5 raidz /dev/gpt/ssd2d4 /dev/gpt/ssd2d5 /dev/gpt/ssd2d6 /dev/gpt/ssd2d7
/sbin/zpool create -f storage6 raidz /dev/gpt/ssd2d8 /dev/gpt/ssd2d9 /dev/gpt/ssd2d10 /dev/gpt/ssd2d11
/sbin/zpool create -f storage7 raidz /dev/gpt/disk4 /dev/gpt/disk5 /dev/gpt/disk6 /dev/gpt/disk7

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
