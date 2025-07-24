CREATE TABLE infofauna_nests AS 
    SELECT 
        * EXCLUDE(geom, statut),
        ST_AsText(geom) AS geometrie,  -- WKT
        CASE
            WHEN statut = 'actif' THEN 'bestehend'
            WHEN statut = 'detruit' THEN 'zerstoert'
            ELSE 'bestehend'  -- bei ungültiger Angabe 'bestehend' annehmen, da in Layer "active_nests"
        END AS import_nest_status,
        round(ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lat,
        round(ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lon
    FROM ST_Read(${active_nests_path})
    UNION 
    SELECT 
        * EXCLUDE(geom, statut),
        ST_AsText(geom) AS geometrie,  -- WKT
        CASE
            WHEN statut = 'actif' THEN 'bestehend'
            WHEN statut = 'detruit' THEN 'zerstoert'
            ELSE 'zerstoert'  -- bei ungültiger Angabe 'zerstoert' annehmen, da in Layer "unactive_nests"
        END AS import_nest_status,
        round(ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lat,
        round(ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lon
    FROM ST_Read(${unactive_nests_path})
;