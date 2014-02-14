#!/bin/bash
LOG=$1
NUM=$2

SEC=$((NUM*24))

/sbin/zpool iostat storage0 10 ${SEC} > ${LOG}_ch0 &
/sbin/zpool iostat storage1 10 ${SEC} > ${LOG}_ch1 &
/sbin/zpool iostat storage2 10 ${SEC} > ${LOG}_ch2 &
/sbin/zpool iostat storage3 10 ${SEC} > ${LOG}_ch3 &
/sbin/zpool iostat storage4 10 ${SEC} > ${LOG}_ch4 &
/sbin/zpool iostat storage5 10 ${SEC} > ${LOG}_ch5 &
/sbin/zpool iostat storage6 10 ${SEC} > ${LOG}_ch6 &
/sbin/zpool iostat storage7 10 ${SEC} > ${LOG}_ch7
