SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    achseid,
    achsname,
    achsnummer,
    achstyp,
    achstypnam,
    basispunkt,
    basispun01,
    bezeichnun,
    islabelvis,
    isortbezei,
    modified,
    modifiedby,
    segmentid,
    segmentnr,
    sektorlaen,
    startdista,
    typ,
    typ_bez,
    typ_id,
    versicheru,
    versiche01,
    versiche02
FROM
    avt_ktstr.kantonsstrassen_bezugspunkte
WHERE
    archive = 0
;