#!/bin/bash
NUM=$1
BASE_PATH=`pwd`
echo "Check \"\$NUM\""

#/usr/bin/cpuset -l 2 -x 269
#/usr/bin/cpuset -l 4 -x 271
#/usr/bin/cpuset -l 18 -x 282
#/usr/bin/cpuset -l 20 -x 284

if [ $NUM ]
then
  echo "Start DD 2nsas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/NSAS/2nsas-stripe.sh ${NUM} 1
  #echo "Start CPC 2nsas-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/NSAS/2nsas-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start DD 3nsas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/NSAS/3nsas-stripe.sh ${NUM} 1
  #echo "Start CPC 3nsas-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/NSAS/3nsas-stripe.sh ${NUM} 0
  

  sleep 60
  echo "Start 4nsas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/NSAS/4nsas-stripe.sh ${NUM} 1
  #echo "Start CPC 4nsas-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/NSAS/4nsas-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start 3nsas-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/NSAS/3nsas-raidz.sh ${NUM} 1
  #echo "Start CPC 3nsas-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/NSAS/3nsas-raidz.sh ${NUM} 0

  #sleep 60
  #echo "Start 5nsas-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/NSAS/5nsas-raidz.sh ${NUM} 1
  #echo "Start CPC 5nsas-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/NSAS/5nsas-raidz.sh ${NUM} 0
  
  sleep 60
  #echo "Start 6nsas-raidz+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/NSAS/6nsas-raidz+stripe.sh ${NUM} 1
  #echo "Start CPC 6nsas-raidz+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/NSAS/6nsas-raidz+stripe.sh ${NUM} 0
  
  sleep 60
  #echo "Start 6nsas-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/NSAS/6nsas-mirror+stripe.sh ${NUM} 1
  #echo "Start CPC 6nsas-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/NSAS/6nsas-mirror+stripe.sh ${NUM} 0
else
  echo "Укажите количество сканов"
  exit 1
fi

#      irq269: ix0
#      irq271: ix1
#      irq273: ix2
#      irq275: ix3
#      irq278: ix4
#      irq280: ix5
#      irq282: ix6
#      irq284: ix7
