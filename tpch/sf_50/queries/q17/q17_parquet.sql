-- the query
insert into table lineitem_tmp_par
select 
  l_partkey as t_partkey, 0.2 * avg(l_quantity) as t_avg_quantity
from 
  lineitem_par
group by l_partkey;

insert into table q17_small_quantity_order_revenue_par
select
  sum(l_extendedprice) / 7.0 as avg_yearly
from
  (select l_quantity, l_extendedprice, t_avg_quantity from
   lineitem_tmp_par t join
     (select
        l_quantity, l_partkey, l_extendedprice
      from
        part_par p join lineitem_par l
        on
          p.p_partkey = l.l_partkey
          and p.p_brand = 'Brand#54'
          and p.p_container = 'SM BAG'
      ) l1 on l1.l_partkey = t.t_partkey
   ) a
where l_quantity < t_avg_quantity;
