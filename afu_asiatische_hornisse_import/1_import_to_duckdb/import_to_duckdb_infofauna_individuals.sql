CREATE TABLE infofauna_individuals (
	id                  VARCHAR,
	nid_unique_id       INTEGER,
	occurence_id        VARCHAR,
	date_decouverte     DATE,
	last_modification   VARCHAR,
	lv95_east_x         INTEGER,
	lv95_north_y        INTEGER,
	"location"          VARCHAR,
	canton              VARCHAR,
	ckm2                INTEGER,
	materialentityid    VARCHAR,
	"image"             VARCHAR,
	remarques           VARCHAR,
	jj                  INTEGER,
	mm                  INTEGER,
	yy                  INTEGER,
	geometrie           VARCHAR,  -- WKT
	import_lat          NUMERIC(8,6),
	import_lon          NUMERIC(8,6)
);

-- Alles einzufügen versuchen (SELECT *), damit wir mitbekommen, wenn neue Felder in den WFS aufgenommen
-- werden (auf die wir warten). Explizit machen, sobald der WFS vollständige Informationen liefert.
-- "date_destroyed" wird ignoriert, da sinnbefreit im individuals Layer und ohne Entsprechung im Datenmodell.
INSERT INTO infofauna_individuals BY NAME
    SELECT
        * EXCLUDE(geom, observer, remarques, submission_id, date_destroyed),
        ST_AsText(geom) AS geometrie,
        round(ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6) AS import_lat,
        round(ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6) AS import_lon,
		-- 29.09.2025: infofauna hat Felder aufgesplittet. Altes Verhalten reproduzieren
        nullif(concat_ws(' | ', trim(observer), trim(remarques), 'Meldung: ' || trim(submission_id)), '') AS remarques
    FROM ST_Read(${wfs_url_individuals})
;