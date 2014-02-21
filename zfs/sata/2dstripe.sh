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
/sbin/zpool create -f storage0 /dev/gpt/sata1d15 /dev/gpt/sata1d14
/sbin/zpool create -f storage1 /dev/gpt/sata1d13 /dev/gpt/sata1d12
/sbin/zpool create -f storage2 /dev/gpt/sata1d11 /dev/gpt/sata1d10
/sbin/zpool create -f storage3 /dev/gpt/sata1d9 /dev/gpt/sata1d8

/sbin/zpool create -f storage4 /dev/gpt/sata2d15 /dev/gpt/sata2d14
/sbin/zpool create -f storage5 /dev/gpt/sata2d13 /dev/gpt/sata2d12
/sbin/zpool create -f storage6 /dev/gpt/sata2d11 /dev/gpt/sata2d10
/sbin/zpool create -f storage7 /dev/gpt/sata2d9 /dev/gpt/sata2d8

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
