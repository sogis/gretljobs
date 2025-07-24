SELECT
    import_nest_id,
    import_status,
    NULL::DATE AS import_datum_behandlung,  -- noch nicht verfügbar
    geometrie,
    import_materialentity_id,
    import_datum_sichtung,
    import_ort,
    import_kanton,
    import_x_koordinate,
    import_y_koordinate,
    import_lat,
    import_lon,
    NULL::TEXT AS import_kontakt_name,      -- noch nicht verfügbar
    NULL::TEXT AS import_kontakt_mail,      -- noch nicht verfügbar
    NULL::TEXT AS import_kontakt_tel,       -- noch nicht verfügbar
    import_bemerkung,
    import_url,
    import_foto_url
FROM afu_nests;