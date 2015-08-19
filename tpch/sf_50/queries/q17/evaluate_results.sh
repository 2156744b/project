#!/bin/bash

OUTPUT="results/finalresults.txt"

echo "Hive ORC" >> $OUTPUT 
for f in results/q17.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez ORC" >> $OUTPUT
for f in results/q17.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark ORC" >> $OUTPUT
for f in results/q17.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Parquet" >> $OUTPUT
for f in results/q17_parquet.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez Parquet" >> $OUTPUT
for f in results/q17_parquet.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark Parquet" >> $OUTPUT
for f in results/q17_parquet.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Pig ORC" >> $OUTPUT
grep "completed" results/q17.pig_run* | awk '{ gsub(/\(/,"", $(NF-1)); print $(NF-1) / 1000}' | ministat -A >> $OUTPUT 

