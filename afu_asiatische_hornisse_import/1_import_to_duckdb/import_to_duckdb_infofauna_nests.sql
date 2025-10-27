CREATE TABLE infofauna_nests (
	id                  VARCHAR,
	nid_id              INTEGER,
	classification      VARCHAR,
	date_decouverte     DATE,
    date_destroyed      DATE,
	last_modification   VARCHAR,
	lv95_east_x         INTEGER,
	lv95_north_y        INTEGER,
	canton              VARCHAR,
	"url"               VARCHAR,
	"location"          VARCHAR,
	ckm2                INTEGER,
	materialentityid    VARCHAR,
	"image"             VARCHAR,
	remarques           VARCHAR,
	jj                  INTEGER,
	mm                  INTEGER,
	yy                  INTEGER,
	geometrie           VARCHAR,  -- WKT
    import_nest_status  VARCHAR,
	import_lat          NUMERIC(8,6),
	import_lon          NUMERIC(8,6)
);

-- Alles einzufügen versuchen (SELECT *), damit wir mitbekommen, wenn neue Felder in den WFS aufgenommen
-- werden (auf die wir warten). Explizit machen, sobald der WFS vollständige Informationen liefert.
-- "date_destroyed" aktuell ignoriert weil in falschem Format geliefert (Text, inkonsistent formatiert)
INSERT INTO infofauna_nests BY NAME
    SELECT 
        * EXCLUDE(geom, statut, observer, remarques, submission_id, date_destroyed),
        ST_AsText(geom) AS geometrie,
        CASE
            WHEN statut = 'actif' THEN 'bestehend'
            WHEN statut = 'detruit' THEN 'zerstoert'
            ELSE 'bestehend'  -- bei ungültiger Angabe 'bestehend' annehmen, da in Layer "active_nests"
        END AS import_nest_status,
        round(ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6) AS import_lat,
        round(ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6) AS import_lon,
		-- 29.09.2025: infofauna hat Felder aufgesplittet. Altes Verhalten reproduzieren
        nullif(concat_ws(' | ', trim(observer), trim(remarques), 'Meldung: ' || trim(submission_id)), '') AS remarques
    FROM ST_Read(${wfs_url_active_nests})
    UNION 
    SELECT 
        * EXCLUDE(geom, statut, observer, remarques, submission_id, date_destroyed),
        ST_AsText(geom) AS geometrie,
        CASE
            WHEN statut = 'actif' THEN 'bestehend'
            WHEN statut = 'detruit' THEN 'zerstoert'
            ELSE 'zerstoert'  -- bei ungültiger Angabe 'zerstoert' annehmen, da in Layer "unactive_nests"
        END AS import_nest_status,
        round(ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lat,
        round(ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6)::NUMERIC(8,6) AS import_lon,
		-- 29.09.2025: infofauna hat Felder aufgesplittet. Altes Verhalten reproduzieren
        nullif(concat_ws(' | ', trim(observer), trim(remarques), 'Meldung: ' || trim(submission_id)), '') AS remarques
    FROM ST_Read(${wfs_url_unactive_nests})
;