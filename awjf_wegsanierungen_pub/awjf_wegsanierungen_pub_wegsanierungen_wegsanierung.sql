SELECT
    wegsanierungen_wegsanierung.id_wegsanierung,
    wegsanierungen_wegsanierung.projekt_nr,
    wegsanierungen_wegsanierung.aname,
    wegsanierungen_wegsanierung.projekt,
    ST_Length(wegsanierungen_wegsanierung.geometrie) AS laenge_gemessen,
    wegsanierungen_wegsanierung.laenge_beitrag,
    wegsanierungen_wegsanierung.status,
    wegsanierungen_wegsanierung.fid_ges_nr,
    wegsanierungen_wegsanierung.jahr,
    wegsanierungen_wegsanierung.kosten,
    wegsanierungen_wegsanierung.beitrag,
    wegsanierungen_wegsanierung.bemerkung,
    wegsanierungen_wegsanierung.id_reserve,
    wegsanierungen_wegsanierung.geometrie
FROM
    awjf_wegsanierungen.wegsanierungen_wegsanierung
;