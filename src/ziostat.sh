#!/bin/bash
LOG=$1
NUM=$2

SEC=$((NUM*24))

for i in {0..7}
do
    /sbin/zpool iostat storage${i} 10 ${SEC} > ${LOG}_ch${i}
done
