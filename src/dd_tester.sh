#!/bin/bash
LOG=$1
NUM=$2

RAND=/old/root/rand.data.0

for i in 0 1 2; do dd if=${RAND} of=/dev/null bs=128K; done

END=$(( 100+${NUM} ))
for i in {0..3}
do
    for (( ind=100; ind<$END; ind++ )); do dd if=${RAND} of=/ch${i}/test_dd_${ind} bs=1m >> ${LOG}_ch${i} 2>&1; sleep 10; done &
done
