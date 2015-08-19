-- the query
insert into table q6_forecast_revenue_change_par 
select sum(l_extendedprice*l_discount) as revenue
from lineitem_par
where 
  l_shipdate >= '1993-01-01'
  and l_shipdate < '1994-01-01'
  and l_discount >= 0.03 and l_discount <= 0.05
  and l_quantity < 24;

