rmf /apps/hive/warehouse/q21
rmf /apps/hive/warehouse/q21_fL2_fL2

orders = LOAD '/apps/hive/warehouse/orders' USING OrcStorage() as (o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment);

lineitem = LOAD '/apps/hive/warehouse/lineitem' USING OrcStorage() as (l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, l_receiptdate,l_shippingstruct, l_shipmode, l_comment);

supplier = LOAD '/apps/hive/warehouse/supplier' USING OrcStorage() as (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment);

nation = LOAD '/apps/hive/warehouse/nation' USING OrcStorage() as (n_nationkey, n_name, n_regionkey, n_comment);

--------------------------
lineitem = foreach lineitem generate l_suppkey,l_orderkey,l_receiptdate,l_commitdate;
orders = foreach orders generate o_orderkey, o_orderstatus;
supplier = foreach supplier generate s_suppkey, s_nationkey, s_name;

gl = group lineitem by l_orderkey;

L2 = filter gl by COUNT(org.apache.pig.builtin.Distinct(lineitem.l_suppkey))>1;

fL2 = foreach L2{
        t1 = filter lineitem by l_receiptdate > l_commitdate;
        generate group, t1;
}
-- for some reason we store fL2 here otherwise the result is wrong. 
store fL2 into '/apps/hive/warehouse/q21_fL2_fL2' using PigStorage('|');

fL3 = filter fL2 by COUNT(org.apache.pig.builtin.Distinct($1.l_suppkey)) == 1;

L3 = foreach fL3 generate flatten($1);

-----------------------

fn = filter nation by n_name == 'CHINA';
fn_s = join supplier by s_nationkey, fn by n_nationkey USING 'replicated';

fn_s_L3 = join L3 by l_suppkey, fn_s by s_suppkey;

fo = filter orders by o_orderstatus == 'F';
fn_s_L3_fo = join fn_s_L3 by l_orderkey, fo by o_orderkey;

gres = group fn_s_L3_fo by s_name;
sres = foreach gres generate group as s_name, COUNT($1) as numwait; 
ores = order sres by numwait desc, s_name;
lres = limit ores 100;

store lres into '/apps/hive/warehouse/q21' using PigStorage('|');


