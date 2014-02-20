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

# create zpool RAIDZ 4 disk
/sbin/zpool create storage0 raidz /dev/gpt/md2d23 /dev/gpt/md2d22 /dev/gpt/md2d21 /dev/gpt/md2d20
/sbin/zpool create storage1 raidz /dev/gpt/md2d19 /dev/gpt/md2d18 /dev/gpt/md2d17 /dev/gpt/md2d16
/sbin/zpool create storage2 raidz /dev/gpt/md2d15 /dev/gpt/md2d14 /dev/gpt/md2d13 /dev/gpt/md2d12
/sbin/zpool create storage3 raidz /dev/gpt/md2d11 /dev/gpt/md2d10 /dev/gpt/md2d9 /dev/gpt/md2d8

/sbin/zpool create storage4 raidz /dev/gpt/md1d23 /dev/gpt/md1d22 /dev/gpt/md1d21 /dev/gpt/md1d20
/sbin/zpool create storage5 raidz /dev/gpt/md1d19 /dev/gpt/md1d18 /dev/gpt/md1d17 /dev/gpt/md1d16
/sbin/zpool create storage6 raidz /dev/gpt/md1d15 /dev/gpt/md1d14 /dev/gpt/md1d13 /dev/gpt/md1d12
/sbin/zpool create storage7 raidz /dev/gpt/md1d11 /dev/gpt/md1d10 /dev/gpt/md1d9 /dev/gpt/md1d8

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
