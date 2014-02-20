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
  echo "Start DD 2sas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/2sas-stripe.sh ${NUM} 1
  #echo "Start CPC 2sas-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SAS/2sas-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start DD 3sas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/3sas-stripe.sh ${NUM} 1
  #echo "Start CPC 3sas-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SAS/3sas-stripe.sh ${NUM} 0
  

  sleep 60
  echo "Start 4sas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/4sas-stripe.sh ${NUM} 1
  #echo "Start CPC 4sas-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SAS/4sas-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start 3sas-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/3sas-raidz.sh ${NUM} 1
  #echo "Start CPC 3sas-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SAS/3sas-raidz.sh ${NUM} 0

  sleep 60
  echo "Start 4sas-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/4sas-raidz.sh ${NUM} 1
  #echo "Start CPC 3sas-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SAS/3sas-raidz.sh ${NUM} 0

  sleep 60
  echo "Start 5sas-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/5sas-raidz.sh ${NUM} 1
  #echo "Start CPC 5sas-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SAS/5sas-raidz.sh ${NUM} 0
  
  #sleep 60
  #echo "Start 6sas-raidz+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SAS/6sas-raidz+stripe.sh ${NUM} 1
  ##echo "Start CPC 6sas-raidz+stripe.sh with ${NUM} scans"
  ##bash ${BASE_PATH}/test_dd/SAS/6sas-raidz+stripe.sh ${NUM} 0
  #
  #sleep 60
  #echo "Start 6sas-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SAS/6sas-mirror+stripe.sh ${NUM} 1
  #echo "Start CPC 6sas-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SAS/6sas-mirror+stripe.sh ${NUM} 0
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
