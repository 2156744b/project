#!/bin/bash

if [ -z "$1" ]; then
	echo "No target foldername supplied"
	echo "Run $0 foldername"
	exit		
fi

source ../../../executables.conf

RESULTS="../../results"

$HIVE -e "set hive.execution.engine=mr;"

for query in *.hive; do
	echo -e "\n\n************************************************"
	echo "Executing" $query
	echo -e "************************************************\n\n"
	filename=`echo $query | cut -d "_" -f 1`
	$HIVE -f $query 2>&1 | tee $RESULTS/$1/${filename}_result.txt 
done
