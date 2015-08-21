rmf /apps/hive/warehouse/q18

lineitem = LOAD '/apps/hive/warehouse/lineitem' USING OrcStorage() as (l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, l_receiptdate,l_shippingstruct, l_shipmode, l_comment);

customer = LOAD '/apps/hive/warehouse/customer' USING OrcStorage() as (c_custkey,c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment);

orders = LOAD '/apps/hive/warehouse/orders' USING OrcStorage() as (o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment);

lineitem = foreach lineitem generate l_orderkey, l_quantity;
orders = foreach orders generate o_orderkey,o_orderdate, o_totalprice, o_custkey;
COG = cogroup lineitem by l_orderkey, orders by o_orderkey;

COG = filter COG by SUM(lineitem.l_quantity) > 315;

lineitem_orders = foreach COG generate SUM(lineitem.l_quantity) as l_quantity_sum, flatten(orders); -- orders has only one tuple per bag!

lineitem_orders_customer = join customer by c_custkey, lineitem_orders by o_custkey;

lineitem_orders_customer_group = group lineitem_orders_customer by (c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice);
result = foreach lineitem_orders_customer_group generate group.c_name as c_name, group.c_custkey as c_custkey, group.o_orderkey as o_orderkey, group.o_orderdate as o_orderdate, group.o_totalprice as o_totalprice, SUM(lineitem_orders_customer.l_quantity_sum) as l_quantity_sum;

out = order result by o_totalprice desc, o_orderdate;

store out into '/apps/hive/warehouse/q18' USING PigStorage('|');
