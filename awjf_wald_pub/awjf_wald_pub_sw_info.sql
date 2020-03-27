SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    id_wp,
    gem_bfs,
    fid_we,
    we_text,
    fid_eigcod,
    wpnr,
    wptyp,
    betriebsteil,
    wpinfo,
    bemerkung,
    id_sw_info,
    sw_name,
    z_typ,
    nais_code,
    CASE
        WHEN nais_code = 11
        THEN 'Handlungsbedarf vorhanden, Dringlichkeit klein'
        WHEN nais_code = 12
        THEN 'Handlungsbedarf vorhanden, Dringlichkeit mittel'
        WHEN nais_code = 13
        THEN 'Handlungsbedarf vorhanden, Dringlichkeit gross'
        WHEN nais_code = 20
        THEN 'kein Handlungsbedarf, keine Priorität'
        WHEN nais_code = 99
        THEN 'keine Ansprache durchgeführt'
        WHEN nais_code = 10
        THEN 'ohne Ansprache (Strasse etc.)'
    END AS nais_code_txt,
    sw_info_fl,
    zeitstand,
    beh_einheit, 
    CASE 
        WHEN z_typ = 1 
        THEN 'Sturz Entstehungsgebiet'
        WHEN z_typ = 2
        THEN 'Sturz Transitgebiet'
        WHEN z_typ = 3 
        THEN 'Sturz Ablagerungsgebiet'
        WHEN z_typ = 4 
        THEN 'Rutschung Entstehungsgebiet'
        WHEN z_typ = 5 
        THEN 'Rutschung Reserve'
        WHEN z_typ = 6
        THEN 'Wald in Gerinneeinhängen'
    END AS z_typ_txt
FROM
    awjf_work.sw_info
WHERE
    archive = 0
;
