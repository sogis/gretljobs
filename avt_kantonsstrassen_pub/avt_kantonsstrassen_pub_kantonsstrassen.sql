SELECT
    ST_Multi(ST_Linemerge(ST_Union(geometrie))) AS geometrie,
    "name",
    "KSNr" AS ksnr,
    "Strassentyp" AS strassentyp,
    "Strasseneigner" AS strasseneigner
FROM
    strassennetz.klasse_kategorie
WHERE
    "Strasseneigner" = 'Kanton'
;