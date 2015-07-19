#!/bin/bash
set -e

if [ -z "$1" ]; then
	echo "No target foldername supplied"
	echo "Run $0 foldername"
	exit		
fi

source ../../../executables.conf

RESULTS="../../results/hive_tez"
mkdir -p $RESULTS/$1 

$HIVE -e "set hive.execution.engine=tez;"

for query in *.hive; do
	echo -e "\n\n************************************************"
	echo "Executing" $query
	echo -e "************************************************\n\n"
	filename=`echo $query | cut -d "_" -f 1`
	$HIVE -f $query 2>&1 | tee $RESULTS/$1/${filename}_result.txt 
done
