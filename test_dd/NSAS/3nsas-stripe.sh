#!/bin/bash
#################################################################
# Тестируем NSAS диски, конкретно zfs stripe pool из 3 дисков   #
# Name_file: 3sas-stripe.sh                                     #
#  Утилитой dd                                                  #
#    $NUM сканов по 10GB                                        #
#    пишем лог top и zpool iostat                               #
#################################################################

NUM=$1
BASE_PATH="/home/bezrukov/HddTest/src"
LOG_PATH=${BASE_PATH}/../Log/DD

POOL_DISK=3
POOL_TYPE="stripe"
DISK_TYPE="nsas"

DD=${BASE_PATH}/dd_tester.sh
TOP=${BASE_PATH}/top_loop_60scan.sh
ZPOOL=${BASE_PATH}/../zfs/NSAS/${POOL_DISK}d${POOL_TYPE}.sh

CWD=${LOG_PATH}/`date +"%d-%m-%y"`
DD_LOG=${CWD}/`date +"%H:%Mm"`-${NUM}scan-${POOL_TYPE}${POOL_DISK}${DISK_TYPE}-dd-10GB.log
TOP_LOG=${CWD}/`date +"%H:%Mm"`-top-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-dd-10GB.log
IOSTAT_LOG=${CWD}/`date +"%H:%Mm"`-Ziostat-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-dd-10GB.log
SCAN_LOG=${CWD}/`date +"%H:%Mm"`-Result-${NUM}scan-${POOL_TYPE}-${POOL_DISK}-${DISK_TYPE}.log

# Test Init
mkdir ${BASE_PATH}
mkdir -p ${LOG_PATH}
mkdir ${CWD}

# Create zpool
/bin/bash ${ZPOOL}

# Start dd
/bin/bash ${DD} ${DD_LOG} ${NUM}

# Start write top cpu statistic to log file
/bin/bash ${TOP} ${TOP_LOG} ${NUM}

# Start iops statistic zpool iostat
SEC=$((${NUM}*(40+20)/3))
zpool iostat 3 ${SEC} > ${IOSTAT_LOG}

# ENDING TEST
ls -l /ch?/* > ${SCAN_LOG}
