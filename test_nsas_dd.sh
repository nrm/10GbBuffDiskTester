#!/bin/bash
NUM=$1
echo "Check \"\$NUM\""
if [ $NUM ]
then
  echo "Start 3nsas-stripe.sh with ${NUM} scans"
  bash ./test_dd/NSAS/3nsas-stripe.sh ${NUM}
  
  sleep 60
  echo "Start 4nsas-stripe.sh with ${NUM} scans"
  bash ./test_dd/NSAS/4nsas-stripe.sh ${NUM}
  
  sleep 60
  echo "Start 5nsas-raidz.sh with ${NUM} scans"
  bash ./test_dd/NSAS/5nsas-raidz.sh ${NUM}
  
  sleep 60
  echo "Start 6nsas-raidz+stripe.sh with ${NUM} scans"
  bash ./test_dd/NSAS/6nsas-raidz+stripe.sh ${NUM}
  
  sleep 60
  echo "Start 6nsas-mirror+stripe.sh with ${NUM} scans"
  bash ./test_dd/NSAS/6nsas-mirror+stripe.sh ${NUM}
else
  echo "Укажите количество сканов"
  exit 1
fi
