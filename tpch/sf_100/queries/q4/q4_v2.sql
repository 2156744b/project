INSERT INTO TABLE q4_order_priority 
select o_orderpriority, count(distinct l_orderkey) as order_count 
from orders o join lineitem l on o.o_orderkey = l.l_orderkey and o.o_orderdate >= '1994-10-01' and o.o_orderdate < '1995-01-01' and l.l_commitdate < l.l_receiptdate 
group by o_orderpriority 
order by o_orderpriority;



