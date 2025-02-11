LOAD spatial;

ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiSchemaOhneTabelle AS
SELECT 
    sds.schema_name,
    spt.table_name 
FROM 
    simidb.simi.simidata_db_schema AS sds 
    LEFT JOIN simidb.simi.simidata_postgres_table AS spt 
    ON spt.db_schema_id = sds.id
WHERE 
    spt.table_name IS NULL 
;

-- Funktioniert ab V1.2 ohne GDAL.
COPY simiSchemaOhneTabelle TO 'simi_schema_ohne_tabelle.xlsx' WITH (FORMAT GDAL, DRIVER 'xlsx');

