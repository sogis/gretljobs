CREATE TABLE infofauna_individuals AS 
    SELECT 
        * EXCLUDE(geom),
        ST_AsText(geom) AS geometrie,  -- WKT
        ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')) AS import_lat,
        ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')) AS import_lon
    FROM ST_Read(${individuals_path})
;