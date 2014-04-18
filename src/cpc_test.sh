#!/bin/bash

NUM=$1
POOL_DISK=$2
POOL_TYPE=$3
DISK_TYPE=$4
BASE_PATH=$5
IFPOOL=$6


BASE_PATH="`pwd`/src"
LOG_PATH=${BASE_PATH}/../Log/CPC/${DISK_TYPE}

CAPTURE=${BASE_PATH}/netmap/4cpu-test-pkt-1326 
CPC="python ${BASE_PATH}/cpc/main_2.py -c ${NUM} -t 40 -p 20"
TOP=${BASE_PATH}/top_loop_60scan.sh
ZPOOL=${BASE_PATH}/../zfs/${DISK_TYPE}/${POOL_DISK}d${POOL_TYPE}.sh
ZIOSTAT=${BASE_PATH}/ziostat.sh

CWD=${LOG_PATH}/`date +"%d-%m-%y"`
PKT_LOG=${CWD}/`date +"%H:%Mm"`-${NUM}scan-${POOL_TYPE}${POOL_DISK}${DISK_TYPE}-t40_p20.log
CPC_LOG=${CWD}/`date +"%H:%Mm"`-${NUM}scan-${POOL_TYPE}${POOL_DISK}${DISK_TYPE}-cpc.log
TOP_LOG=${CWD}/`date +"%H:%Mm"`-top-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-cpc-10GB.log
IOSTAT_LOG=${CWD}/`date +"%H:%Mm"`-Ziostat-${NUM}sc-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-cpc-10GB.log
SCAN_LOG=${CWD}/`date +"%H:%Mm"`-Result-${NUM}scan-${POOL_TYPE}-${POOL_DISK}-${DISK_TYPE}.log

# Test Init

#mkdir ${BASE_PATH}
#mkdir ${LOG_PATH}
mkdir -p ${CWD}

# Destroy and Create zpool
if (( IFPOOL == 1))
then
    /bin/bash ${ZPOOL}
else
    echo "reuse zpool"
fi

# Start pkt-cap
/bin/bash ${CAPTURE} ${NUM} > ${PKT_LOG} 2>&1 &

# Start write top cpu statistic to log file
/bin/bash ${TOP} ${TOP_LOG} ${NUM}

#Start Netmap
8cpu-test-pkt-8238

# Start CPC Control
/bin/sleep 10
${CPC} > ${CPC_LOG} 2>&1 &

# Start iops statistic zpool iostat
/bin/bash ${ZIOSTAT} ${IOSTAT_LOG} ${NUM}

# ENDING TEST
ls -l /ch{0..3}/ > ${SCAN_LOG}
