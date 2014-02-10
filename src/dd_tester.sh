#!/bin/bash
LOG=$1
NUM=$2

RAND=/old/root/rand.data.0

for i in 0 1 2; do dd if=${RAND} of=/dev/null bs=128K; done

END=$(( 100+${NUM} ))
for (( ind=100; ind<$END; ind++ )); do dd if=${RAND} of=/ch0/test_dd_${ind} bs=1G count=10 >> ${LOG}_ch0 2>&1; sleep 10; done &
for (( ind=100; ind<$END; ind++ )); do dd if=${RAND} of=/ch1/test_dd_${ind} bs=1G count=10 >> ${LOG}_ch1 2>&1; sleep 10; done &
for (( ind=100; ind<$END; ind++ )); do dd if=${RAND} of=/ch2/test_dd_${ind} bs=1G count=10 >> ${LOG}_ch2 2>&1; sleep 10; done &
for (( ind=100; ind<$END; ind++ )); do dd if=${RAND} of=/ch3/test_dd_${ind} bs=1G count=10 >> ${LOG}_ch3 2>&1; sleep 10; done &
