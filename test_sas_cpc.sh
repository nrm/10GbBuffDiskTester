#!/bin/bash
NUM=$1
BASE_PATH=`pwd`

echo "Check \"\$NUM\" == $NUM"

if [ $NUM ]
then

    #echo "Start CPC 2sas-stripe.sh with ${NUM} scans"
    #bash ${BASE_PATH}/test/SAS/2sas-stripe.sh ${NUM} 1

    #sleep 60
    echo "\n\t\tStart 3sas-stripe.sh ${NUM} scans\n"
    bash ${BASE_PATH}/test/SAS/3sas-stripe.sh ${NUM} 1

    #sleep 60
    #echo "\n\t\tStart 4sas-stripe.sh ${NUM} scans\n"
    #bash ${BASE_PATH}/test/SAS/4sas-stripe.sh ${NUM} 1

    #sleep 60
    #echo "Start CPC 3sas-raidz.sh with ${NUM} scans"
    #bash ${BASE_PATH}/test/SAS/3sas-raidz.sh ${NUM} 1

    #sleep 60
    #echo "Start CPC 4sas-raidz.sh with ${NUM} scans"
    #bash ${BASE_PATH}/test/SAS/4sas-raidz.sh ${NUM} 1

    #sleep 60
    #echo "\n\t\tStart 5sas-raidz.sh ${NUM} scans\n"
    #bash ${BASE_PATH}/test/SAS/5sas-raidz.sh ${NUM} 1

else
  echo "Укажите количество сканов"
  exit 1
fi
