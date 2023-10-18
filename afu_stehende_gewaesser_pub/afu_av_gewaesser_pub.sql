SELECT 
    aname,
    bodenbedeckung_boflaeche.geometrie,
    typ,
    gemeindename,
    erhebung_abgeschlossen
FROM 
    afu_stehende_gewaesser_v1.av_gewaesser
    INNER JOIN agi_dm01avso24.bodenbedeckung_boflaeche
    ON art = 'Gewaesser.stehendes' AND ST_Within(av_gewaesser.geometrie, bodenbedeckung_boflaeche.geometrie)
;
