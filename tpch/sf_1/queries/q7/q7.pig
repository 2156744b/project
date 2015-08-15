rmf /apps/hive/warehouse/q7

supplier = LOAD '/apps/hive/warehouse/supplier' USING OrcStorage() as (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment);

lineitem0 = LOAD '/apps/hive/warehouse/lineitem' USING OrcStorage() as (l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, l_receiptdate,l_shippingstruct, l_shipmode, l_comment);

orders = LOAD '/apps/hive/warehouse/orders' USING OrcStorage() as (o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment);

customer = LOAD '/apps/hive/warehouse/customer' USING OrcStorage() as (c_custkey,c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment);

nation10 = LOAD '/apps/hive/warehouse/nation' USING OrcStorage() as (n_nationkey, n_name1, n_regionkey, n_comment);

nation20 = LOAD '/apps/hive/warehouse/nation' USING OrcStorage() as (n_nationkey, n_name2, n_regionkey, n_comment);

nation1 = filter nation10 by n_name1=='INDIA' or n_name1=='ETHIOPIA';
nation2 = filter nation20 by n_name2=='ETHIOPIA' or n_name2=='INDIA';

lineitem = filter lineitem0 by l_shipdate >= '1995-01-01' and l_shipdate <= '1996-12-31';

supplier_nation1 = join supplier by s_nationkey, nation1 by n_nationkey USING 'replicated';

liteitem_supplier_nation1 = join supplier_nation1 by s_suppkey, lineitem by l_suppkey; -- big relaion on right.

customer_nation2 = join customer by c_nationkey, nation2 by n_nationkey USING 'replicated';

orders_customer_nation2 = join customer_nation2 by c_custkey, orders by o_custkey; -- big relaion on right.

final_join = join orders_customer_nation2 by o_orderkey, liteitem_supplier_nation1 by l_orderkey; -- big relaion on right.

filtered_final_join = filter final_join by 
(n_name1=='INDIA' and n_name2=='ETHIOPIA') or 
(n_name1=='ETHIOPIA' and n_name2=='INDIA');

shipping = foreach filtered_final_join GENERATE 
	n_name1 as supp_nation, 
	n_name2 as cust_nation, 
	SUBSTRING(l_shipdate, 0, 4) as l_year, l_extendedprice * (1 - l_discount) as volume;

grouped_shipping = group shipping by (supp_nation, cust_nation, l_year);
aggregated_shipping = foreach grouped_shipping GENERATE FLATTEN(group), SUM($1.volume) as revenue;

ordered_shipping = order aggregated_shipping by group::supp_nation, group::cust_nation, group::l_year;
store ordered_shipping into '/apps/hive/warehouse/q7' USING PigStorage('|');
