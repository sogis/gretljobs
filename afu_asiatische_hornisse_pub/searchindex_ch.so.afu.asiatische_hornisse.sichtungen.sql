-- TRIGRAMM SUCHINDEX: UPDATE FEATURES

SET search_path to afu_asiatische_hornisse_pub_v2, public;

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
        t_id AS id_in_class,
        concat('Sichtung: ', import_occurrence_id, ' (Occurrence-ID)') AS displaytext,
        import_occurrence_id AS part_1,
        'Occurrence-ID Sichtungen Meldungen'::text AS part_3,  -- Begriffe in Mehrzahl, weil auch Wortteile gefunden werden
        (st_asgeojson(st_envelope(geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        asia_hornisse_sichtung
    WHERE
        import_occurrence_id IS NOT NULL
)
SELECT
    displaytext AS anzeige,
    lower((part_1 || ' '::text) || part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    't_id'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
