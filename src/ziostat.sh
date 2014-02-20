#!/bin/bash
LOG=$1
NUM=$2

ACCUMULATION=3
TIME=$((NUM*24))

/sbin/zpool iostat storage0 $ACCUMULATION ${TIME} > ${LOG}_ch0 &
/sbin/zpool iostat storage1 $ACCUMULATION ${TIME} > ${LOG}_ch1 &
/sbin/zpool iostat storage2 $ACCUMULATION ${TIME} > ${LOG}_ch2 &
/sbin/zpool iostat storage3 $ACCUMULATION ${TIME} > ${LOG}_ch3 &
/sbin/zpool iostat storage4 $ACCUMULATION ${TIME} > ${LOG}_ch4 &
/sbin/zpool iostat storage5 $ACCUMULATION ${TIME} > ${LOG}_ch5 &
/sbin/zpool iostat storage6 $ACCUMULATION ${TIME} > ${LOG}_ch6 &
/sbin/zpool iostat storage7 $ACCUMULATION ${TIME} > ${LOG}_ch7 &
