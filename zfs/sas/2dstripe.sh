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
/sbin/zpool create storage0 /dev/gpt/md2d0 /dev/gpt/md2d1
/sbin/zpool create storage1 /dev/gpt/md2d2 /dev/gpt/md2d3
/sbin/zpool create storage2 /dev/gpt/md2d4 /dev/gpt/md2d5
/sbin/zpool create storage3 /dev/gpt/md2d6 /dev/gpt/md2d7

/sbin/zpool create storage4 /dev/gpt/md1d0 /dev/gpt/md1d1
/sbin/zpool create storage5 /dev/gpt/md1d2 /dev/gpt/md1d3
/sbin/zpool create storage6 /dev/gpt/md1d4 /dev/gpt/md1d5
/sbin/zpool create storage7 /dev/gpt/md1d6 /dev/gpt/md1d7

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done


# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
