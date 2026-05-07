SET search_path to alw_landwirtschaft_tierhaltung_pub_v2, public;

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
        concat('BUR-Nr: ', bur_registernummer_standort, ' (Betriebs- und Unternehmensregister)') AS displaytext,
        bur_registernummer_standort AS part_1,
        'BUR-Nr Betriebs- und Unternehmensregister'::text AS part_3,
        (st_asgeojson(st_envelope(geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        betrbsdttrktrdten_tierstandort
    WHERE
        standorttyp::text != 'Bienenstand'::text AND bur_registernummer_standort != '0'
    UNION
    SELECT
        ${layername}::text AS subclass,
        t_id AS id_in_class,
        concat('TVD-Nr: ', tvd_nummer, ' (Tierverkehrsdatenbank)') AS displaytext,
        tvd_nummer::text AS part_1,
        'TVD-Nr Tierverkehrsdatenbank'::text AS part_3,
        (st_asgeojson(st_envelope(geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox
    FROM
        betrbsdttrktrdten_tierstandort
    WHERE
        standorttyp::text != 'Bienenstand'::text AND tvd_nummer < 99999999
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
