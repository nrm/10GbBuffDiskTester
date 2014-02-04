#!/bin/bash
TOP_LOG=$1
NUM=$2
END=$(( NUM * 60/3 ))
for (( i=1; i<=$END; i++ )); do top -b -Ha -n 20 >> ${TOP_LOG}; sleep 3; done &
