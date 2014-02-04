#!/bin/bash
LOG=$1
NUM=$2

SEC=$((NUM*20))

/sbin/zpool iostat storage{0..3} ${SEC} > ${LOG}
