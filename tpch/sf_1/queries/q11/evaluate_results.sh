#!/bin/bash

OUTPUT="results/finalresults.txt"

echo "Hive ORC" >> $OUTPUT 
for f in results/q11_v3.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez ORC" >> $OUTPUT
for f in results/q11_v3.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark ORC" >> $OUTPUT
for f in results/q11_v3.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Parquet" >> $OUTPUT
for f in results/q11_parquet_v3.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez Parquet" >> $OUTPUT
for f in results/q11_parquet_v3.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark Parquet" >> $OUTPUT
for f in results/q11_parquet_v3.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Pig ORC" >> $OUTPUT
grep "completed" results/q11.pig_run* | awk '{ gsub(/\(/,"", $16); print $16 / 1000}' | ministat -A >> $OUTPUT 
