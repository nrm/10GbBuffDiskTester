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
  echo "Start DD 2sata-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SATA/2sata-stripe.sh ${NUM} 1
  #echo "Start CPC 2sata-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SATA/2sata-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start DD 3sata-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SATA/3sata-stripe.sh ${NUM} 1
  #echo "Start CPC 3sata-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SATA/3sata-stripe.sh ${NUM} 0
  

  sleep 60
  echo "Start 4sata-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SATA/4sata-stripe.sh ${NUM} 1
  #echo "Start CPC 4sata-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SATA/4sata-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start 3sata-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SATA/3sata-raidz.sh ${NUM} 1
  #echo "Start CPC 3sata-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SATA/3sata-raidz.sh ${NUM} 0

  sleep 60
  echo "Start 4sata-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SATA/4sata-raidz.sh ${NUM} 1
  #echo "Start CPC 3sas-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SAS/3sas-raidz.sh ${NUM} 0

  sleep 60
  echo "Start 5sata-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SATA/5sata-raidz.sh ${NUM} 1
  ##echo "Start CPC 5sata-raidz.sh with ${NUM} scans"
  ##bash ${BASE_PATH}/test/SATA/5sata-raidz.sh ${NUM} 0
  #
  #sleep 60
  ##echo "Start 6sata-raidz+stripe.sh with ${NUM} scans"
  ##bash ${BASE_PATH}/test_dd/SATA/6sata-raidz+stripe.sh ${NUM} 1
  ##echo "Start CPC 6sata-raidz+stripe.sh with ${NUM} scans"
  ##bash ${BASE_PATH}/test_dd/SATA/6sata-raidz+stripe.sh ${NUM} 0
  #
  #sleep 60
  #echo "Start 6sata-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SATA/6sata-mirror+stripe.sh ${NUM} 1
  #echo "Start CPC 6sata-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SATA/6sata-mirror+stripe.sh ${NUM} 0
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
