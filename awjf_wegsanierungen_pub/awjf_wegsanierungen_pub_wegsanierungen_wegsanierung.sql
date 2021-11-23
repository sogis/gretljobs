SELECT
    id_wegsanierung,
    projekt,
    projekt_nr,
    aname,
    ST_Length(geometrie) AS laenge_gemessen,
    laenge_beitrag,
    fid_ges_nr,
    jahr,
    kosten,
    beitrag,
    bemerkung,
    id_reserve,
    geometrie,
    astatus
FROM
    awjf_wegsanierungen_v1.wegsanierungen_wegsanierung
;
