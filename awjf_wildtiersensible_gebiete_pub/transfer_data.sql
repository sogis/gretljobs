SELECT 
    h.fokus,
    e.dispname AS fokus_typ,
    h.geometrie
FROM 
    awjf_wildtiersensible_gebiete_v1.wildtrsnsbl_gbete_gebiet h
    LEFT JOIN 
        awjf_wildtiersensible_gebiete_v1.wildtrsnsbl_gbete_fokus_typ e
            ON h.fokus = e.ilicode
;
