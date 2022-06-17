-- This is the original setup.sql file, copied from
-- https://github.com/CrunchyData/crunchy-containers/blob/201ff2f7be8ab936fdf1cd5e0df16ed7e922f7b6/bin/postgres-gis/setup.sql
-- Commands currently not needed for development purposes are commented out.
-- On the other hand, a few additional commands were added (see comments).

SET application_name="container_setup";

-- create extension postgis;
-- create extension postgis_topology;
-- create extension fuzzystrmatch;
-- create extension postgis_tiger_geocoder;
-- create extension pg_stat_statements;
-- create extension pgaudit;
-- create extension plr;

alter user postgres password 'PG_ROOT_PASSWORD';

create user "PG_PRIMARY_USER" with REPLICATION  PASSWORD 'PG_PRIMARY_PASSWORD';
create user "PG_USER" with password 'PG_PASSWORD';
-- Additional privilege:
ALTER USER "PG_USER" CREATEROLE;
-- Additional user:
CREATE USER dmluser WITH PASSWORD 'dmluser';
-- Additional user:
CREATE USER gretl WITH PASSWORD 'gretl';

-- create table primarytable (key varchar(20), value varchar(20));
-- grant all on primarytable to "PG_PRIMARY_USER";

create database "PG_DATABASE";

grant all privileges on database "PG_DATABASE" to "PG_USER";
-- Additional privilege setting:
REVOKE TEMPORARY ON DATABASE "PG_DATABASE" FROM PUBLIC;

\c "PG_DATABASE"

create extension postgis;
-- create extension postgis_topology;
create extension fuzzystrmatch;
-- create extension postgis_tiger_geocoder;
create extension pg_stat_statements;
-- create extension pgaudit;
-- create extension plr;
-- Additional extension needed for working with ili2pg:
CREATE EXTENSION "uuid-ossp";

-- Additional privilege setting:
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

\c "PG_DATABASE" "PG_USER";

create schema "PG_USER";
