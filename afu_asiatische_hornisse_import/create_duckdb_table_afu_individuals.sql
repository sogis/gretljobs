CREATE TABLE afu_individuals (
    import_occurrence_id            VARCHAR,
    import_unique_nest_id           VARCHAR,
    import_bienenstand_nr           VARCHAR,
    import_vor_10_uhr               INTEGER,
    import_zwischen_10_und_13_uhr   INTEGER,
    import_zwischen_13_und_17_uhr   INTEGER,
    import_nach_17_uhr              INTEGER,
    massnahmenstatus                VARCHAR,  -- vom AfU geführtes Feld
    bemerkung_massnahme             VARCHAR,  -- vom AfU geführtes Feld
    geometrie                       TEXT,     -- WKT
    import_materialentity_id        VARCHAR PRIMARY KEY,  -- Upsert ist nur mit Primary Key möglich
    import_datum_sichtung           DATE,
    import_ort                      VARCHAR,
    import_kanton                   VARCHAR,
    import_x_koordinate             INTEGER,
    import_y_koordinate             INTEGER,
    import_lat                      NUMERIC(8,6),
    import_lon                      NUMERIC(8,6),
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
        massnahmenstatus,
        bemerkung_massnahme,
        ST_AsText(geometrie::geometry) AS geometrie,  -- WKT
        import_materialentity_id,
        import_datum_sichtung,
        import_ort,
        import_kanton,
        import_x_koordinate,
        import_y_koordinate,
        import_lat,
        import_lon,
        import_kontakt_name,
        import_kontakt_mail,
        import_kontakt_tel,
        import_bemerkung,
        import_url,
        import_foto_url
    FROM editdb.afu_asiatische_hornisse_v2.asia_hornisse_sichtung
;