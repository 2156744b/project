-- the query
insert into table q18_tmp_par
select 
  l_orderkey, sum(l_quantity) as t_sum_quantity
from 
  lineitem_par
group by l_orderkey;

insert into table q18_large_volume_customer_par
select 
  c_name,c_custkey,o_orderkey,o_orderdate,o_totalprice,sum(l_quantity)
from 
  customer_par c join orders_par o 
  on 
    c.c_custkey = o.o_custkey
  join q18_tmp_par t 
  on 
    o.o_orderkey = t.l_orderkey and t.t_sum_quantity > 315
  join lineitem_par l 
  on 
    o.o_orderkey = l.l_orderkey
group by c_name,c_custkey,o_orderkey,o_orderdate,o_totalprice
order by o_totalprice desc,o_orderdate
limit 100;

