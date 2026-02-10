SELECT 
    zaehlstelle.bezeichnung, 
    json_agg(json_build_object('Bezeichnung', dok.bezeichnung, 'Link', link, 'Jahr', jahr)) AS dokumente, 
    gemeinde.geometrie 
FROM 
    avt_verkehrszaehlstellen_v1.staedtische_verkehrszaehlung zaehlstelle
LEFT JOIN 
    avt_verkehrszaehlstellen_v1.dokument dok
    ON 
    dok.zaehlstelle_staedtische_verkehrszaehlung = zaehlstelle.t_id
LEFT JOIN 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinde  
    ON 
    st_dwithin(zaehlstelle.geometrie, gemeinde.geometrie,0)
GROUP BY 
    zaehlstelle.bezeichnung, 
    gemeinde.geometrie