-- the query
INSERT OVERWRITE TABLE q4_order_priority_tmp 
select 
  DISTINCT l_orderkey 
from 
  lineitem 
where 
  l_commitdate < l_receiptdate;
  
INSERT OVERWRITE TABLE q4_order_priority 
select 
	o_orderpriority, 
	count(*) as order_count 
from 
  orders o 
  join q4_order_priority_tmp t on o.o_orderkey = t.o_orderkey and o.o_orderdate >= '1994-10-01' and o.o_orderdate < '1995-01-01' 
group by 
	o_orderpriority 
order by 
	o_orderpriority;
