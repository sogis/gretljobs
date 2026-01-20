ATTACH ${connectionStringEdit} AS editdb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE editdbSchemata AS
SELECT 
    * 
FROM 
    editdb.information_schema.schemata
;
