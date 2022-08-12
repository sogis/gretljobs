SELECT
    geometrie,
    kurventyp,
    kurventyp.dispname AS kurventyp_txt,
    kote,
    bearbeiter,
    erfassung
FROM
    afu_grundwassergeometrie_v1.isohypse_mittlerer_grundwasserstand AS isohypse
    LEFT JOIN afu_grundwassergeometrie_v1.isohypse_kurventyp AS kurventyp
    ON isohypse.kurventyp = kurventyp.ilicode
;
