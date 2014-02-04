#!/bin/bash
#################################################################
# Удаляем сущ zpool и создаем новый                             #
# Name_file: 4Ch-6dmirror+stripe.sh                             #
#################################################################

# delete zpool
/sbin/zpool destroy storage0
/sbin/zpool destroy storage1
/sbin/zpool destroy storage2
/sbin/zpool destroy storage3

# create zpool raidz+stripe 6 disk
/sbin/zpool create storage0 mirror /dev/gpt/md2d0 /dev/gpt/md2d1 mirror /dev/gpt/md2d2 /dev/gpt/md2d3 mirror /dev/gpt/md2d4 /dev/gpt/md2d5
/sbin/zpool create storage1 mirror /dev/gpt/md2d6 /dev/gpt/md2d7 mirror /dev/gpt/md2d8 /dev/gpt/md2d9 mirror /dev/gpt/md2d10 /dev/gpt/md2d11
/sbin/zpool create storage2 mirror /dev/gpt/md2d12 /dev/gpt/md2d13 mirror /dev/gpt/md2d14 /dev/gpt/md2d15 mirror /dev/gpt/md2d16 /dev/gpt/md2d17
/sbin/zpool create storage3 mirror /dev/gpt/md2d18 /dev/gpt/md2d19 mirror /dev/gpt/md2d20 /dev/gpt/md2d21 mirror /dev/gpt/md2d22 /dev/gpt/md2d23

# create mountpoint
/sbin/zfs create -o mountpoint=/ch0 -o atime=off storage0/s0;
/sbin/zfs create -o mountpoint=/ch1 -o atime=off storage1/s0;
/sbin/zfs create -o mountpoint=/ch2 -o atime=off storage2/s0;
/sbin/zfs create -o mountpoint=/ch3 -o atime=off storage3/s0;

# check pool status after create pools
echo -e "\n\t\tcheck pool status after create pools\n"
/sbin/zpool list
