#!/bin/bash
set -e

source ../../../executables.conf

for query in *.hive; do
	echo -e "\n\n************************************************"
	echo "Executing" $query
	echo -e "************************************************\n\n"
	filename=`echo $query | cut -d "_" -f 1`
	$HIVE -f $query #2>&1 | tee $RESULTS/$1/${filename}_result.txt 
done
