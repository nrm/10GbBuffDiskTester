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
/sbin/zpool create storage0 raidz /dev/da90 /dev/da91 /dev/da92
/sbin/zpool create storage1 raidz  /dev/da93 /dev/da94 /dev/da95
/sbin/zpool create storage2 raidz /dev/da96 /dev/da97 /dev/da98
/sbin/zpool create storage3 raidz /dev/da99 /dev/da910 /dev/da911

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
