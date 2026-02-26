SET search_path to agi_mopublic_pub, public;

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
        id AS id_in_class,
        concat(strassenname, ' | ', bfs_nr, ' ' , gemeindename, ' (Strasse)' )  AS displaytext,
        concat(strassenname, ' | ', bfs_nr, ' ' , gemeindename, ' (Strasse)' ) AS part_1,
        'Strassenachse Name '::text AS part_3,
        (st_asgeojson(st_envelope(geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        mopublic_strassenachse_search_v
    WHERE
        strassenname IS NOT NULL
)
SELECT
    displaytext AS anzeige,
    lower((part_1 || ' '::text) || index_base.part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    'id'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
