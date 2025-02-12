LOAD spatial;

ATTACH ${connectionStringPub} AS pubdb (TYPE POSTGRES, READ_ONLY);
ATTACH ${connectionStringEdit} AS editdb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE geoDoppelteSchemasPub AS
SELECT 
    regexp_replace(schema_name, '_v[0-9]+$', '') AS schema_stamm,
    COUNT(*) AS version_anzahl,
    'pub' AS datenbank
FROM 
    pubdb.information_schema.schemata
WHERE 
    schema_name ~ '^[a-zA-Z0-9_]+(_v[0-9]+)?$'
GROUP BY 
    regexp_replace(schema_name, '_v[0-9]+$', '')
HAVING 
    COUNT(*) > 1

UNION ALL

SELECT 
    regexp_replace(schema_name, '_v[0-9]+$', '') AS schema_stamm,
    COUNT(*) AS version_anzahl,
    'edit' AS datenbank
FROM 
    editdb.information_schema.schemata
WHERE 
    schema_name ~ '^[a-zA-Z0-9_]+(_v[0-9]+)?$'
GROUP BY 
    regexp_replace(schema_name, '_v[0-9]+$', '')
HAVING 
    COUNT(*) > 1
ORDER BY 
    datenbank, schema_stamm
;

-- Funktioniert ab V1.2 ohne GDAL.
COPY geoDoppelteSchemasPub TO '/tmp/qmbetrieb/geo_doppelte_schemas.xlsx' WITH (FORMAT GDAL, DRIVER 'xlsx');

