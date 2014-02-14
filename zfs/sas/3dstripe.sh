#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 3dstripe.sh                                        #
#################################################################

# delete zpool
for i in {0..7}
do
    /sbin/zpool destroy storage$i
done

#md2d0
#md2d1
#md2d10
#md2d11
#md2d12
#md2d13
#md2d14
#md2d15
#md2d16
#md2d17
#md2d18
#md2d19
#md2d2
#md2d20
#md2d21
#md2d22
#md2d23
#md2d3
#md2d4
#md2d5
#md2d6
#md2d7
#md2d8
#md2d9

# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/gpt/md2d0 /dev/gpt/md2d1 /dev/gpt/md2d2
/sbin/zpool create storage1 /dev/gpt/md2d3 /dev/gpt/md2d4 /dev/gpt/md2d5
/sbin/zpool create storage2 /dev/gpt/md2d6 /dev/gpt/md2d7 /dev/gpt/md2d8
/sbin/zpool create storage3 /dev/gpt/md2d9 /dev/gpt/md2d10 /dev/gpt/md2d11

/sbin/zpool create storage4 /dev/gpt/md1d0 /dev/gpt/md1d1 /dev/gpt/md1d2
/sbin/zpool create storage5 /dev/gpt/md1d3 /dev/gpt/md1d4 /dev/gpt/md1d5
/sbin/zpool create storage6 /dev/gpt/md1d6 /dev/gpt/md1d7 /dev/gpt/md1d8
/sbin/zpool create storage7 /dev/gpt/md1d9 /dev/gpt/md1d10 /dev/gpt/md1d11

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
