INSERT INTO ${db_schema}.feature (
    anzeige,            -- Anzeigetext
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
        'ch.so.afu.fliessgewaesser.netz'::text AS subclass,
        gnrso AS id_in_class,
        aname AS name_in_class,
        concat(aname, ' |  Nr. ', gnrso, ' (Fliessgewässer)')  AS displaytext,
        concat(aname, ' | ', gnrso) AS part_1,
        'Fliessgewässer Name Nr'::text AS part_3,
        (st_asgeojson(st_envelope(st_collect(geometrie)), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        afu_gewaesser_gewaessereigenschaften_pub_v1.gewaessereigenschaften
    WHERE
        aname IS NOT NULL
    GROUP BY
        aname, gnrso
)
SELECT
    displaytext AS anzeige,
    lower((part_1 || ' '::text) || index_base.part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    'gnrso'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
