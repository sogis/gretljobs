SELECT
    geometrie,
    nummer,
    flaeche,
    typ,
    typ_code.dispname AS typ_txt,
    aggloprogramm,
    aggloprogramm::text AS aggloprogramm_txt,
    lufttemperatur_14uhr,
    pet_14uhr,
    lufttemperatur_04uhr
FROM
    afu_klimaanalyse_v1.entwicklungsflaechen
    LEFT JOIN afu_klimaanalyse_v1.entwicklungsflaechen_typ AS typ_code
      ON typ = typ_code.ilicode
;
