#!/bin/bash

source ../../../executables.conf

for query in *.pig; do
	echo -e "\n\n************************************************"
	echo "Executing" $query
	echo -e "************************************************\n\n"
	$PIG -t PredicatePushdownOptimizer -t ColumnMapKeyPrune -f $query 2>&1 #| tee $RESULTS/$1/${filename}_result.txt 
done
