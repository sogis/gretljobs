SELECT 
    ogc_fid AS t_id,
    st_multi(wkb_geometry) AS geometrie,
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
    korr_flae,
    wpflae,
    zeitstand,
    beschrift,
    x_beschr,
    y_beschr,
    objnummer
FROM 
    awjf.wap_bst
WHERE 
    archive = 0
;
