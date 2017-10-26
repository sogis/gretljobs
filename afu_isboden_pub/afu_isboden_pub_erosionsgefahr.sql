SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    grid_code
FROM
    afu_isboden.erosionsgefahr_qgis_server_client_t
WHERE 
    archive = 0
