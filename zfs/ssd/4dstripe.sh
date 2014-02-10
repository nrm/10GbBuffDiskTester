#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-4dstripe.sh                                    #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3


# create zpool STRIPE 4 disk
/sbin/zpool create storage0 /dev/gpt/ssd0 /dev/gpt/ssd1 /dev/gpt/ssd2 /dev/gpt/ssd3
/sbin/zpool create storage1 /dev/gpt/ssd4 /dev/gpt/ssd5 /dev/gpt/ssd6 /dev/gpt/ssd7
/sbin/zpool create storage2 /dev/gpt/ssd8 /dev/gpt/ssd9 /dev/gpt/ssd10 /dev/gpt/ssd11
/sbin/zpool create storage3 /dev/gpt/ssd12 /dev/gpt/ssd13 /dev/gpt/ssd14 /dev/gpt/ssd15

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
