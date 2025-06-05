SET search_path to avt_kantonsstrassen_pub, public;

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
        ${layername}::text AS subclass,
        achsenumme AS id_in_class,
        concat('Nr. ', achsenumme, ' (Kantonsstrasse Achse)') AS displaytext,
        achsenumme AS part_1,
        'Kantonsstrasse Nr'::text AS part_3,
        (st_asgeojson(st_envelope(st_collect(geometrie)), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        achse
    WHERE
        achsenumme IS NOT NULL
    GROUP BY
        achsenumme
)
SELECT
    displaytext AS anzeige,
    lower((part_1 || ' '::text) || index_base.part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    'achsenumme'::text as id_spalten_name,
    true as id_in_hochkomma
FROM
    index_base
;
