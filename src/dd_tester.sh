#!/bin/bash
LOG=$1
NUM=$2

RAND=/old/root/rand.data.0

for i in 0 1 2; do dd if=${RAND} of=/dev/null bs=128K; done

END=$(( 100+${NUM} ))
for ind in {0..$END}
do
    dd if=${RAND} of=/ch0/test_dd_${ind} bs=1m >> ${LOG}_ch0 2>&1 &
    dd if=${RAND} of=/ch1/test_dd_${ind} bs=1m >> ${LOG}_ch1 2>&1 &
    dd if=${RAND} of=/ch2/test_dd_${ind} bs=1m >> ${LOG}_ch2 2>&1 &
    dd if=${RAND} of=/ch3/test_dd_${ind} bs=1m >> ${LOG}_ch3 2>&1 &
    dd if=${RAND} of=/ch4/test_dd_${ind} bs=1m >> ${LOG}_ch4 2>&1 &
    dd if=${RAND} of=/ch5/test_dd_${ind} bs=1m >> ${LOG}_ch5 2>&1 &
    dd if=${RAND} of=/ch6/test_dd_${ind} bs=1m >> ${LOG}_ch6 2>&1 &
    dd if=${RAND} of=/ch7/test_dd_${ind} bs=1m >> ${LOG}_ch7 2>&1 &

    #for (( ind=100; ind<$END; ind++ )); do dd if=${RAND} of=/ch${i}/test_dd_${ind} bs=1m >> ${LOG}_ch${i} 2>&1; sleep 10; done &

    wait;
    sleep 10;
done
