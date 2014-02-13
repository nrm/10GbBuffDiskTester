#!/bin/bash
#################################################################
# Тестируем SAS диски, конкретно zfs raidz pool из 5 дисков    #
# Name_file: 5sas-raidz.sh                                      #
#  Утилитой dd                                                  #
#    $NUM сканов по 10GB                                        #
#    пишем лог top и zpool iostat                               #
#################################################################

NUM=$1
IFPOOL=$2
POOL_DISK=5
POOL_TYPE="raidz"
DISK_TYPE="sas"

BASE_PATH="`pwd`/src"

#Start dd_test.sh
/bin/bash ${BASE_PATH}/dd_test.sh ${NUM} ${POOL_DISK} ${POOL_TYPE} ${DISK_TYPE} ${BASE_PATH} ${IFPOOL}
