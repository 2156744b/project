#!/bin/bash

source ~/project/executables.conf

RESULTS=results
mkdir -p $RESULTS

DATE=`date | sed 's/ //g'`

for f in *.hive; do
	result=$RESULTS/${f}_$DATE
	cat $f > $result
	$HIVE -f $f 2>&1 | tee -a $result
done

for f in *.pig; do
	result=$RESULTS/${f}_$DATE
        cat $f > $result
        $PIG -x tez -f $f 2>&1 | tee -a $result

done

for f in *.spark; do
	result=$RESULTS/${f}_$DATE
        cat $f > $result
	sudo -u hive $SPARK --driver-memory 6g --executor-memory 512m --num-executors 4 -f $f | tee -a $result
done
