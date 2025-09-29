SELECT
    gen_random_uuid()   AS t_ili_tid,  -- neue Records benötigen eine OID, obwohl bei Kill & Fill sinnlos
    nid_id              AS import_nest_id,
    import_nest_status,
    NULL::DATE          AS import_datum_behandlung,
    geometrie,
    materialentityid    AS import_materialentity_id,
    date_decouverte     AS import_datum_sichtung,
    "location"          AS import_ort,
    canton              AS import_kanton,
    lv95_east_x         AS import_x_koordinate,
    lv95_north_y        AS import_y_koordinate,
    import_lat,
    import_lon,
    NULL::TEXT          AS import_kontakt_name,      -- noch nicht verfügbar
    NULL::TEXT          AS import_kontakt_mail,      -- noch nicht verfügbar
    NULL::TEXT          AS import_kontakt_tel,       -- noch nicht verfügbar
    remarques           AS import_bemerkung,
    "url"               AS import_url,
    "image"             AS import_foto_url
FROM infofauna_nests;