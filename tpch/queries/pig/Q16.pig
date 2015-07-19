rmf /apps/hive/warehouse/q16

parts = LOAD '/apps/hive/warehouse/part' USING OrcStorage('|') AS (p_partkey, p_name, p_mfgr, p_brand, p_type, p_size, p_container, p_retailprice, p_comment);

partsupp = LOAD '/apps/hive/warehouse/partsupp' USING OrcStorage('|') AS (ps_partkey, ps_suppkey, ps_availqty, ps_supplycost:double, ps_comment);

supplier = LOAD '/apps/hive/warehouse/supplier' USING OrcStorage('|') AS (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment);

fsupplier = FILTER supplier BY (NOT s_comment MATCHES '.*Customer.*Complaints.*');
fs1 = FOREACH fsupplier GENERATE s_suppkey;

pss = JOIN partsupp BY ps_suppkey, fs1 BY s_suppkey;

fpartsupp = FOREACH pss GENERATE partsupp::ps_partkey as ps_partkey, partsupp::ps_suppkey as ps_suppkey;

fparts = FILTER parts BY 
(p_brand != 'Brand#25' AND 
 NOT (p_type MATCHES 'ECONOMY PLATED.*') AND 
 p_size MATCHES '4|15|39|19|11|45|47|48');

pparts = FOREACH fparts GENERATE p_partkey, p_brand, p_type, p_size;

p1 = JOIN pparts BY p_partkey, fpartsupp by ps_partkey;
grResult = GROUP p1 BY (p_brand, p_type, p_size);
countResult = FOREACH grResult
{
  dkeys = DISTINCT p1.ps_suppkey;
  GENERATE group.p_brand as p_brand, group.p_type as p_type, group.p_size as p_size, COUNT(dkeys) as supplier_cnt;
}
orderResult = ORDER countResult BY supplier_cnt DESC, p_brand, p_type, p_size;

store orderResult into '/apps/hive/warehouse/q16' USING OrcStorage('|');
