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
#sata1d0
#sata1d1
#sata1d2
#sata1d3
#sata1d4
#sata1d5
#sata1d6
#sata1d7
#sata1d8
#sata1d9
#sata1d10
#sata1d11
#sata1d12
#sata1d13
#sata1d14
#sata1d15

#MD2
#sata2d0
#sata2d1
#sata2d2
#sata2d3
#sata2d4
#sata2d5
#sata2d6
#sata2d7
#sata2d8
#sata2d9
#sata2d10
#sata2d11
#sata2d12
#sata2d13
#sata2d14
#sata2d15


# create zpool STRIPE 2 disk
/sbin/zpool create -f storage0 /dev/gpt/sata1d0 /dev/gpt/sata1d1
/sbin/zpool create -f storage1 /dev/gpt/sata1d2 /dev/gpt/sata1d3
/sbin/zpool create -f storage2 /dev/gpt/sata1d4 /dev/gpt/sata1d5
/sbin/zpool create -f storage3 /dev/gpt/sata1d6 /dev/gpt/sata1d7

/sbin/zpool create -f storage4 /dev/gpt/sata2d0 /dev/gpt/sata2d1
/sbin/zpool create -f storage5 /dev/gpt/sata2d2 /dev/gpt/sata2d3
/sbin/zpool create -f storage6 /dev/gpt/sata2d4 /dev/gpt/sata2d5
/sbin/zpool create -f storage7 /dev/gpt/sata2d6 /dev/gpt/sata2d7

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
