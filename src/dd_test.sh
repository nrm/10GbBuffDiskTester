#!/bin/bash

NUM=$1
POOL_DISK=$2
POOL_TYPE=$3
DISK_TYPE=$4
BASE_PATH=$5
IFPOOL=$6


DD=${BASE_PATH}/dd_tester.sh
TOP=${BASE_PATH}/top_loop_60scan.sh
ZPOOL=${BASE_PATH}/../zfs/${DISK_TYPE}/${POOL_DISK}d${POOL_TYPE}.sh
ZIOSTAT=${BASE_PATH}/ziostat.sh
GPT_DISK==${BASE_PATH}/get_disk.py
IOSTAT=${BASE_PATH}/iostat.py

LOG_PATH=${BASE_PATH}/../Log/DD
CWD=${LOG_PATH}/`date +"%d-%m-%y"`
DD_LOG=${CWD}/`date +"%H:%Mm"`-${NUM}scan-${POOL_TYPE}${POOL_DISK}${DISK_TYPE}-dd-10GB.log
TOP_LOG=${CWD}/`date +"%H:%Mm"`-top-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-dd-10GB.log
IOSTAT_LOG=${CWD}/`date +"%H:%Mm"`-Ziostat-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-dd-10GB.log
N_IOSTAT_LOG=${CWD}/`date +"%H:%Mm"`-Niostat-${POOL_DISK}D${POOL_TYPE}${DISK_TYPE}-dd-10GB.log
SCAN_LOG=${CWD}/`date +"%H:%Mm"`-Result-${NUM}scan-${POOL_TYPE}-${POOL_DISK}-${DISK_TYPE}.log

# Test Init
#mkdir ${BASE_PATH}
#mkdir -p ${LOG_PATH}
mkdir -p ${CWD}

#compared gpt_labels and disk address
/usr/local/bin/python ${GPT_DISK} &

# Create zpool
if (( IFPOOL == 1))
then
    /bin/bash ${ZPOOL}
else
    echo "reuse zpool"
fi

#Start native iostat
/usr/local/bin/python ${IOSTAT} -l ${N_IOSTAT_LOG} -c $NUM -t 3

# Start write top cpu statistic to log file
/bin/bash ${TOP} ${TOP_LOG} ${NUM}

# Start iops statistic zpool iostat
#SEC=$((${NUM}*(40+20)/3))
#zpool iostat 3 ${SEC} > ${IOSTAT_LOG}
/bin/bash ${ZIOSTAT} ${IOSTAT_LOG} ${NUM}

# Start dd
/bin/bash ${DD} ${DD_LOG} ${NUM} &

# ENDING TEST
wait
ls -l /ch?/* > ${SCAN_LOG}
