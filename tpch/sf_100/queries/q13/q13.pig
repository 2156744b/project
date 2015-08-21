rmf /apps/hive/warehouse/q13

customer = LOAD '/apps/hive/warehouse/customer' USING OrcStorage() as (c_custkey,c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment);

orders = LOAD '/apps/hive/warehouse/orders' USING OrcStorage() as (o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment);

forders = FILTER orders by (NOT o_comment MATCHES '.*special.*deposits.*');

porders = FOREACH forders GENERATE o_custkey, o_orderkey;

pcustomer = FOREACH customer GENERATE c_custkey;

COG1 = COGROUP pcustomer by c_custkey, porders by o_custkey;
COG2 = filter COG1 by COUNT(pcustomer) > 0; -- left out join, ensure left side non-empty
COG = FOREACH COG2 GENERATE group as c_custkey, COUNT(porders.o_orderkey) as c_count;

groupResult = GROUP COG BY c_count;

countResult = FOREACH groupResult GENERATE group as c_count, COUNT(COG) as custdist;

orderResult = ORDER countResult by custdist DESC, c_count DESC;

store orderResult into '/apps/hive/warehouse/q13' USING PigStorage('|');
