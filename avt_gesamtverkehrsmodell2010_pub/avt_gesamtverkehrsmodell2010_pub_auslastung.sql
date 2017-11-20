SELECT 
    ogc_fid AS t_id,
    so_id,
    nummer,
    sostrid,
    wkb_geometry AS geometrie,
    so_typ,
    ausl_kat_2010
    ausl_kat_2020,
    ausl_kat_2030
FROM
    verkehrsmodell2013.auslastung_kat
;