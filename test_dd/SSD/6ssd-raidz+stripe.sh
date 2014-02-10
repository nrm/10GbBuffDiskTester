#!/bin/bash
#################################################################
# Тестируем NSAS диски, конкретно zfs stripe pool из 3 дисков   #
# Name_file: 3sas-stripe.sh                                     #
#  Утилитой dd                                                  #
#    $NUM сканов по 10GB                                        #
#    пишем лог top и zpool iostat                               #
#################################################################

NUM=$1
POOL_DISK=6
POOL_TYPE="raidz+stripe"
DISK_TYPE="ssd"

BASE_PATH="`pwd`/src"

#Start dd_tester.sh
/bin/bash ${BASE_PATH}/dd_tester.sh ${NUM} ${POOL_DISK} ${POOL_TYPE} ${DISK_TYPE} ${BASE_PATH}
