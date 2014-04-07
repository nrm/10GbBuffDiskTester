#!/bin/bash
#################################################################
# Тестируем NSAS диски, конкретно zfs stripe pool из 3 дисков   #
# Name_file: 3sas-stripe.sh                                     #
#  BRAS                                                  #
#    $NUM сканов по 10GB                                        #
#    пишем лог top и zpool iostat                               #
#################################################################

NUM=$1
IFPOOL=$2
POOL_DISK=2
POOL_TYPE="stripe"
DISK_TYPE="sas"

BASE_PATH="`pwd`/src"

#Start bras_test.sh
/bin/bash ${BASE_PATH}/bras_test.sh ${NUM} ${POOL_DISK} ${POOL_TYPE} ${DISK_TYPE} ${BASE_PATH} ${IFPOOL}
