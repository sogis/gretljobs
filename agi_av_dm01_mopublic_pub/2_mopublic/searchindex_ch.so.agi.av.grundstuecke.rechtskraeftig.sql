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
    SELECT ${layername}::text AS subclass,
    grundstueck.t_id AS id_in_class,
    grundstueck.nummer AS name_in_class,
        CASE
            WHEN grundstueck.grundbuch::text = grundstueck.gemeinde::text THEN
            CASE
                WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' (Baurecht)')
                WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' (Quellenrecht)')
                ELSE concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' (Liegenschaft)')
            END
            ELSE
            CASE
                WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' [', grundstueck.gemeinde, '] (Baurecht)')
                WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' [', grundstueck.gemeinde, '] (Quellenrecht)')
                ELSE concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' [', grundstueck.gemeinde, '] (Liegenschaft)')
            END
        END AS displaytext,
        CASE
            WHEN grundstueck.grundbuch::text = grundstueck.gemeinde::text THEN concat(grundstueck.nummer, ' ', grundstueck.grundbuch)
            ELSE concat(grundstueck.nummer, ' ', grundstueck.grundbuch, ' ', grundstueck.gemeinde)
        END AS part_1,
    (st_asgeojson(st_envelope(grundstueck.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
        CASE
            WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr gbnr Grundstück SDR Baurecht')
            WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr gbnr Grundstück Quellenrecht')
            ELSE concat('GB-Nr gbnr Grundstück Parzelle Liegenschaft')
        END AS part_3
    FROM mopublic_grundstueck grundstueck
    UNION ALL
    SELECT ${layername}::text AS subclass,
    grundstueck.t_id AS id_in_class,
    grundstueck.egrid AS name_in_class,
        CASE
            WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('EGRID: ', grundstueck.egrid, ' (Baurecht)')
            WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('EGRID: ', grundstueck.egrid, ' (Quellenrecht)')
            ELSE concat('EGRID: ', grundstueck.egrid, ' (Liegenschaft)')
        END AS displaytext,
    grundstueck.egrid AS part_1,
    (st_asgeojson(st_envelope(grundstueck.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
        CASE
            WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('Baurecht EGRID')
            WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('Quellenrecht EGRID')
            ELSE concat('Liegenschaft EGRID')
        END AS part_3
    FROM mopublic_grundstueck grundstueck
    WHERE grundstueck.egrid IS NOT NULL
)
SELECT
    displaytext AS anzeige,
    lower(concat(part_1, ' abcdefg')) AS rangbegriffe,
    lower((part_1 || ' '::text) || index_base.part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    't_id'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
