#!/bin/bash
#################################################################
# Тестируем NSAS диски,  zfs raidz + stripe pool из 6 дисков     #
# Name_file: 6sas-raidz+stripe.sh                               #
#    ${NUM} сканов по 40 сек записи и 20 сек паузы                  #
#    пишем лог top и zpool iostat                               #
#################################################################

NUM=$1
POOL_DISK=6
POOL_TYPE="raidz+stripe"
DISK_TYPE="nsas"

BASE_PATH="`pwd`/src"
#Start cpc_test.sh
/bin/bash ${BASE_PATH}/cpc_test.sh ${NUM} ${POOL_DISK} ${POOL_TYPE} ${DISK_TYPE}
