CREATE TABLE infofauna_nests AS 
    SELECT 
        * EXCLUDE(geom),
        ST_AsText(geom) AS geometrie,  -- WKT
        ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')) AS import_lat,
        ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')) AS import_lon
    FROM ST_Read(${active_nests_path})
    UNION 
    SELECT 
        * EXCLUDE(geom),
        ST_AsText(geom) AS geometrie,  -- WKT
        ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')) AS import_lat,
        ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')) AS import_lon
    FROM ST_Read(${unactive_nests_path})
;