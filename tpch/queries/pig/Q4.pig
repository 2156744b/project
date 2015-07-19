rmf /apps/hive/warehouse/q4

Orders = LOAD '/apps/hive/warehouse/orders' USING OrcStorage('|') AS (o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority:chararray, o_clerk, o_shippriority, o_comment);

LineItem = LOAD '/apps/hive/warehouse/lineitem' USING OrcStorage('|') AS (l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, l_receiptdate, l_shipinstruct, l_shipmode, l_comment);

DateFilter = FILTER Orders BY o_orderdate >= '1994-10-01' and o_orderdate < '1995-01-01';
CommitDateFilter0 = FILTER LineItem BY l_commitdate < l_receiptdate;
CommitDateFilter = FOREACH CommitDateFilter0 generate l_orderkey;

COG1 = COGROUP DateFilter BY o_orderkey, CommitDateFilter BY l_orderkey;
Fil1 = FILTER COG1 by COUNT(CommitDateFilter) > 0;

OrdersCount = FOREACH Fil1 GENERATE FLATTEN(DateFilter);
PriorityGroup = GROUP OrdersCount BY o_orderpriority;
PriorityChecking = FOREACH PriorityGroup GENERATE group, COUNT(OrdersCount) AS order_count;

SortedPriorityChecking = ORDER PriorityChecking BY group;
STORE SortedPriorityChecking into '/apps/hive/warehouse/q4' USING OrcStorage('|');

