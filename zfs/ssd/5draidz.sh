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

#MD1
#ssd1d0
#ssd1d1
#ssd1d2
#ssd1d3
#ssd1d4
#ssd1d5
#ssd1d6
#ssd1d7
#ssd1d8
#ssd1d9
#ssd1d10
#ssd1d11
#
#MD2
#ssd2d0
#ssd2d1
#ssd2d2
#ssd2d3
#ssd2d4
#ssd2d5
#ssd2d6
#ssd2d7
#ssd2d8
#ssd2d9
#ssd2d10
#ssd2d11

# create zpool STRIPE 3 disk
/sbin/zpool create -f storage0 raidz /dev/gpt/ssd1d11 /dev/gpt/ssd1d10 /dev/gpt/ssd1d9 /dev/gpt/ssd1d8 /dev/gpt/ssd1d7
/sbin/zpool create -f storage1 raidz /dev/gpt/ssd1d3 /dev/gpt/ssd1d6 /dev/gpt/ssd1d5 /dev/gpt/ssd1d4 /dev/gpt/ssd1d2
/sbin/zpool create -f storage2 raidz /dev/gpt/disk5 /dev/gpt/disk14 /dev/gpt/disk13 /dev/gpt/disk12 /dev/gpt/disk11
/sbin/zpool create -f storage3 raidz /dev/gpt/disk23 /dev/gpt/disk22 /dev/gpt/disk21 /dev/gpt/disk20 /dev/gpt/disk4

/sbin/zpool create -f storage4 raidz /dev/gpt/ssd2d11 /dev/gpt/ssd2d10 /dev/gpt/ssd2d9 /dev/gpt/ssd2d8 /dev/gpt/ssd2d7
/sbin/zpool create -f storage5 raidz /dev/gpt/ssd2d5 /dev/gpt/ssd2d3 /dev/gpt/ssd2d6 /dev/gpt/ssd2d4 /dev/gpt/ssd2d2
/sbin/zpool create -f storage6 raidz /dev/gpt/disk10 /dev/gpt/disk9 /dev/gpt/disk8 /dev/gpt/disk7 /dev/gpt/disk6
/sbin/zpool create -f storage7 raidz /dev/gpt/disk19 /dev/gpt/disk18 /dev/gpt/disk17 /dev/gpt/disk16 /dev/gpt/disk15

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
