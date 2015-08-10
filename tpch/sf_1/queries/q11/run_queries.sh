#!/bin/bash

source ~/project/executables.conf

RESULTS=results
mkdir -p $RESULTS

suffix=$1

for f in *.hive; do
	result=$RESULTS/${f}_$suffix
	cat $f > $result
	$HIVE -f $f 2>&1 | tee -a $result
done

for f in *.pig; do
	result=$RESULTS/${f}_$suffix
        cat $f > $result
        $PIG -x tez -f $f 2>&1 | tee -a $result

done

for f in *.spark; do
	result=$RESULTS/${f}_$suffix
        cat $f > $result
	$SPARK -f $f 2>&1 | tee -a $result
done
