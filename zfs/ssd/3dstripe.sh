#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 3dstripe.sh                                        #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

#ssd0
#ssd1
#ssd10
#ssd11
#ssd12
#ssd13
#ssd14
#ssd15
#ssd16
#ssd17
#ssd18
#ssd19
#ssd2
#ssd20
#ssd21
#ssd22
#ssd23
#ssd3
#ssd4
#ssd5
#ssd6
#ssd7
#ssd8
#ssd9

# create zpool STRIPE 3 disk
/sbin/zpool create storage0 /dev/gpt/ssd0 /dev/gpt/ssd1 /dev/gpt/ssd2
/sbin/zpool create storage1 /dev/gpt/ssd3 /dev/gpt/ssd4 /dev/gpt/ssd5
/sbin/zpool create storage2 /dev/gpt/ssd6 /dev/gpt/ssd7 /dev/gpt/ssd8
/sbin/zpool create storage3 /dev/gpt/ssd9 /dev/gpt/ssd10 /dev/gpt/ssd11

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
echo -e "\n"
