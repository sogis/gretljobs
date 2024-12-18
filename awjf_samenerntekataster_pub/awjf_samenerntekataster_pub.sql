SELECT
    sek.oecd,
    REPLACE(REPLACE(REPLACE(sek.baumart, '{', ''), '}', ''), ',', ', ') AS baumart,
    sek.herkunft,
    CASE 
        WHEN sek.hoehe_untergrenze IS NOT NULL OR sek.hoehe_obergrenze IS NOT NULL
            THEN concat(sek.hoehe_untergrenze, ' - ', sek.hoehe_obergrenze)
        ELSE 
            NULL
    END AS hoehenbereich,
    sek.exposition,
    sek.geologie,
    sek.geometrie,
    string_agg(DISTINCT gemeinde.gemeindename, ', ') AS gemeindenamen,
    string_agg(DISTINCT forstkreis.aname, ', ') AS forstkreis,
    string_agg(DISTINCT forstrevier.aname, ', ') AS forstrevier,
    (st_area(sek.geometrie)/10000) AS flaeche_hektar,
    sek.bemerkung
FROM
    awjf_samenerntekataster_v1.flaeche AS sek          
JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde
    ON ST_Intersects(sek.geometrie, gemeinde.geometrie)
JOIN awjf_forstreviere.forstreviere_forstreviergeometrie AS forstgeometrie
    ON ST_Intersects(sek.geometrie, forstgeometrie.geometrie)
LEFT JOIN awjf_forstreviere.forstreviere_forstkreis AS forstkreis
    ON forstgeometrie.forstkreis = forstkreis.t_id
LEFT JOIN awjf_forstreviere.forstreviere_forstrevier AS forstrevier
    ON forstgeometrie.forstrevier = forstrevier.t_id
GROUP BY 
    sek.oecd,
    sek.baumart,
    sek.herkunft,
    sek.hoehe_untergrenze,
    sek.hoehe_obergrenze,
    sek.exposition,
    sek.geologie,
    sek.geometrie,
    sek.bemerkung