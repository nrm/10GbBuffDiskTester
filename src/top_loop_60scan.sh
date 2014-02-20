#!/bin/bash
TOP_LOG=$1
NUM=$2
END=$(( NUM * 22 ))
for (( i=1; i<=$END; i++ )); do top -b -HSz -n 60 >> ${TOP_LOG}; sleep 3; done &
