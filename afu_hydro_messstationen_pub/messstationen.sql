SELECT 
    typ, 
    '' AS typ_txt, 
    aname, 
    gemeindegrenzen.gemeindename AS gemeinde, 
    stationsnummer, 
    st_x(messstation.geometrie) AS x, 
    st_y(messstation.geometrie) AS y, 
    daten_seit, 
    astatus, 
    '' AS astatus_txt,
    bemerkung, 
    bild,
    link, 
    messstation.geometrie
FROM 
    afu_hydro_messstationen_v1.messstationen messstation
LEFT JOIN 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze_generalisiert gemeindegrenzen 
    ON 
    st_dwithin(messstation.geometrie, gemeindegrenzen.geometrie,0)