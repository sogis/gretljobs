SELECT
    t_ili_tid,
    import_occurrence_id,
    import_unique_nest_id,
    NULL::TEXT AS import_bienenstand_nr,        -- noch nicht verfügbar
    NULL::INT AS import_vor_10_uhr,             -- noch nicht verfügbar
    NULL::INT AS import_zwischen_10_und_13_uhr, -- noch nicht verfügbar
    NULL::INT AS import_zwischen_13_und_17_uhr,	-- noch nicht verfügbar
    NULL::INT AS import_nach_17_uhr,            -- noch nicht verfügbar
    massnahmenstatus,
    bemerkung_massnahme,
    geometrie,
    import_materialentity_id,
    import_datum_sichtung,
    import_ort,
    import_kanton,
    import_x_koordinate,
    import_y_koordinate,
    import_lat,
    import_lon,
    NULL::TEXT AS import_kontakt_name,  -- noch nicht verfügbar
    NULL::TEXT AS import_kontakt_mail,  -- noch nicht verfügbar
    NULL::TEXT AS import_kontakt_tel,   -- noch nicht verfügbar
    import_bemerkung,
    NULL::TEXT AS import_url,           -- noch nicht verfügbar bei individuals
    import_foto_url
FROM afu_individuals;