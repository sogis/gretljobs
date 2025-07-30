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

-- Alles einzufügen versuchen (SELECT *), damit wir mitbekommen, wenn neue Felder in den
-- WFS aufgenommen werden (auf die wir warten). Explizit machen, sobald vollständig.
INSERT INTO infofauna_individuals BY NAME
    SELECT
        * EXCLUDE(geom),
        ST_AsText(geom) AS geometrie,
        round(ST_X(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6) AS import_lat,
        round(ST_Y(ST_Transform(geom, 'EPSG:2056', 'EPSG:4326')), 6) AS import_lon
    FROM ST_Read(${individuals_path})
;