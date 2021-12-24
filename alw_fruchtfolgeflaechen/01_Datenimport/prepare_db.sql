CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--Klimaeignung kann nicht importiert werden, wenn da noch was ist. 
drop schema if exists klimaeignung cascade;
