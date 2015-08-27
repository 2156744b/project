#!/bin/bash

OUTPUT=loading_times.txt

echo "ORC" > $OUTPUT
for f in loading?.txt; do grep "^Time" $f | awk 'NR >= 17 && NR <= 24 {sum+=$3} END {print sum}'; done | ministat -A >> $OUTPUT

echo "Parquet" >> $OUTPUT
for f in loading?.txt; do grep "^Time" $f | awk 'NR >= 41 {sum+=$3} END {print sum}'; done | ministat -A >> $OUTPUT

