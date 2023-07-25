-- Note: The PG_USER and PG_DATABASE placeholders in this file
-- are replaced with actual values by the prepare_setup.sh script.
-- Then the file is placed in the /docker-entrypoint-initdb.d folder.

SET application_name="container_setup";

ALTER USER "PG_USER" CREATEROLE;
CREATE USER dmluser WITH PASSWORD 'dmluser';
CREATE USER gretl WITH PASSWORD 'gretl';

REVOKE TEMPORARY ON DATABASE "PG_DATABASE" FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

CREATE EXTENSION postgis;
-- CREATE EXTENSION postgis_topology;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION "uuid-ossp";
