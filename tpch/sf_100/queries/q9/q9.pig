rmf /apps/hive/warehouse/q9

customer = LOAD '/apps/hive/warehouse/customer' USING OrcStorage() as (c_custkey,c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment);

orders = LOAD '/apps/hive/warehouse/orders' USING OrcStorage() as (o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment);

lineitem = LOAD '/apps/hive/warehouse/lineitem' USING OrcStorage() as (l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, l_receiptdate,l_shippingstruct, l_shipmode, l_comment);

supplier = LOAD '/apps/hive/warehouse/supplier' USING OrcStorage() as (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment);

nation = LOAD '/apps/hive/warehouse/nation' USING OrcStorage() as (n_nationkey, n_name, n_regionkey, n_comment);

region = LOAD '/apps/hive/warehouse/region' USING OrcStorage() as (r_regionkey, r_name, r_comment);

partsupp = LOAD '/apps/hive/warehouse/partsupp' USING OrcStorage() as (ps_partkey, ps_suppkey, ps_availqty, ps_supplycost, ps_comment);

part = LOAD '/apps/hive/warehouse/part' USING OrcStorage() as (p_partkey, p_name, p_mfgr, p_brand, p_type, p_size, p_container, p_retailprice, p_comment);

fpart = filter part by REGEX_EXTRACT(p_name,'(burlywood)', 1) != '';

j1 = join fpart by p_partkey, lineitem by l_partkey; -- 'replicated' failed again in 100GB.

j2 = join supplier by s_nationkey, nation by n_nationkey USING 'replicated';

j3 = join j2 by s_suppkey, j1 by l_suppkey;  -- 'replicated' failed in 100GB.

j4 = join partsupp by (ps_suppkey, ps_partkey), j3 by (l_suppkey, l_partkey);

j5 = join j4 by l_orderkey, orders by o_orderkey;

selo1 = foreach j5 generate n_name as nation_name, SUBSTRING(o_orderdate, 0, 4) as o_year, (l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity) as amount;

grResult = GROUP selo1 by (nation_name, o_year);

sumResult = foreach grResult generate flatten(group), SUM(selo1.amount) as sum_profit;
sortResult = order sumResult by nation_name, o_year desc;

store sortResult into '/apps/hive/warehouse/q9' USING PigStorage('|');
