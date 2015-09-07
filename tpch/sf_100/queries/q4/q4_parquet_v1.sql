-- the query
INSERT OVERWRITE TABLE q4_order_priority_tmp_par 
select 
  DISTINCT l_orderkey 
from 
  lineitem_par
where 
  l_commitdate < l_receiptdate;
  
INSERT OVERWRITE TABLE q4_order_priority_par 
select 
	o_orderpriority, 
	count(*) as order_count 
from 
  orders_par o 
  join q4_order_priority_tmp_par t on o.o_orderkey = t.o_orderkey and o.o_orderdate >= '1994-10-01' and o.o_orderdate < '1995-01-01' 
group by 
	o_orderpriority 
order by 
	o_orderpriority;
