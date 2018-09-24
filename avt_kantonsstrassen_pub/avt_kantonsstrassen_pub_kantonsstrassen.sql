SELECT
    eid AS t_id,
    ST_Multi(ST_Linemerge(ST_Union(geometrie))) AS geometrie,
    "name",
    plz_ortschaft,
    klasse,
    kategorie,
    "KSNr" AS ksnr,
    "Strassentyp" AS strassentyp,
    "Strasseneigner" AS strasseneigner,
    "OeV-Nutzung" AS oev_nutzung,
    "ObjectID" AS objectid,
    "AGI_Strid" AS agi_strid,
    "AV_Seq" AS av_seq,
    "AGr" AS agr,
    istoffiziellebezeichnung
FROM
    strassennetz.klasse_kategorie
;