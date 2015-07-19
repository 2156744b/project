#!/bin/bash
set -e

if [ -z "$1" ]; then
	echo "No target foldername supplied"
	echo "Run $0 foldername"
	exit		
fi

source ../../../executables.conf

RESULTS="../../results/pig"
mkdir -p $RESULTS/$1 

for query in *.pig; do
	echo -e "\n\n************************************************"
	echo "Executing" $query
	echo -e "************************************************\n\n"
	filename=`echo $query | cut -d "." -f 1`
	$PIG -t PredicatePushdownOptimizer -t ColumnMapKeyPrune -f $query 2>&1 | tee $RESULTS/$1/${filename}_result.txt 
done
