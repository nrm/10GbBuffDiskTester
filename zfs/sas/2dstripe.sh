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

#MD2
#md2d0
#md2d1
#md2d2
#md2d3
#md2d4
#md2d5
#md2d6
#md2d7
#md2d8
#md2d9
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
#md2d20
#md2d21
#md2d22
#md2d23

# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/gpt/md2d23 /dev/gpt/md2d22
/sbin/zpool create storage1 /dev/gpt/md2d21 /dev/gpt/md2d20
/sbin/zpool create storage2 /dev/gpt/md2d19 /dev/gpt/md2d18
/sbin/zpool create storage3 /dev/gpt/md2d17 /dev/gpt/md2d16

/sbin/zpool create storage4 /dev/gpt/md1d23 /dev/gpt/md1d22
/sbin/zpool create storage5 /dev/gpt/md1d21 /dev/gpt/md1d20
/sbin/zpool create storage6 /dev/gpt/md1d19 /dev/gpt/md1d18
/sbin/zpool create storage7 /dev/gpt/md1d17 /dev/gpt/md1d16

# create mountpoint
for i in {0..7}
do
    /sbin/zfs create -o mountpoint=/ch$i -o atime=off storage${i}/s0;
done


# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool status
echo -e "\n"
