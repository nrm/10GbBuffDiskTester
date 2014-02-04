#!/bin/bash
NUM=$1
BASE_PATH=`pwd`
echo "Check \"\$NUM\""
if [ $NUM ]
then
  echo "Start 3sas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/3sas-stripe.sh ${NUM}
  
  sleep 60
  echo "Start 4sas-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/4sas-stripe.sh ${NUM}
  
  sleep 60
  echo "Start 5sas-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/5sas-raidz.sh ${NUM}
  
  sleep 60
  echo "Start 6sas-raidz+stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/6sas-raidz+stripe.sh ${NUM}
  
  sleep 60
  echo "Start 6sas-mirror+stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SAS/6sas-mirror+stripe.sh ${NUM}
else
  echo "Укажите количество сканов"
  exit 1
fi
