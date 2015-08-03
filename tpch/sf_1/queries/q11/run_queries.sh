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
        $PIG -f $f 2>&1 | tee -a $result

done

#for f in *.spark; do
#	#$SPARK -f $f
#	ls $f
#done
