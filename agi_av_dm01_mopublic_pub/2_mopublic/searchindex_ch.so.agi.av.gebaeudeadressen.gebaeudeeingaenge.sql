SET search_path to agi_mopublic_pub, public;

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
        ${layername}::text AS subclass,
        t_id AS id_in_class,
        concat(strassenname, ' ', hausnummer, ', ', plz, ' ', ortschaft, ' (Adresse)') AS displaytext,
        concat(strassenname, ' ', hausnummer, ' ', plz, ' ', ortschaft) AS part_1,
        concat(strassenname, ' ', hausnummer) AS rank,
        'Adresse'::text AS part_3,
        (st_asgeojson(st_envelope(lage), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        mopublic_gebaeudeadresse
    WHERE
        strassenname IS NOT NULL AND hausnummer IS NOT NULL AND ist_offizielle_bezeichnung IS TRUE
)
SELECT
    displaytext AS anzeige,
    rank as rangbegriffe,
    lower((part_1 || ' '::text) || index_base.part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    't_id'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
