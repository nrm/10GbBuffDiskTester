#!/bin/bash
#################################################################
# Тестируем NSAS диски, конкретно zfs stripe pool из 4 дисков   #
# Name_file: 4sas-stripe.sh                                     #
#    ${NUM} сканов по 40 сек записи и 20 сек паузы              #
#    пишем лог top и zpool iostat                               #
#################################################################

NUM=$1
POOL_DISK=4
POOL_TYPE="stripe"
DISK_TYPE="nsas"

BASE_PATH="`pwd`/src"
#Start cpc_test.sh
/bin/bash ${BASE_PATH}/cpc_test.sh ${NUM} ${POOL_DISK} ${POOL_TYPE} ${DISK_TYPE}

#BASE_PATH="/home/bezrukov/HddTest/src"
#LOG_PATH=${BASE_PATH}/../Log/CPC/${DISK_TYPE}
#
#CAPTURE=${BASE_PATH}/netmap/44test-pkt-cap
#CPC="python ${BASE_PATH}/cpc/main_2.py -c ${NUM} -t 40 -p 20"
#TOP=${BASE_PATH}/top_loop_60scan.sh
#ZPOOL=${BASE_PATH}/../zfs/${DISK_TYPE}/${POOL_DISK}d${POOL_TYPE}.sh
#ZIOSTAT=${BASE_PATH}/ziostat.sh
#
#CWD=${LOG_PATH}/`date +"%d-%m-%y"`
#PKT_LOG=${CWD}/`date +"%H:%Mm"`-${NUM}scan-${POOL_TYPE}${POOL_DISK}${DISK_TYPE}-t40_p20.log
#CPC_LOG=${CWD}/`date +"%H:%Mm"`-${NUM}scan-${POOL_TYPE}${POOL_DISK}${DISK_TYPE}-cpc.log
#TOP_LOG=${CWD}/`date +"%H:%Mm"`-top-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-dd-10GB.log
#IOSTAT_LOG=${CWD}/`date +"%H:%Mm"`-Ziostat-${NUM}sc-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-cpc-10GB.log
#SCAN_LOG=${CWD}/`date +"%H:%Mm"`-Result-${NUM}scan-${POOL_TYPE}-${POOL_DISK}-${DISK_TYPE}.log
#
## Test Init
#
#mkdir ${BASE_PATH}
##mkdir ${LOG_PATH}
#mkdir -p ${CWD}
#
## Destroy and Create zpool
#/bin/bash ${ZPOOL}
#
##Start cpc_test.sh
#/bin/bash ${BASE_PATH}/cpc_test.sh ${NUM} ${CAPTURE} ${PKT_LOG} ${CPC} ${CPC_LOG} ${ZIOSTAT} ${IOSTAT_LOG} ${SCAN_LOG}





## Start pkt-cap
#/bin/bash ${CAPTURE} ${NUM} > ${PKT_LOG} 2>&1 &
#
## Start CPC Control
#/bin/sleep 10
#${CPC} > ${CPC_LOG} 2>&1 &
#
## Start write top cpu statistic to log file
#/bin/bash ${TOP} ${TOP_LOG} ${NUM}
#
## Start iops statistic zpool iostat
#SEC=$((${NUM}*(40+20)/3))
#zpool iostat 3 ${SEC} > ${IOSTAT_LOG}
#
## ENDING TEST
#ls -l /ch?/* > ${SCAN_LOG}
