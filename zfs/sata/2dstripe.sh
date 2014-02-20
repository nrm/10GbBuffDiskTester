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

#da88
#da89
#da90
#da91
#da92
#da93
#da94
#da95
#da96
#da97
#da98
#da99
#da100
#da101
#da102


# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/da88 /dev/da89
/sbin/zpool create storage1 /dev/da90 /dev/da91
/sbin/zpool create storage2 /dev/da92 /dev/da93
/sbin/zpool create storage3 /dev/da94 /dev/da95

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool status storage7
echo -e "\n"
