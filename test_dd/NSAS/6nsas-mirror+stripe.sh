#!/bin/bash
##################################################################
# Тестируем nsas диски,  zfs mirror + stripe pool из 6 дисков    #
# Name_file: 6nsas-mirror+stripe.sh                              #
#  Утилитой dd                                                   #
#    $NUM сканов по 10GB                                         #
#    пишем лог top и zpool iostat                                #
##################################################################

NUM=$1
IFPOOL=$2
POOL_DISK=6
POOL_TYPE="mirror+stripe"
DISK_TYPE="nsas"

BASE_PATH="`pwd`/src"

#Start dd_test.sh
/bin/bash ${BASE_PATH}/dd_test.sh ${NUM} ${POOL_DISK} ${POOL_TYPE} ${DISK_TYPE} ${BASE_PATH} ${IFPOOL}
