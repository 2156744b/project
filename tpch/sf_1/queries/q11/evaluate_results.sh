#!/bin/bash

OUTPUT="results/finalresults.txt"

echo "Hive ORC" >> $OUTPUT 
grep "^Time taken" results/q11_v3.hive_run* | awk '{ print $3 }' | ministat -A >> $OUTPUT

echo "Hive Tez ORC" >> $OUTPUT
grep "^Time taken" results/q11_v3.hive_tez_run* | awk '{ print $3 }' | ministat -A >> $OUTPUT

echo "Spark ORC" >> $OUTPUT
grep "^Time taken" results/q11_v3.spark_run* | awk '{ print $3 }' | ministat -A >> $OUTPUT

echo "Hive Parquet" >> $OUTPUT
grep "^Time taken" results/q11_parquet_v3.hive_run* | awk '{ print $3 }' | ministat -A >> $OUTPUT

echo "Hive Tez Parquet" >> $OUTPUT
grep "^Time taken" results/q11_parquet_v3.hive_tez_run* | awk '{ print $3 }' | ministat -A >> $OUTPUT

echo "Spark Parquet" >> $OUTPUT
grep "^Time taken" results/q11_parquet_v3.spark_run* | awk '{ print $3 }' | ministat -A >> $OUTPUT

echo "Pig ORC" >> $OUTPUT
grep "completed" results/q11.pig_run* | awk '{ gsub(/\(/,"", $16); print $16 / 1000}' | ministat -A >> $OUTPUT 

