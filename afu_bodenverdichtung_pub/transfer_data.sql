SELECT 
    h.risiko,
    e.dispname AS risiko_txt,
    h.geometrie
FROM 
    afu_bodenverdichtung_v1.bodenverdichtung_hinweiskarte h
    LEFT JOIN 
        afu_bodenverdichtung_v1.bodenverdichtung_bodenverdichtung_typ e
            ON h.risiko = e.ilicode
;