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
        'ch.so.afu.gewaesserschutz_lw.stall'::text AS subclass,
        id AS id_in_class,
        concat(aname, ' | Stall-ID: ', id, ', Stao-ID: ', standort_id, ' (Stall)') AS part_1,
        concat('Name Bewirtschafter ', stao_name_bewirtschafter) AS part_3,
        (st_asgeojson(st_envelope(geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        afu_igel_pub_v1.igel_stall
)
SELECT
    part_1 AS anzeige,
    lower((part_1 || ' '::text) || part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    'id'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
