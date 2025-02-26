ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiRasterOhneDatasetView AS
SELECT 
    srd."path" AS raster_path,
    srv.raster_ds_id::text AS raster_ds_id
FROM 
    simidb.simi.simidata_raster_ds AS srd 
    LEFT JOIN simidb.simi.simidata_raster_view AS srv
    ON srv.raster_ds_id = srd.id 
WHERE 
    srv.raster_ds_id IS NULL 
;

COPY simiRasterOhneDatasetView TO '/tmp/qmbetrieb/simi_raster_ohne_datasetview.csv' (HEADER, DELIMITER ';');


