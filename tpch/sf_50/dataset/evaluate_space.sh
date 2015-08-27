#!/bin/bash

OUTPUT=loading_space.txt

echo "HDFS" > $OUTPUT
hadoop fs -du -s /user/leonidas/tpch/sf_50 | awk '{ print $1/1048576}' >> $OUTPUT

echo "ORC" >> $OUTPUT
for f in loading?.txt; do grep "stats" $f | awk 'NR<=8 {gsub("totalSize=","", $6);gsub(",","",$6)}  {sum+=$6} END {print sum/1048576}'; done | ministat -A >> $OUTPUT

echo "Parquet" >> $OUTPUT
for f in loading?.txt; do grep "stats" $f | awk 'NR>8 {gsub("totalSize=","", $6);gsub(",","",$6)}  {sum+=$6} END {print sum/1048576}'; done | ministat -A >> $OUTPUT
