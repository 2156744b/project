source ~/project/executables.conf

$HADOOP fs -mkdir tpch/ && echo "mkdir tpch/"
$HADOOP fs -mkdir tpch/customer_sf_1 && echo "mkdir customer_sf_1"
$HADOOP fs -mkdir tpch/lineitem_sf_1 && echo "mkdir lineitem_sf_1"
$HADOOP fs -mkdir tpch/nation_sf_1 && echo "mkdir nation_sf_1"
$HADOOP fs -mkdir tpch/orders_sf_1 && echo "mkdir orders_sf_1"
$HADOOP fs -mkdir tpch/part_sf_1 && echo "mkdir part_sf_1"
$HADOOP fs -mkdir tpch/partsupp_sf_1 && echo "mkdir partsupp_sf_1"
$HADOOP fs -mkdir tpch/region_sf_1 && echo "mkdir region_sf_1"
$HADOOP fs -mkdir tpch/supplier_sf_1 && echo "mkdir supplier_sf_1"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/customer.tbl tpch/customer_sf_1/ && echo "customer loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/lineitem.tbl tpch/lineitem_sf_1/ && echo "lineitem loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/nation.tbl tpch/nation_sf_1/ && echo "nation loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/orders.tbl tpch/orders_sf_1/ && echo "orders loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/part.tbl tpch/part_sf_1/ && echo "part loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/partsupp.tbl tpch/partsupp_sf_1/ && echo "partsupp loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/region.tbl tpch/region_sf_1/ && echo "region loaded"

$HADOOP fs -copyFromLocal ~/project/tpch/dataset/supplier.tbl tpch/supplier_sf_1/ && echo "supplier loaded"

$HIVE -f tpch_external_tables.hive
$HIVE -f tpch_dataset.hive
