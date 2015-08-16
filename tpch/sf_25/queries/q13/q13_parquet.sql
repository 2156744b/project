-- the query
insert into table q13_customer_distribution_par
select 
  c_count, count(*) as custdist
from 
  (select 
     c_custkey, count(o_orderkey) as c_count
   from 
     customer_par c left outer join orders_par o 
     on 
       c.c_custkey = o.o_custkey and not o.o_comment like '%special%deposits%'
   group by c_custkey
   ) c_orders
group by c_count
order by custdist desc, c_count desc;

