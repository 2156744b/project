rmf /apps/hive/warehouse/q17

lineitem = LOAD '/apps/hive/warehouse/lineitem' USING OrcStorage() as (l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, l_receiptdate,l_shippingstruct, l_shipmode, l_comment);

part = LOAD '/apps/hive/warehouse/part' USING OrcStorage() as (p_partkey, p_name, p_mfgr, p_brand, p_type, p_size, p_container, p_retailprice, p_comment);

lineitem = foreach lineitem generate l_partkey, l_quantity, l_extendedprice ;
part = FILTER part BY p_brand == 'Brand#54' AND p_container == 'SM BAG';
part = foreach part generate p_partkey;

COG1 = COGROUP part by p_partkey, lineitem by l_partkey;
COG1 = filter COG1 by COUNT(part) > 0;
COG2 = FOREACH COG1 GENERATE COUNT(part) as count_part, FLATTEN(lineitem), 0.2 * AVG(lineitem.l_quantity) as l_avg; 

COG3 = filter COG2 by l_quantity < l_avg;
COG = foreach COG3 generate (l_extendedprice * count_part) as l_sum;

G1 = group COG ALL;

result = foreach G1 generate SUM(COG.l_sum)/7.0;

STORE result into '/apps/hive/warehouse/q17' USING PigStorage('|');
