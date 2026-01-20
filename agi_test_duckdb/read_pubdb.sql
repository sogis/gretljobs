ATTACH ${connectionStringPub} AS pubdb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE pubdbSchemata AS
SELECT 
    * 
FROM 
    pubdb.information_schema.schemata
;
