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
    sw_info_fl,
    zeitstand,
    beh_einheit
FROM
    awjf_work.sw_info
WHERE
    archive = 0
;