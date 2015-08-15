#!/bin/bash

source ~/project/executables.conf

RESULTS=results
mkdir -p $RESULTS

suffix=$1

for run in `seq 1 5`; do 

for fn in *.sql; do

	content=$(<$fn)	
	f=${fn%.*}

#	$HIVE -f needed_tables.sql.exclude
	
#	echo "*****************************************"
#	echo "* Now running run$run $f on HIVE"
#	echo "*****************************************"

#	params="set hive.execution.engine=mr;"
#	result=$RESULTS/${f}.hive_${suffix}run$run
#	script="$params $content"
#	echo "$script" > $result
#	$HIVE -e "$script" 2>&1 | tee -a $result 	

	$HIVE -f needed_tables.sql.exclude

        echo "*****************************************"
        echo "* Now running run$run $f on HIVE-TEZ"
        echo "*****************************************"

        params="set hive.execution.engine=tez;"
        result=$RESULTS/${f}.hive_tez_${suffix}run$run
        script="$params $content"
        echo "$script" > $result
        $HIVE -e "$script" 2>&1 | tee -a $result

	$HIVE -f needed_tables.sql.exclude

        echo "*****************************************"
        echo "* Now running run$run $f on SPARK"
        echo "*****************************************"

        params=""
        result=$RESULTS/${f}.spark_${suffix}run$run
        script="$params $content"
        echo "$script" > $result
        sudo -u hive $SPARK --driver-memory 6g --executor-memory 6g -e "$script" 2>&1 | tee -a $result

done

for f in *.pig; do
	
        echo "*****************************************"
        echo "* Now running run$run $f on PIG"
        echo "*****************************************"

	result=$RESULTS/${f}_${suffix}run$run
        cat $f > $result
        $PIG -Dpig.additional.jars=/home/leonidas/snappy-0.4.jar -x tez -f $f 2>&1 | tee -a $result

done

done

/bin/bash ./evaluate_results.sh
