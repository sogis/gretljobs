SELECT 
    aname,
    bodenbedeckung.geometrie,
    typ,
    gemeindename,
    erhebung_abgeschlossen,
    av_geometrie,
    av_link
FROM 
    afu_stehende_gewaesser_v1.stehendes_gewaesser AS stehendes_gewaesser
    LEFT JOIN agi_dm01avso24.bodenbedeckung_boflaeche AS bodenbedeckung
    ON art = 'Gewaesser.stehendes' AND ST_Within(ST_PointOnSurface(stehendes_gewaesser.geometrie), bodenbedeckung.geometrie)
WHERE
    av_geometrie IS TRUE
AND
    av_link IS TRUE
;
