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
    SELECT 'ch.so.agi.av.grundstuecke.projektierte'::text AS subclass,
    grundsteuck_proj.t_id AS id_in_class,
    grundsteuck_proj.nummer AS name_in_class,
        CASE
            WHEN grundsteuck_proj.grundbuch::text = grundsteuck_proj.gemeinde::text THEN
            CASE
                WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' (Proj. Baurecht)')
                WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' (Proj. Quellenrecht)')
                ELSE concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' (Proj. Liegenschaft)')
            END
            ELSE
            CASE
                WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' [', grundsteuck_proj.gemeinde, '] (Proj. Baurecht)')
                WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' [', grundsteuck_proj.gemeinde, '] (Proj. Quellenrecht)')
                ELSE concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' [', grundsteuck_proj.gemeinde, '] (Proj. Liegenschaft)')
            END
        END AS displaytext,
        CASE
            WHEN grundsteuck_proj.grundbuch::text = grundsteuck_proj.gemeinde::text THEN concat(grundsteuck_proj.nummer, ' ', grundsteuck_proj.grundbuch)
            ELSE concat(grundsteuck_proj.nummer, ' ', grundsteuck_proj.grundbuch, ' ', grundsteuck_proj.gemeinde)
        END AS part_1,
    (st_asgeojson(st_envelope(grundsteuck_proj.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
        CASE
            WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr gbnr Grundstück Projektiert SDR Baurecht ')
            WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr gbnr Grundstück Projektiert Quellenrecht ')
            ELSE concat('GB-Nr gbnr Grundstück Projektiert Parzelle Liegenschaft ')
        END AS part_3
    FROM mopublic_grundstueck_proj grundsteuck_proj
    UNION ALL
    SELECT 'ch.so.agi.av.grundstuecke.projektierte'::text AS subclass,
    grundsteuck_proj.t_id AS id_in_class,
    grundsteuck_proj.egrid AS name_in_class,
        CASE
            WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('EGRID: ', grundsteuck_proj.egrid, ' (Proj. Baurecht)')
            WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('EGRID: ', grundsteuck_proj.egrid, ' (Proj. Quellenrecht)')
            ELSE concat('EGRID: ', grundsteuck_proj.egrid, ' (Proj. Liegenschaft)')
        END AS displaytext,
    grundsteuck_proj.egrid AS part_1,
    (st_asgeojson(st_envelope(grundsteuck_proj.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
        CASE
            WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('EGRID Projektiert Baurecht')
            WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('EGRID Projektiert Quellenrecht')
            ELSE concat('EGRID Projektiert Liegenschaft')
        END AS part_3
    FROM mopublic_grundstueck_proj grundsteuck_proj
    WHERE grundsteuck_proj.egrid IS NOT NULL
)
SELECT
    displaytext AS anzeige,
    lower((part_1 || ' '::text) || index_base.part_3) AS suchbegriffe,
    subclass AS layer_ident,
    bbox as ausdehnung,
    id_in_class::text AS id_feature,
    't_id'::text as id_spalten_name,
    false as id_in_hochkomma
FROM
    index_base
;
