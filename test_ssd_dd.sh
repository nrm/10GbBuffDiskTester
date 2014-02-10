#!/bin/bash
NUM=$1
BASE_PATH=`pwd`
echo "Check \"\$NUM\""
if [ $NUM ]
then
  echo "Start 3ssd-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/3ssd-stripe.sh ${NUM}
  
  sleep 60
  echo "Start 4ssd-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/4ssd-stripe.sh ${NUM}
  
  sleep 60
  echo "Start 3ssd-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/3ssd-raidz.sh ${NUM}

  sleep 60
  echo "Start 5ssd-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/5ssd-raidz.sh ${NUM}
  
  sleep 60
  echo "Start 6ssd-raidz+stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/6ssd-raidz+stripe.sh ${NUM}
  
  sleep 60
  echo "Start 6ssd-mirror+stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/6ssd-mirror+stripe.sh ${NUM}
else
  echo "Укажите количество сканов"
  exit 1
fi
