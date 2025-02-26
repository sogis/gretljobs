ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiSchemaOhneTabelle AS
SELECT 
    sds.schema_name,
    db.identifier
FROM 
    simidb.simi.simidata_db_schema AS sds 
    LEFT JOIN simidb.simi.simidata_postgres_table AS spt 
    ON spt.db_schema_id = sds.id
    LEFT JOIN simidb.simi.simidata_postgres_db AS db 
    ON db.id = sds.postgres_db_id 
WHERE 
    spt.table_name IS NULL 
;

COPY simiSchemaOhneTabelle TO '/tmp/qmbetrieb/simi_schema_ohne_tabelle.csv' (HEADER, DELIMITER ';');


