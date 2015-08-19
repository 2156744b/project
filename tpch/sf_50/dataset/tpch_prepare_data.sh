source ~/project/executables.conf

$HADOOP fs -mkdir tpch/ && echo "mkdir tpch/"
$HADOOP fs -mkdir tpch/sf_50 && echo "mkdir tpch/sf_50"
$HADOOP fs -mkdir tpch/sf_50/customer && echo "mkdir customer"
$HADOOP fs -mkdir tpch/sf_50/lineitem && echo "mkdir lineitem"
$HADOOP fs -mkdir tpch/sf_50/nation && echo "mkdir nation"
$HADOOP fs -mkdir tpch/sf_50/orders && echo "mkdir orders"
$HADOOP fs -mkdir tpch/sf_50/part && echo "mkdir part"
$HADOOP fs -mkdir tpch/sf_50/partsupp && echo "mkdir partsupp"
$HADOOP fs -mkdir tpch/sf_50/region && echo "mkdir region"
$HADOOP fs -mkdir tpch/sf_50/supplier && echo "mkdir supplier"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/customer.tbl tpch/sf_50/customer/ && echo "customer loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/lineitem.tbl tpch/sf_50/lineitem/ && echo "lineitem loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/nation.tbl tpch/sf_50/nation/ && echo "nation loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/orders.tbl tpch/sf_50/orders/ && echo "orders loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/part.tbl tpch/sf_50/part/ && echo "part loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/partsupp.tbl tpch/sf_50/partsupp/ && echo "partsupp loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/region.tbl tpch/sf_50/region/ && echo "region loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/supplier.tbl tpch/sf_50/supplier/ && echo "supplier loaded"

$HIVE -f tpch_external_tables.hive
$HIVE -f tpch_dataset.hive
