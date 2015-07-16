HADOOP=/usr/bin/hadoop
HIVE=/usr/bin/hive

$HADOOP fs -rm -r tpch

$HADOOP fs -mkdir tpch/ && echo "mkdir tpch/"
$HADOOP fs -mkdir tpch/customer && echo "mkdir customer"
$HADOOP fs -mkdir tpch/lineitem && echo "mkdir lineitem"
$HADOOP fs -mkdir tpch/nation && echo "mkdir nation"
$HADOOP fs -mkdir tpch/orders && echo "mkdir orders"
$HADOOP fs -mkdir tpch/part && echo "mkdir part"
$HADOOP fs -mkdir tpch/partsupp && echo "mkdir partsupp"
$HADOOP fs -mkdir tpch/region && echo "mkdir region"
$HADOOP fs -mkdir tpch/supplier && echo "mkdir supplier"

#$HADOOP fs -rm tpch/customer/customer.tbl
$HADOOP fs -copyFromLocal customer.tbl tpch/customer/ && echo "customer loaded"

#$HADOOP fs -rm tpch/lineitem/lineitem.tbl
$HADOOP fs -copyFromLocal lineitem.tbl tpch/lineitem/ && echo "lineitem loaded"

#$HADOOP fs -rm tpch/nation/nation.tbl
$HADOOP fs -copyFromLocal nation.tbl tpch/nation/ && echo "nation loaded"

#$HADOOP fs -rm tpch/orders/orders.tbl
$HADOOP fs -copyFromLocal orders.tbl tpch/orders/ && echo "orders loaded"

#$HADOOP fs -rm tpch/part/part.tbl
$HADOOP fs -copyFromLocal part.tbl tpch/part/ && echo "part loaded"

#$HADOOP fs -rm tpch/partsupp/partsupp.tbl
$HADOOP fs -copyFromLocal partsupp.tbl tpch/partsupp/ && echo "partsupp loaded"

#$HADOOP fs -rm tpch/region/region.tbl
$HADOOP fs -copyFromLocal region.tbl tpch/region/ && echo "region loaded"

#$HADOOP fs -rm tpch/supplier/supplier.tbl
$HADOOP fs -copyFromLocal supplier.tbl tpch/supplier/ && echo "supplier loaded"

$HIVE -f tpch_dataset.hive
