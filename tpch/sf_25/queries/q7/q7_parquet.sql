-- the query
insert into table q7_volume_shipping_par 
select
        supp_nation,
        cust_nation,
        l_year,
        sum(volume) as revenue
from
        (
                select
                        n1.n_name as supp_nation,
                        n2.n_name as cust_nation,
                        year(l_shipdate) as l_year,
                        l_extendedprice * (1 - l_discount) as volume
                from
                        supplier_par,
                        lineitem_par,
                        orders_par,
                        customer_par,
                        nation_par n1,
                        nation_par n2
                where
                        s_suppkey = l_suppkey
                        and o_orderkey = l_orderkey
                        and c_custkey = o_custkey
                        and s_nationkey = n1.n_nationkey
                        and c_nationkey = n2.n_nationkey
                        and (
                                (n1.n_name = 'INDIA' and n2.n_name = 'ETHIOPIA')
                                or (n1.n_name = 'ETHIOPIA' and n2.n_name = 'INDIA')
                        )
                        and l_shipdate >= '1995-01-01' and l_shipdate <= '1996-12-31'
        ) as shipping
group by
        supp_nation,
        cust_nation,
        l_year
order by
        supp_nation,
        cust_nation,
        l_year;
