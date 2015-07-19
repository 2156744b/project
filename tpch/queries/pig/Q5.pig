rmf /apps/hive/warehouse/q5

customer = LOAD '/apps/hive/warehouse/customer' USING OrcStorage('|') as (c_custkey:long,c_name:chararray, c_address:chararray, c_nationkey:int, c_phone:chararray, c_acctbal:double, c_mktsegment:chararray, c_comment:chararray);

orders = LOAD '/apps/hive/warehouse/orders' USING OrcStorage('|') as (o_orderkey:long, o_custkey:long, o_orderstatus:chararray, o_totalprice:double, o_orderdate:chararray, o_orderpriority:chararray, o_clerk:chararray, o_shippriority:long, o_comment:chararray);

lineitem = LOAD '/apps/hive/warehouse/lineitem' USING OrcStorage('|') as (l_orderkey:long, l_partkey:long, l_suppkey:long, l_linenumber:long, l_quantity:double, l_extendedprice:double, l_discount:double, l_tax:double, l_returnflag:chararray, l_linestatus:chararray, l_shipdate:chararray, l_commitdate:chararray, l_receiptdate:chararray,l_shippingstruct:chararray, l_shipmode:chararray, l_comment:chararray);

supplier = LOAD '/apps/hive/warehouse/supplier' USING OrcStorage('|') as (s_suppkey:long, s_name:chararray, s_address:chararray, s_nationkey:int, s_phone:chararray, s_acctbal:double, s_comment:chararray);

nation = LOAD '/apps/hive/warehouse/nation' USING OrcStorage('|') as (n_nationkey:int, n_name:chararray, n_regionkey:int, n_comment:chararray);

region = LOAD '/apps/hive/warehouse/region' USING OrcStorage('|') as (r_regionkey:int, r_name:chararray, r_comment:chararray);

fregion = filter region by r_name == 'ASIA';
forders = filter orders by o_orderdate < '1994-01-01' and o_orderdate >= '1993-01-01';

n1 = join nation by n_regionkey, fregion by r_regionkey;
seln1 = foreach n1 generate n_name, n_nationkey;

s1 = join supplier by s_nationkey, seln1 by n_nationkey;
sels1 = foreach s1 generate n_name, s_suppkey, s_nationkey;

l1 = join lineitem by l_suppkey, sels1 by s_suppkey;
sell1 = foreach l1 generate n_name, l_extendedprice, l_discount, l_orderkey, s_nationkey;

o1 = join forders by o_orderkey, sell1 by l_orderkey;
selo1 = foreach o1 generate n_name, l_extendedprice, l_discount, s_nationkey, o_custkey;

c1 = join customer by (c_custkey, c_nationkey), selo1 by (o_custkey, s_nationkey);
selc1 = foreach c1 generate n_name, l_extendedprice * (1 - l_discount) as eachvalue;

grResult = group selc1 by n_name;
sumResult = foreach grResult generate flatten(group), SUM(selc1.eachvalue) as revenue;
sortResult = order sumResult by revenue desc;

store sortResult into '/apps/hive/warehouse/q5' USING OrcStorage('|');
