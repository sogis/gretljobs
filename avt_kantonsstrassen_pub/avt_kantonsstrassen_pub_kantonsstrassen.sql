SELECT
    ST_Multi(ST_Linemerge(ST_Union(geometrie))) AS geometrie,
    "KSNr" AS ksnr,
    "Strassentyp" AS strassentyp
FROM
    strassennetz.klasse_kategorie
WHERE
    "Strasseneigner" = 'Kanton'
GROUP BY
    "KSNr",
    "Strassentyp"
;