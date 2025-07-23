CREATE TABLE infofauna_individuals AS 
    SELECT 
        *
        --* EXCLUDE(geom),  --tbd check if converson required
        --ST_AsText(geom) AS wkt
    FROM ST_Read(${individuals_path})
;

CREATE TABLE infofauna_nests AS 
    SELECT 
        *
        --* EXCLUDE(geom),  --tbd check if converson required
        --ST_AsText(geom) AS wkt
    FROM ST_Read(${active_nests_path})
    UNION 
    SELECT 
        *
        --* EXCLUDE(geom),  --tbd check if converson required
        --ST_AsText(geom) AS wkt
    FROM ST_Read(${unactive_nests_path})
;

CREATE TABLE afu_individuals (
    import_occurrence_id            VARCHAR,
    import_unique_nest_id           VARCHAR,
    import_bienenstand_nr           VARCHAR,
    import_vor_10_uhr               INTEGER,
    import_zwischen_10_und_13_uhr   INTEGER,
    import_zwischen_13_und_17_uhr   INTEGER,
    import_nach_17_uhr              INTEGER,
    geometrie                       GEOMETRY,
    import_materialentity_id        VARCHAR PRIMARY KEY,
    import_datum_sichtung           DATE,
    import_ort                      VARCHAR,
    import_kanton                   VARCHAR,
    import_x_koordinate             INTEGER,
    import_y_koordinate             INTEGER,
    import_kontakt_name             VARCHAR,
    import_kontakt_mail             VARCHAR,
    import_kontakt_tel              VARCHAR,
    import_bemerkung                VARCHAR,
    import_url                      VARCHAR,
    import_foto_url                 VARCHAR
);

INSERT INTO afu_individuals
    SELECT
        import_occurrence_id,
        import_unique_nest_id,
        import_bienenstand_nr,
        import_vor_10_uhr,
        import_zwischen_10_und_13_uhr,
        import_zwischen_13_und_17_uhr,
        import_nach_17_uhr,
        geometrie,
        import_materialentity_id,
        import_datum_sichtung,
        import_ort,
        import_kanton,
        import_x_koordinate,
        import_y_koordinate,
        import_kontakt_name,
        import_kontakt_mail,
        import_kontakt_tel,
        import_bemerkung,
        import_url,
        import_foto_url
    FROM editdb.afu_asiatische_hornisse_v2.asia_hornisse_sichtung
;