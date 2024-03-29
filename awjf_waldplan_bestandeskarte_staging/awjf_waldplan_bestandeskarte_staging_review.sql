SELECT
    geometrie,
    id_wp,
    fid_amtei,
    fid_fk,
    fid_fr,
    wirt_zone,
    gem_bfs,
    fid_we,
    gb_flaeche,
    we_text,
    fid_eigcod,
    fid_eig,
    fid_prod,
    wpnr,
    wptyp,
    betriebsteil,
    fid_abt,
    bstnr,
    bsttyp,
    wpinfo,
    bemerkung,
    flae_gis,
    zeitstand,
    beschrift,
    x_beschr,
    y_beschr,
    objnummer,
    weidewald,
    gb_gem_bfs,
    astatus,
    wap_vollstaendig
FROM
    awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte
WHERE
    astatus = 'Review'
;
