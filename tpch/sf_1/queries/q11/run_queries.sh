#!/bin/bash

source ~/project/executables.conf

RESULTS=results
mkdir -p $RESULTS

suffix=$1

for fn in *.sql; do

	content=$(<$fn)	
	f=${fn%.*}
	
	#HIVE
	params="set hive.execution.engine=mr;"
	result=$RESULTS/${f}.hive_$suffix
	script="$params $content"
	echo "$script" > $result
	$HIVE -e "$script" | tee -a $result 	

        #HIVE-TEZ
        params="set hive.execution.engine=tez;"
        result=$RESULTS/${f}.hive_tez_$suffix
        script="$params $content"
        echo "$script" > $result
        $HIVE -e "$script" | tee -a $result

        #SPARK
        params=""
        result=$RESULTS/${f}.spark_$suffix
        script="$params $content"
        echo "$script" > $result
        $SPARK -e "$script" | tee -a $result

done

for f in *.pig; do
	result=$RESULTS/${f}_$suffix
        cat $f > $result
        $PIG -x tez -f $f 2>&1 | tee -a $result

done

