#!/bin/bash

OUTPUT="results/finalresults.txt"

echo "version 3" >> $OUTPUT
echo >> $OUTPUT


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
grep "completed" results/q11.pig_run* | awk '{ gsub(/\(/,"", $(NF-1)); print $(NF-1) / 1000}' | ministat -A >> $OUTPUT 

################# v2
echo "version 2" >> $OUTPUT
echo >> $OUTPUT

echo "Hive ORC" >> $OUTPUT
for f in results/q11_v2.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez ORC" >> $OUTPUT
for f in results/q11_v2.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark ORC" >> $OUTPUT
for f in results/q11_v2.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Parquet" >> $OUTPUT
for f in results/q11_parquet_v2.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez Parquet" >> $OUTPUT
for f in results/q11_parquet_v2.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark Parquet" >> $OUTPUT
for f in results/q11_parquet_v2.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT


##################### v1
echo "version 1" >> $OUTPUT
echo >> $OUTPUT


echo "Hive ORC" >> $OUTPUT
for f in results/q11_v1.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez ORC" >> $OUTPUT
for f in results/q11_v1.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark ORC" >> $OUTPUT
for f in results/q11_v1.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Parquet" >> $OUTPUT
for f in results/q11_parquet_v1.hive_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Hive Tez Parquet" >> $OUTPUT
for f in results/q11_parquet_v1.hive_tez_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT

echo "Spark Parquet" >> $OUTPUT
for f in results/q11_parquet_v1.spark_run*; do grep "^Time taken" $f | awk '{ sum+=$3} END { print sum}'; done | ministat -A >> $OUTPUT


