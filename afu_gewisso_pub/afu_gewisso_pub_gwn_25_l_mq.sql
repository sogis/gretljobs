SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    length,
    objectid,
    objectval,
    gewissnr,
    laufnr,
    linst,
    gwlnr,
    bachnr,
    "name",
    unterirdis,
    objectorig,
    yearofchan,
    objectid_1,
    mqn_jahr,
    mqn_jan ,
    mqn_feb,
    mqn_mar,
    mqn_apr,
    mqn_mai,
    mqn_jun,
    mqn_jul,
    mqn_aug,
    mqn_sep,
    mqn_okt,
    mqn_nov,
    mqn_dez,
    regimetyp,
    regimenr,
    abflussvar,
    objectid_g,
    herkunft_r 
FROM
    gewisso.gwn_25_l_mq
WHERE
    archive = 0
;