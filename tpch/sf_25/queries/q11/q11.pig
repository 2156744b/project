rmf /apps/hive/warehouse/q11

partsupp = LOAD '/apps/hive/warehouse/partsupp' USING OrcStorage() as (ps_partkey, ps_suppkey, ps_availqty, ps_supplycost, ps_comment);
supplier = LOAD '/apps/hive/warehouse/supplier' USING OrcStorage() as (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment);
nation = LOAD '/apps/hive/warehouse/nation' USING OrcStorage() as (n_nationkey, n_name, n_regionkey, n_comment);

fnation = filter nation by n_name == 'RUSSIA'; 

-- Moved small set second
--j1 = join fnation by n_nationkey, supplier by s_nationkey;  
j1 = join supplier by s_nationkey, fnation by n_nationkey;

selj1 = foreach j1 generate s_suppkey;

j2 = join partsupp by ps_suppkey, selj1 by s_suppkey;

selj2 = foreach j2 generate ps_partkey, ((double)ps_supplycost *  (double)ps_availqty) as val:double;


outerGrResult = group selj2 by ps_partkey;

outerSumResult = foreach outerGrResult generate group, SUM($1.val) as outSum:double;

grResult = group outerSumResult all;

sumResult = foreach grResult generate SUM($1.outSum) * 0.000004 as totalSum:double;

outerHaving = filter outerSumResult by outSum > sumResult.totalSum;

ord = order outerHaving by outSum desc;
store ord into '/apps/hive/warehouse/q11' USING PigStorage('|');
