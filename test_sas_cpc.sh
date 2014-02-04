#!/bin/bash
NUM=$1
BASE_PATH="/home/bezrukov/HddTest"

echo "Check \"\$NUM\" == $NUM"
if [ $NUM ]
then

######################################## set ioctl #########################################
#   rtprio 0 ./pkt-cap3 -b 512 -C 2,6 -i ix0 -r 0 -B 100000 -n 24 -f ${POOL}0/CH0-$FNAME$m &
#   rtprio 0 ./pkt-cap3 -b 512 -C 4,6 -i ix1 -r 0 -B 100000 -n 24 -f ${POOL}1/CH1-$FNAME$m &
#   rtprio 0 ./pkt-cap3 -b 512 -C 10,15 -i ix2 -r 0 -B 100000 -n 24 -f ${POOL}2/CH2-$FNAME$m &
#   rtprio 0 ./pkt-cap3 -b 512 -C 12,15 -i ix3 -r 0 -B 100000 -n 24 -f ${POOL}3/CH3-$FNAME$m &

#   procstat -a -t | grep ix[0-7]:q
#   cpuset -l 8 -x 278
#      irq269: ix0
#      irq271: ix1
#      irq273: ix2
#      irq275: ix3
#      irq278: ix4
#      irq280: ix5
#      irq282: ix6
#      irq284: ix7

    /usr/bin/cpuset -l 2 -x 269
    /usr/bin/cpuset -l 4 -x 271
    /usr/bin/cpuset -l 8 -x 278
    /usr/bin/cpuset -l 10 -x 280


    echo "\n\t\tStart 3sas-stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/SAS/3sas-stripe.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 4sas-stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/SAS/4sas-stripe.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 5sas-raidz.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/SAS/5sas-raidz.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 6sas-raidz+stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/SAS/6sas-raidz+stripe.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 6sas-mirror+stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/SAS/6sas-mirror+stripe.sh ${NUM}
else
  echo "Укажите количество сканов"
  exit 1
fi
