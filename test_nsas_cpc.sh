#!/bin/bash
NUM=$1
BASE_PATH="/home/bezrukov/HddTest"

echo "Check \"\$NUM\""
if [ $NUM ]
then
########################### IPABUF2 set ioctl #########################################
#    rtprio 0 ./pkt-cap-8238 -b 512 -C 0,4 -i ix0 -r 0 -B 20000 -n 6 -f ${POOL}0/CH0-$FNAME$m &
#    rtprio 0 ./pkt-cap-8238 -b 512 -C 0,4 -i ix1 -r 0 -B 20000 -n 6 -f ${POOL}1/CH1-$FNAME$m &
#    rtprio 0 ./pkt-cap-8238 -b 512 -C 8,12 -i ix4 -r 0 -B 20000 -n 6 -f ${POOL}2/CH4-$FNAME$m &
#    rtprio 0 ./pkt-cap-8238 -b 512 -C 8,12 -i ix5 -r 0 -B 20000 -n 6 -f ${POOL}3/CH5-$FNAME$m &

#   procstat -a -t | grep ix[0-7]:q
### irq269: ix0
### irq271: ix1
### irq273: ix2
### irq275: ix3
### irq278: ix4
### irq280: ix5
### irq282: ix6
### irq284: ix7

    cpuset -l 2 -x 269  # ix0
    cpuset -l 4 -x 271  # ix1
    cpuset -l 10 -x 324 # ix4
    cpuset -l 12 -x 333 # ix5

    echo "\n\t\tStart 3sas-stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/NSAS/3nsas-stripe.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 4sas-stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/NSAS/4nsas-stripe.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 5sas-raidz.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/NSAS/5nsas-raidz.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 6sas-raidz+stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/NSAS/6nsas-raidz+stripe.sh ${NUM}

    sleep 60
    echo "\n\t\tStart 6sas-mirror+stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/NSAS/6nsas-mirror+stripe.sh ${NUM}
else
  echo "Укажите количество сканов"
  exit 1
fi
