SET search_path to agi_hoheitsgrenzen_pub, public;

INSERT INTO ${db_schema}.feature (
    anzeige,            -- Anzeigetext
    rangbegriffe,       -- Begriffe für das Ranking der Suchresulate
    suchbegriffe,       -- Suchbegriffe für den Index
    layer_ident,        -- Layer-Identifikation
    ausdehnung,         -- Geometrische Ausdehnung als Text
    id_feature,         -- ID des Features
    id_spalten_name,    -- Spaltenname, z. B. 't_id'
    id_in_hochkomma     -- Wahrheitswert für ID-In-Hochkomma
)
WITH
index_base AS (
    SELECT
        'ch.so.agi.gemeindegrenzen'::text AS subclass,
        t_id AS id_in_class,
        concat(gemeindename, ' | ', bfs_gemeindenummer, ' (Gemeinde)') AS displaytext,
        concat(gemeindename, ' ', bfs_gemeindenummer) AS part_1,
        'Gemeinde BFS-Nr Name'::text AS part_3,
        (st_asgeojson(st_envelope(geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        hoheitsgrenzen_gemeindegrenze
)
SELECT
    displaytext AS anzeige,
    lower(part_1) AS rangbegriffe,
    lower((part_1 || ' '::text) || part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    't_id'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
