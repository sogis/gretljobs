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
        concat(ms.strassenname, '.', mg.gemeindename ) AS id_in_class,
        ms.strassenname AS name_in_class,
        concat(ms.strassenname, ' | ', mg.gemeindename, ' (Strasse)' )  AS displaytext,
        concat(ms.strassenname, ' ',mg.gemeindename) AS part_1,
        'Strassenachse Name '::text AS part_3,
        (st_asgeojson(st_envelope(st_collect(ms.geometrie)), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        mopublic_strassenachse ms
        JOIN mopublic_gemeindegrenze mg
            ON ms.bfs_nr = mg.bfs_nr 
    WHERE
        ms.strassenname IS NOT NULL
    GROUP BY
        ms.strassenname, mg.gemeindename
)
SELECT
    displaytext AS anzeige,
    lower((part_1 || ' '::text) || index_base.part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    'id_in_class'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
