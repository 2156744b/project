#!/bin/bash

for f in q[0-9]*; do 
	(
		cd $f
		/bin/bash ./run_queries.sh	
	) 
done

