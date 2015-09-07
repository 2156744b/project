-- the query
insert overwrite table q11_part_tmp_par
select
  ps_partkey,
  sum(ps_supplycost * ps_availqty) as part_value
from
  nation_par n join supplier_par s on s.s_nationkey = n.n_nationkey and n.n_name = 'RUSSIA'
  join partsupp_par ps on ps.ps_suppkey = s.s_suppkey
group by
    ps_partkey;

insert overwrite table q11_sum_tmp_par
select
  sum(part_value) as total_value
from
  q11_part_tmp_par;

insert overwrite table q11_important_stock_par
select
  ps_partkey, part_value as value
from
  (
    select ps_partkey, part_value, total_value
    from q11_part_tmp_par join q11_sum_tmp_par
  ) a
where part_value > total_value * 0.000001
order by value desc;
