connect to sample;
create table app1 ( t timestamp );
create table app1b ( t timestamp );
create table status ( I integer );
create table app2 like syscat.columns;
create variable app2_count integer default 0;
connect reset;

