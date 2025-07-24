CREATE TABLE infofauna_individuals AS 
    SELECT 
        * EXCLUDE(geom),
        ST_AsText(geom) AS geometrie,  -- WKT
        round(ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lat,
        round(ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lon
    FROM ST_Read(${individuals_path})
;