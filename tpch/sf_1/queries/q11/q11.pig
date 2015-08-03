rmf /apps/hive/warehouse/q11

partsupp = LOAD '/apps/hive/warehouse/partsupp' USING OrcStorage('|') as (ps_partkey:long, ps_suppkey:long, ps_availqty:long, ps_supplycost:double, ps_comment:chararray);
supplier = LOAD '/apps/hive/warehouse/supplier' USING OrcStorage('|') as (s_suppkey:long, s_name:chararray, s_address:chararray, s_nationkey:long, s_phone:chararray, s_acctbal:double, s_comment:chararray);
nation = LOAD '/apps/hive/warehouse/nation' USING OrcStorage('|') as (n_nationkey:int, n_name:chararray, n_regionkey:int, n_comment:chararray);

fnation = filter nation by n_name == 'RUSSIA'; 

-- Moved small set second
--j1 = join fnation by n_nationkey, supplier by s_nationkey;  
j1 = join supplier by s_nationkey, fnation by n_nationkey;

selj1 = foreach j1 generate s_suppkey;

j2 = join partsupp by ps_suppkey, selj1 by s_suppkey;

selj2 = foreach j2 generate ps_partkey, (ps_supplycost *  ps_availqty) as val;

grResult = group selj2 all;

sumResult = foreach grResult generate SUM($1.val) as totalSum;

----------------------------------------------------------------------------------(above inside, below outside)

outerGrResult = group selj2 by ps_partkey;

outerSumResult = foreach outerGrResult generate group, SUM($1.val) as outSum;

outerHaving = filter outerSumResult by outSum > sumResult.totalSum * 0.0001;

ord = order outerHaving by outSum desc;
store ord into '/apps/hive/warehouse/q11' USING OrcStorage('|');
