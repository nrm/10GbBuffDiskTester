#!/bin/bash
#################################################################
# Тестируем SAS диски, конкретно zfs stripe pool из 3 дисков    #
# Name_file: 3sas-stripe.sh                                     #
#    $NUM сканов по 40 сек записи и 20 сек паузы                  #
#    пишем лог top и zpool iostat                               #
#################################################################

NUM=$1
POOL_DISK=3
POOL_TYPE="stripe"
DISK_TYPE="sas"

BASE_PATH="`pwd`/src"
#Start cpc_test.sh
/bin/bash ${BASE_PATH}/cpc_test.sh ${NUM} ${POOL_DISK} ${POOL_TYPE} ${DISK_TYPE}
