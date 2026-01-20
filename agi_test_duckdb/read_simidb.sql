ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simidbSchemata AS
SELECT 
    * 
FROM 
    simidb.information_schema.schemata
;
