LOAD spatial;

ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiTableOhneTableView AS

WITH simidata_db_schema AS
(
    SELECT
        sds.id AS schema_id,
        sds.schema_name 
    FROM 
        simidb.simi.simidata_db_schema AS sds
        LEFT JOIN simidb.simi.simidata_postgres_db AS spd 
        ON spd.id = sds.postgres_db_id
),
-- Verknüpfung Tabellen mit edit-Schemas
simidata_postgres_table AS
(
    SELECT
        sds.schema_name,
        spt.id AS table_id,
        spt.table_name 
    FROM 
        simidb.simi.simidata_postgres_table AS spt 
        LEFT JOIN simidata_db_schema AS sds 
        ON sds.schema_id = spt.db_schema_id
)
-- Gibt alle Tabellen ohne Verknüpfung aus
SELECT
    '@' AS table_view_id,
    spt.schema_name,
    spt.table_name
FROM
    simidata_postgres_table AS spt
    LEFT JOIN simidb.simi.simidata_table_view AS stv  
    ON spt.table_id = stv.postgres_table_id
WHERE 
    stv.id IS NULL
ORDER BY 
    spt.schema_name ASC
;

-- Funktioniert ab V1.2 ohne GDAL.
COPY simiTableOhneTableView TO '/tmp/qmbetrieb/simi_table_ohne_tableview.xlsx' WITH (FORMAT GDAL, DRIVER 'xlsx');

