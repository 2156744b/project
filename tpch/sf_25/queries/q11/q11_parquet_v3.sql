-- the query
insert into table q11_important_stock_par
select ps_partkey, part_value as value
from ( 
        select ps_partkey, sum(ps_supplycost * ps_availqty) as part_value, sum(sum(ps_supplycost * ps_availqty)) over() as total_value
        from nation_par n
        join supplier_par s on s.s_nationkey = n.n_nationkey and n.n_name = 'RUSSIA'
        join partsupp_par ps on ps.ps_suppkey = s.s_suppkey
        group by ps_partkey
) sum_tmp
where part_value > total_value * 0.000004
order by value desc;

