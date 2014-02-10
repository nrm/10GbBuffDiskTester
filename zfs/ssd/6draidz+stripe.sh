#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-3dstripe.sh                                    #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

# create zpool raidz+stripe 6 disk
/sbin/zpool create storage0 raidz /dev/gpt/ssd0 /dev/gpt/ssd1 /dev/gpt/ssd2 raidz /dev/gpt/ssd3 /dev/gpt/ssd4 /dev/gpt/ssd5
/sbin/zpool create storage1 raidz /dev/gpt/ssd6 /dev/gpt/ssd7 /dev/gpt/ssd8 raidz /dev/gpt/ssd9 /dev/gpt/ssd10 /dev/gpt/ssd11
/sbin/zpool create storage2 raidz /dev/gpt/ssd12 /dev/gpt/ssd13 /dev/gpt/ssd14 raidz /dev/gpt/ssd15 /dev/gpt/ssd16 /dev/gpt/ssd17
/sbin/zpool create storage3 raidz /dev/gpt/ssd18 /dev/gpt/ssd19 /dev/gpt/ssd20 raidz /dev/gpt/ssd21 /dev/gpt/ssd22 /dev/gpt/ssd23

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
