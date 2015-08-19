DROP TABLE q11_important_stock;
DROP TABLE q11_important_stock_par;

DROP TABLE q11_part_tmp;
DROP TABLE q11_part_tmp_par;

DROP TABLE q11_sum_tmp;
DROP TABLE q11_sum_tmp_par;

create table q11_important_stock_par(ps_partkey INT, value DOUBLE) STORED AS parquet;
create table q11_part_tmp_par(ps_partkey int, part_value double) STORED AS parquet;
create table q11_sum_tmp_par(total_value double) STORED AS parquet;
create table q11_important_stock(ps_partkey INT, value DOUBLE) STORED AS ORC;
create table q11_part_tmp(ps_partkey int, part_value double) STORED AS ORC;
create table q11_sum_tmp(total_value double) STORED AS ORC;
