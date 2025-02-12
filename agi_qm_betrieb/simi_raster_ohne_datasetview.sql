LOAD spatial;

ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiRasterOhneDatasetView AS
SELECT 
    srd."path" AS raster_path,
    srv.raster_ds_id::text 
FROM 
    simidb.simi.simidata_raster_ds AS srd 
    LEFT JOIN simidb.simi.simidata_raster_view AS srv
    ON srv.raster_ds_id = srd.id 
WHERE 
    srv.raster_ds_id IS NULL 
;

-- Funktioniert ab V1.2 ohne GDAL.
COPY simiRasterOhneDatasetView TO '/tmp/qmbetrieb/simi_raster_ohne_datasetview.xlsx' WITH (FORMAT GDAL, DRIVER 'xlsx');

