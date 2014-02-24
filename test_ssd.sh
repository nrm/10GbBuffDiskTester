#!/bin/bash
NUM=$1
BASE_PATH=`pwd`
echo "Check \"\$NUM\""

/usr/bin/cpuset -l 2 -x 269
/usr/bin/cpuset -l 4 -x 271
/usr/bin/cpuset -l 18 -x 282
/usr/bin/cpuset -l 20 -x 284

if [ $NUM ]
then
  echo "Start DD 2ssd-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/2ssd-stripe.sh ${NUM} 1
  #echo "Start CPC 2ssd-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SSD/2ssd-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start DD 3ssd-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/3ssd-stripe.sh ${NUM} 1
  #echo "Start CPC 3ssd-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SSD/3ssd-stripe.sh ${NUM} 0
  

  sleep 60
  echo "Start 4ssd-stripe.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/4ssd-stripe.sh ${NUM} 1
  #echo "Start CPC 4ssd-stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SSD/4ssd-stripe.sh ${NUM} 0
  
  sleep 60
  echo "Start 3ssd-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/3ssd-raidz.sh ${NUM} 1
  #echo "Start CPC 3ssd-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SSD/3ssd-raidz.sh ${NUM} 0

  sleep 60
  echo "Start 4ssd-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/4ssd-raidz.sh ${NUM} 1

  sleep 60
  echo "Start 5ssd-raidz.sh with ${NUM} scans"
  bash ${BASE_PATH}/test_dd/SSD/5ssd-raidz.sh ${NUM} 1
  #echo "Start CPC 5ssd-raidz.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test/SSD/5ssd-raidz.sh ${NUM} 0
  #
  #sleep 60
  #echo "Start 6ssd-raidz+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SSD/6ssd-raidz+stripe.sh ${NUM} 1
  #echo "Start CPC 6ssd-raidz+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SSD/6ssd-raidz+stripe.sh ${NUM} 0
  #
  #sleep 60
  #echo "Start 6ssd-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SSD/6ssd-mirror+stripe.sh ${NUM} 1
  #echo "Start CPC 6ssd-mirror+stripe.sh with ${NUM} scans"
  #bash ${BASE_PATH}/test_dd/SSD/6ssd-mirror+stripe.sh ${NUM} 0
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

#    /usr/bin/cpuset -l 2 -x 269
#    /usr/bin/cpuset -l 4 -x 271
#    /usr/bin/cpuset -l 18 -x 282
#    /usr/bin/cpuset -l 20 -x 284

