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
/sbin/zpool create storage0 raidz /dev/gpt/disk0 /dev/gpt/disk1 /dev/gpt/disk2
/sbin/zpool create storage1 raidz /dev/gpt/disk3 /dev/gpt/disk4 /dev/gpt/disk5
/sbin/zpool create storage2 raidz /dev/gpt/disk6 /dev/gpt/disk7 /dev/gpt/disk8
/sbin/zpool create storage3 raidz /dev/gpt/disk9 /dev/gpt/disk10 /dev/gpt/disk11

/sbin/zpool create storage4 raidz /dev/gpt/disk12 /dev/gpt/disk13 /dev/gpt/disk14
/sbin/zpool create storage5 raidz /dev/gpt/disk15 /dev/gpt/disk16 /dev/gpt/disk17
/sbin/zpool create storage6 raidz /dev/gpt/disk18 /dev/gpt/disk19 /dev/gpt/disk20
/sbin/zpool create storage7 raidz /dev/gpt/disk21 /dev/gpt/disk22 /dev/gpt/disk23

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
