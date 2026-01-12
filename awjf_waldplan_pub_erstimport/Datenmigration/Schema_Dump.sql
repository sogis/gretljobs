@set dbSchema = mySchema

DROP SCHEMA IF EXISTS ${dbSchema};
CREATE SCHEMA ${dbSchema};

-- role _read with privileges

DROP ROLE IF EXISTS ${dbSchema}_read;
CREATE ROLE ${dbSchema}_read;

GRANT USAGE ON SCHEMA ${dbSchema} TO ${dbSchema}_read;

ALTER DEFAULT PRIVILEGES IN SCHEMA ${dbSchema} GRANT SELECT ON TABLES TO ${dbSchema}_read;

-- role _write wih privileges

DROP ROLE IF EXISTS ${dbSchema}_write;
CREATE ROLE ${dbSchema}_write;

GRANT USAGE ON SCHEMA ${dbSchema} TO ${dbSchema}_write;

ALTER DEFAULT PRIVILEGES IN SCHEMA ${dbSchema} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${dbSchema}_write;
ALTER DEFAULT PRIVILEGES IN SCHEMA ${dbSchema} GRANT USAGE ON SEQUENCES TO ${dbSchema}_write;

-- grant for dmluser

GRANT ${dbSchema}_write TO dmluser;